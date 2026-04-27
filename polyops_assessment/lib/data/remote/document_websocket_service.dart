import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/data/datasources/dtos/websocket_message_dto.dart';
import '../../../core/auth/auth_token_provider.dart';


enum WebSocketState { disconnected, connecting, connected, failed }

@lazySingleton
class DocumentWebSocketService {
  final AuthTokenProvider _authTokenProvider;
  final _random = Random();

  DocumentWebSocketService(this._authTokenProvider);

  WebSocketState _state = WebSocketState.disconnected;
  final _stateController = StreamController<WebSocketState>.broadcast();
  final _messageController = StreamController<WebSocketMessageDto>.broadcast();

  Timer? _reconnectTimer;
  Timer? _simulationTimer;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 5;

  // Active document IDs being tracked
  final Set<String> _trackedIds = {};

  WebSocketState get state => _state;
  Stream<WebSocketState> get stateStream => _stateController.stream;
  Stream<WebSocketMessageDto> get messageStream => _messageController.stream;
  bool get isConnected => _state == WebSocketState.connected;

  Future<void> connect() async {
    if (_state == WebSocketState.connected ||
        _state == WebSocketState.connecting) {
      return;
    }

    _setState(WebSocketState.connecting);

    // In production: wss://api.example.com/ws/documents?token=<bearer>
    // ignore: unused_local_variable
    final wsUrl =
        'wss://api.example.com/ws/documents?token=${_authTokenProvider.token}';

    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate 10% chance of initial connection failure
    if (_random.nextDouble() < 0.1) {
      _setState(WebSocketState.failed);
      _scheduleReconnect();
      return;
    }

    _reconnectAttempts = 0;
    _setState(WebSocketState.connected);
    _startSimulation();
  }

  void trackDocument(String id) {
    _trackedIds.add(id);
    // Restart simulation if it was paused due to empty tracked set
    if (isConnected && _simulationTimer == null) _startSimulation();
  }

  void untrackDocument(String id) {
    _trackedIds.remove(id);
    // Pause simulation when nothing is being tracked — saves resources
    if (_trackedIds.isEmpty) {
      _simulationTimer?.cancel();
      _simulationTimer = null;
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _simulationTimer?.cancel();
    _trackedIds.clear();
    _setState(WebSocketState.disconnected);
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('[WebSocket] Max reconnect attempts reached — falling back to polling');
      _setState(WebSocketState.failed);
      return;
    }

    // Exponential backoff: 1s, 2s, 4s, 8s, 16s
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());
    _reconnectAttempts++;
    debugPrint('[WebSocket] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  void _startSimulation() {
    // Emit a STATUS_UPDATE every 2–4 seconds for tracked documents
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(
      Duration(milliseconds: 2000 + _random.nextInt(2000)),
      (_) {
        if (_trackedIds.isEmpty) return;
        // Simulate occasional connection drop
        if (_random.nextDouble() < 0.03) {
          _setState(WebSocketState.disconnected);
          _simulationTimer?.cancel();
          _scheduleReconnect();
          return;
        }
        for (final id in List.of(_trackedIds)) {
          _emitProgress(id);
        }
      },
    );
  }

  void _emitProgress(String id) {
    final roll = _random.nextDouble();
    final String status;
    final double progress;
    final String stage;
    final double confidence;
    final List<String> issues;

    if (roll < 0.4) {
      status = 'PROCESSING';
      progress = 0.1 + _random.nextDouble() * 0.6;
      stage = _randomStage();
      confidence = 0.5 + _random.nextDouble() * 0.4;
      issues = [];
    } else if (roll < 0.75) {
      status = 'VERIFIED';
      progress = 1.0;
      stage = 'Complete';
      confidence = 0.9 + _random.nextDouble() * 0.1;
      issues = [];
      _trackedIds.remove(id);
    } else {
      status = 'REJECTED';
      progress = 1.0;
      stage = 'Review';
      confidence = 0.3 + _random.nextDouble() * 0.3;
      issues = [_randomIssue()];
      _trackedIds.remove(id);
    }

    _messageController.add(WebSocketMessageDto(
      type: 'STATUS_UPDATE',
      documentId: id,
      status: status,
      progress: progress,
      details: WebSocketDetailsDto(
        stage: stage,
        confidence: confidence,
        issues: issues,
      ),
    ));
  }

  String _randomStage() {
    const stages = [
      'Scanning document',
      'Extracting data fields',
      'Verifying authenticity',
      'Cross-referencing database',
      'Running liveness checks',
    ];
    return stages[_random.nextInt(stages.length)];
  }

  String _randomIssue() {
    const issues = [
      'Low image resolution',
      'Glare detected on document',
      'Expiry date in the past',
      'MRZ checksum mismatch',
      'Face match confidence too low',
    ];
    return issues[_random.nextInt(issues.length)];
  }

  void _setState(WebSocketState state) {
    _state = state;
    _stateController.add(state);
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _simulationTimer?.cancel();
    _stateController.close();
    _messageController.close();
  }
}
