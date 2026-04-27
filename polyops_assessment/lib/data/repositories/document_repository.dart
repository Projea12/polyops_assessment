import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/utils/file_processing_service.dart';
import '../../domain/entities/connectivity_status.dart';
import '../../domain/entities/document_audit_entry.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/verification_document.dart';
import '../../domain/entities/verification_status.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/i_document_repository.dart';
import '../datasources/local/app_database.dart';
import '../datasources/local/document_dao.dart';
import '../datasources/remote/document_api_service.dart';
import '../datasources/remote/document_websocket_service.dart';
import '../dtos/websocket_message_dto.dart';

@LazySingleton(as: IDocumentRepository)
class DocumentRepository implements IDocumentRepository {
  final DocumentDao _dao;
  final DocumentApiService _api;
  final DocumentWebSocketService _ws;
  final ConnectivityService _connectivity;
  final FileProcessingService _fileService;
  final _uuid = const Uuid();

  StreamSubscription<List<WebSocketMessageDto>>? _wsMsgSub;
  StreamSubscription<WebSocketState>? _wsStateSub;
  StreamSubscription<bool>? _connectivitySub;

  // ── Heartbeat state ───────────────────────────────────────────────────────
  // _lastSeenAt  : when the WebSocket last spoke for a given document
  // _backoffUntil: absolute time before which heartbeat will not poll a document
  //                (set after API failures — exponential backoff per document)
  // _failureCounts: consecutive API failures per document, drives backoff curve
  final Map<String, DateTime> _lastSeenAt = {};
  final Map<String, DateTime> _backoffUntil = {};
  final Map<String, int> _failureCounts = {};
  Timer? _heartbeatTimer;

  static const _heartbeatInterval = Duration(seconds: 5);
  static const _heartbeatTimeout = Duration(seconds: 15);

  // ── Connectivity / reachability ───────────────────────────────────────────
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.offline;
  final _connectivityStatusController =
      StreamController<ConnectivityStatus>.broadcast();
  Timer? _reachabilityTimer;

  DocumentRepository(
    this._dao,
    this._api,
    this._ws,
    this._connectivity,
    this._fileService,
  );

  @PostConstruct()
  void init() {
    _wsStateSub = _ws.stateStream.listen(_onWsStateChange);

    // Batch WebSocket messages: buffer all updates within 100ms and process
    // in a single Drift transaction to avoid N separate stream emissions.
    _wsMsgSub = _ws.messageStream
        .transform(_batchTransformer(const Duration(milliseconds: 100)))
        .listen(_onWsBatch);

    _connectivitySub = _connectivity.onlineStream.listen(_onConnectivityChange);

    // Fire async initialization without blocking DI resolution — keeping
    // init() synchronous ensures the full dependency chain registers as sync
    // factories, so getIt<DocumentBloc>() works without getAsync().
    _initialize().catchError((Object e, StackTrace s) {
      debugPrint('[DocumentRepository] async init failed: $e\n$s');
    });
  }

  Future<void> _initialize() async {
    // Re-hydrate heartbeat from Drift on restart — any non-terminal document
    // that was in-flight before the app was killed gets tracked immediately.
    // Epoch timestamp ensures the first heartbeat tick fires GETs right away.
    final rows = await _dao.getAll();
    for (final row in rows) {
      final status = VerificationStatus.fromApi(row.status);
      if (!_isTerminal(status)) {
        _lastSeenAt[row.id] = DateTime.fromMillisecondsSinceEpoch(0);
        _ws.trackDocument(row.id);
      }
    }
    if (_lastSeenAt.isNotEmpty) _ensureHeartbeatRunning();

    if (_connectivity.isOnline) {
      await _probeAndConnect();
    } else {
      _emitConnectivityStatus(ConnectivityStatus.offline);
    }
  }

  // ── Connectivity status ───────────────────────────────────────────────────

  @override
  ConnectivityStatus get connectivityStatus => _connectivityStatus;

  @override
  Stream<ConnectivityStatus> watchConnectivityStatus() =>
      _connectivityStatusController.stream;

  void _emitConnectivityStatus(ConnectivityStatus status) {
    if (_connectivityStatus == status) return;
    _connectivityStatus = status;
    _connectivityStatusController.add(status);
  }

  // ── WebSocket event handlers ──────────────────────────────────────────────

  void _onWsStateChange(WebSocketState state) {
    switch (state) {
      case WebSocketState.connected:
        _emitConnectivityStatus(ConnectivityStatus.live);
        // Reset timestamps so WS gets a fresh 15s window before heartbeat
        // fires — avoids redundant GETs right after reconnection.
        final now = DateTime.now();
        for (final id in _lastSeenAt.keys) {
          _lastSeenAt[id] = now;
        }
      case WebSocketState.failed:
        if (_connectivity.isOnline) {
          _emitConnectivityStatus(ConnectivityStatus.heartbeat);
        }
      case WebSocketState.disconnected:
      case WebSocketState.connecting:
        break;
    }
  }

  Future<void> _onWsBatch(List<WebSocketMessageDto> messages) async {
    if (messages.isEmpty) return;
    try {
      await _dao.db.transaction(() async {
        for (final msg in messages) {
          final row = await _dao.getById(msg.documentId);
          if (row == null) continue;
          final existing = _dao.mapToEntity(row);
          if (existing.isTerminal) continue;
          final updated = msg.toDomain(existing);
          await _persistUpdate(existing, updated);
          // Reset heartbeat clock and clear any backoff — WS is alive.
          _lastSeenAt[msg.documentId] = DateTime.now();
          _backoffUntil.remove(msg.documentId);
          _failureCounts.remove(msg.documentId);
        }
      });
    } catch (e, st) {
      debugPrint('[DocumentRepository] WS batch error: $e\n$st');
    }
  }

  // ── Connectivity / reachability ───────────────────────────────────────────

  void _onConnectivityChange(bool isOnline) {
    _reachabilityTimer?.cancel();
    if (isOnline) {
      _probeAndConnect();
    } else {
      _emitConnectivityStatus(ConnectivityStatus.offline);
    }
  }

  // Gap 3: connectivity_plus reports interface state, not actual internet.
  // Probe the API before trusting "online" — catches captive portals.
  Future<void> _probeAndConnect() async {
    final reachable = await _api.probe();
    if (reachable) {
      _emitConnectivityStatus(ConnectivityStatus.heartbeat);
      _ws.connect();
    } else {
      _emitConnectivityStatus(ConnectivityStatus.offline);
      _scheduleReachabilityRetry();
    }
  }

  void _scheduleReachabilityRetry() {
    _reachabilityTimer?.cancel();
    _reachabilityTimer = Timer(const Duration(seconds: 30), () async {
      if (!_connectivity.isOnline) return;
      await _probeAndConnect();
    });
  }

  // ── Heartbeat fallback ────────────────────────────────────────────────────

  void _trackForHeartbeat(String id) {
    _lastSeenAt[id] = DateTime.now();
    _ensureHeartbeatRunning();
  }

  void _untrackFromHeartbeat(String id) {
    _lastSeenAt.remove(id);
    _backoffUntil.remove(id);
    _failureCounts.remove(id);
    if (_lastSeenAt.isEmpty) _stopHeartbeat();
  }

  void _ensureHeartbeatRunning() {
    if (_heartbeatTimer != null) return;
    _heartbeatTimer =
        Timer.periodic(_heartbeatInterval, (_) => _checkHeartbeats());
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> _checkHeartbeats() async {
    if (!_connectivity.isOnline) return;

    final now = DateTime.now();
    final stale = _lastSeenAt.entries.where((e) {
      if (now.difference(e.value) <= _heartbeatTimeout) return false;
      final backoff = _backoffUntil[e.key];
      return backoff == null || now.isAfter(backoff);
    }).map((e) => e.key).toList();

    if (stale.isEmpty) return;

    // Gap 1: per-document isolation — one document failing must not block others.
    for (final id in stale) {
      try {
        await _dao.db.transaction(() async {
          final row = await _dao.getById(id);
          if (row == null) { _untrackFromHeartbeat(id); return; }
          final existing = _dao.mapToEntity(row);
          if (existing.isTerminal) { _untrackFromHeartbeat(id); return; }

          // Optimistic rows were never server-confirmed — getStatus would 404
          // in production. Mark rejected so the retry flow surfaces it to the user.
          if (existing.isOptimistic) {
            await _markUploadIncomplete(existing);
            _ws.untrackDocument(id);
            _untrackFromHeartbeat(id);
            return;
          }

          final dto = await _api.getStatus(id, existing.status);
          final updated = dto.toDomain(existing);
          await _persistUpdate(existing, updated);
        });

        // Success — clear failure state and reset the heartbeat clock.
        _failureCounts.remove(id);
        _backoffUntil.remove(id);
        _lastSeenAt[id] = DateTime.now();
      } catch (e, st) {
        // Gap 2: per-document exponential backoff on API failure.
        // 30s → 60s → 120s → 240s → capped at 300s (5 min).
        final count = (_failureCounts[id] ?? 0) + 1;
        _failureCounts[id] = count;
        final backoffSeconds = min(30 * pow(2, count - 1).toInt(), 300);
        _backoffUntil[id] = DateTime.now().add(Duration(seconds: backoffSeconds));
        debugPrint(
          '[DocumentRepository] Heartbeat failed for $id '
          '(attempt $count, retry in ${backoffSeconds}s): $e\n$st',
        );
      }
    }
  }

  // ── Shared persistence ────────────────────────────────────────────────────

  Future<void> _persistUpdate(
    VerificationDocument previous,
    VerificationDocument updated,
  ) async {
    if (previous.status == updated.status &&
        previous.progress == updated.progress) { return; }

    await _dao.updateStatus(
      id: updated.id,
      status: updated.status.apiValue,
      progress: updated.progress,
      currentStageJson: DocumentDao.stageToJson(updated.currentStage),
      verifiedAt: updated.verifiedAt,
      expiresAt: updated.expiresAt,
      rejectionReason: updated.rejectionReason,
    );

    if (previous.status != updated.status) {
      await _dao.insertAuditEntry(
        DocumentAuditTableCompanion.insert(
          id: _uuid.v4(),
          documentId: updated.id,
          fromStatus: previous.status.apiValue,
          toStatus: updated.status.apiValue,
          note: updated.rejectionReason != null
              ? Value(updated.rejectionReason!)
              : const Value.absent(),
          timestamp: DateTime.now(),
        ),
      );

      if (updated.isTerminal) {
        _ws.untrackDocument(updated.id);
        _untrackFromHeartbeat(updated.id);
      }
    }
  }

  Future<void> _markUploadIncomplete(VerificationDocument doc) async {
    await _dao.updateStatus(
      id: doc.id,
      status: VerificationStatus.rejected.apiValue,
      progress: 0.0,
      currentStageJson: null,
      rejectionReason: 'Upload did not complete — tap to retry',
    );
    await _dao.insertAuditEntry(
      DocumentAuditTableCompanion.insert(
        id: _uuid.v4(),
        documentId: doc.id,
        fromStatus: doc.status.apiValue,
        toStatus: VerificationStatus.rejected.apiValue,
        note: const Value(
            'Upload incomplete — app was killed before server confirmed'),
        timestamp: DateTime.now(),
      ),
    );
  }

  // ── IDocumentRepository ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, VerificationDocument>> uploadDocument({
    required String filePath,
    required DocumentType type,
  }) async {
    try {
      final processed = await _fileService.process(filePath);

      final tempId = _uuid.v4();
      final optimistic = VerificationDocument(
        id: tempId,
        type: type,
        status: VerificationStatus.pending,
        progress: 0.0,
        filePath: processed.path,
        originalName: processed.originalName,
        fileSize: processed.fileSize,
        uploadedAt: DateTime.now(),
        isOptimistic: true,
      );
      await _dao.upsert(_toCompanion(optimistic, processed.checksum));

      try {
        final response = await _api.uploadDocument(
          filePath: processed.path,
          type: type,
          originalName: processed.originalName,
          fileSize: processed.fileSize,
          checksum: processed.checksum,
        );

        final confirmed = response.toDomain(
          type: type,
          filePath: processed.path,
          originalName: processed.originalName,
          fileSize: processed.fileSize,
        );

        await _dao.db.transaction(() async {
          await (_dao.db.delete(_dao.db.documentsTable)
                ..where((d) => d.id.equals(tempId)))
              .go();
          await _dao.upsert(_toCompanion(confirmed, processed.checksum));

          await _dao.insertAuditEntry(
            DocumentAuditTableCompanion.insert(
              id: _uuid.v4(),
              documentId: confirmed.id,
              fromStatus: 'NONE',
              toStatus: confirmed.status.apiValue,
              timestamp: DateTime.now(),
            ),
          );
        });

        _ws.trackDocument(confirmed.id);
        _trackForHeartbeat(confirmed.id);
        return right(confirmed);
      } catch (e) {
        await (_dao.db.delete(_dao.db.documentsTable)
              ..where((d) => d.id.equals(tempId)))
            .go();
        return left(CacheFailure('Upload failed: $e'));
      }
    } on FileValidationException catch (e) {
      return left(CacheFailure(e.message));
    } catch (e, st) {
      debugPrint('[DocumentRepository.uploadDocument] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<VerificationDocument> watchDocument(String id) =>
      _dao.watchById(id).where((row) => row != null).map(
            (row) => _dao.mapToEntity(row!),
          );

  @override
  Stream<List<VerificationDocument>> watchAllDocuments() =>
      _dao.watchAll().map(
            (rows) => rows.map(_dao.mapToEntity).toList(),
          );

  @override
  Future<Either<Failure, VerificationDocument>> getDocumentStatus(
      String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) return left(const NotFoundFailure());
      final existing = _dao.mapToEntity(row);
      if (existing.isTerminal) return right(existing);

      final dto = await _api.getStatus(id, existing.status);
      final updated = dto.toDomain(existing);
      await _persistUpdate(existing, updated);
      return right(updated);
    } catch (e, st) {
      debugPrint('[DocumentRepository.getDocumentStatus] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerificationDocument>> retryVerification(
      String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) return left(const NotFoundFailure());
      final existing = _dao.mapToEntity(row);

      if (!existing.canRetry) {
        return left(const CacheFailure(
            'Document cannot be retried — either not rejected or max retries reached.'));
      }

      final retrying = existing.resetForRetry();
      await _dao.upsert(_toCompanionFromExisting(retrying, row.checksum));

      await _dao.insertAuditEntry(
        DocumentAuditTableCompanion.insert(
          id: _uuid.v4(),
          documentId: id,
          fromStatus: existing.status.apiValue,
          toStatus: retrying.status.apiValue,
          note: const Value('Manual retry'),
          timestamp: DateTime.now(),
        ),
      );

      try {
        final response = await _api.uploadDocument(
          filePath: retrying.filePath,
          type: retrying.type,
          originalName: retrying.originalName,
          fileSize: retrying.fileSize,
          checksum: row.checksum,
        );

        final confirmed = response.toDomain(
          type: retrying.type,
          filePath: retrying.filePath,
          originalName: retrying.originalName,
          fileSize: retrying.fileSize,
        ).copyWith(
          id: retrying.id, // preserve original ID so the active subscription still receives updates
          retryCount: retrying.retryCount,
        );

        await _dao.upsert(_toCompanionFromExisting(confirmed, row.checksum));
        _ws.trackDocument(confirmed.id);
        _trackForHeartbeat(confirmed.id);
        return right(confirmed);
      } catch (e) {
        await _dao.upsert(_toCompanionFromExisting(existing, row.checksum));
        return left(CacheFailure('Retry failed: $e'));
      }
    } catch (e, st) {
      debugPrint('[DocumentRepository.retryVerification] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VerificationDocument>>> getDocumentHistory() async {
    try {
      final rows = await _dao.getAll();
      return right(rows.map(_dao.mapToEntity).toList());
    } catch (e, st) {
      debugPrint('[DocumentRepository.getDocumentHistory] $e\n$st');
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Stream<List<DocumentAuditEntry>> watchAuditTrail(String documentId) =>
      _dao.watchAuditForDocument(documentId).map(
            (rows) => rows
                .map(
                  (r) => DocumentAuditEntry(
                    id: r.id,
                    documentId: r.documentId,
                    fromStatus: VerificationStatus.fromApi(r.fromStatus),
                    toStatus: VerificationStatus.fromApi(r.toStatus),
                    note: r.note,
                    timestamp: r.timestamp,
                  ),
                )
                .toList(),
          );

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _isTerminal(VerificationStatus status) =>
      status == VerificationStatus.verified ||
      status == VerificationStatus.rejected;

  DocumentsTableCompanion _toCompanion(
    VerificationDocument doc,
    String checksum,
  ) =>
      DocumentsTableCompanion.insert(
        id: doc.id,
        type: doc.type.apiValue,
        status: doc.status.apiValue,
        progress: Value(doc.progress),
        filePath: doc.filePath,
        originalName: doc.originalName,
        fileSize: doc.fileSize,
        checksum: checksum,
        estimatedProcessingTime: Value(doc.estimatedProcessingTime),
        uploadedAt: doc.uploadedAt,
        verifiedAt: Value(doc.verifiedAt),
        expiresAt: Value(doc.expiresAt),
        rejectionReason: Value(doc.rejectionReason),
        currentStageJson: Value(DocumentDao.stageToJson(doc.currentStage)),
        retryCount: Value(doc.retryCount),
      );

  DocumentsTableCompanion _toCompanionFromExisting(
    VerificationDocument doc,
    String checksum,
  ) =>
      _toCompanion(doc, checksum);

  void dispose() {
    _wsMsgSub?.cancel();
    _wsStateSub?.cancel();
    _connectivitySub?.cancel();
    _stopHeartbeat();
    _reachabilityTimer?.cancel();
    _connectivityStatusController.close();
  }

  // Buffers stream items within [window] and emits them as a list
  StreamTransformer<T, List<T>> _batchTransformer<T>(Duration window) =>
      StreamTransformer.fromBind(
        (stream) async* {
          var buffer = <T>[];
          Timer? timer;
          final controller = StreamController<List<T>>();

          stream.listen(
            (item) {
              buffer.add(item);
              timer?.cancel();
              timer = Timer(window, () {
                if (buffer.isNotEmpty) {
                  controller.add(List.of(buffer));
                  buffer = [];
                }
              });
            },
            onDone: () {
              if (buffer.isNotEmpty) controller.add(buffer);
              controller.close();
            },
            onError: controller.addError,
          );

          yield* controller.stream;
        },
      );
}
