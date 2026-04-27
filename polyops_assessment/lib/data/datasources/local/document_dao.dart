import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/document_type.dart';
import '../../../domain/entities/verification_document.dart';
import '../../../domain/entities/verification_stage.dart';
import '../../../domain/entities/verification_status.dart';
import 'app_database.dart';

part 'document_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [DocumentsTable, DocumentAuditTable])
class DocumentDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentDaoMixin {
  DocumentDao(super.db);

  Stream<List<DocumentsTableData>> watchAll() =>
      (select(documentsTable)
            ..orderBy([(d) => OrderingTerm.desc(d.uploadedAt)]))
          .watch();

  Stream<DocumentsTableData?> watchById(String id) =>
      (select(documentsTable)..where((d) => d.id.equals(id)))
          .watchSingleOrNull();

  Future<DocumentsTableData?> getById(String id) =>
      (select(documentsTable)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<List<DocumentsTableData>> getAll() =>
      (select(documentsTable)
            ..orderBy([(d) => OrderingTerm.desc(d.uploadedAt)]))
          .get();

  Future<void> insert(DocumentsTableCompanion entry) =>
      into(documentsTable).insert(entry);

  Future<void> upsert(DocumentsTableCompanion entry) =>
      into(documentsTable).insertOnConflictUpdate(entry);

  Future<int> updateStatus({
    required String id,
    required String status,
    required double progress,
    String? currentStageJson,
    DateTime? verifiedAt,
    DateTime? expiresAt,
    String? rejectionReason,
  }) =>
      (update(documentsTable)..where((d) => d.id.equals(id))).write(
        DocumentsTableCompanion(
          status: Value(status),
          progress: Value(progress),
          currentStageJson: Value(currentStageJson),
          verifiedAt: Value(verifiedAt),
          expiresAt: Value(expiresAt),
          rejectionReason: Value(rejectionReason),
        ),
      );

  Future<int> incrementRetry(String id) async {
    final row = await getById(id);
    if (row == null) return 0;
    return (update(documentsTable)..where((d) => d.id.equals(id))).write(
      DocumentsTableCompanion(retryCount: Value(row.retryCount + 1)),
    );
  }

  Future<void> insertAuditEntry(DocumentAuditTableCompanion entry) =>
      into(documentAuditTable).insert(entry);

  Stream<List<DocumentAuditTableData>> watchAuditForDocument(
          String documentId) =>
      (select(documentAuditTable)
            ..where((a) => a.documentId.equals(documentId))
            ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]))
          .watch();

  Future<List<DocumentAuditTableData>> getAuditForDocument(
          String documentId) =>
      (select(documentAuditTable)
            ..where((a) => a.documentId.equals(documentId))
            ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]))
          .get();

  VerificationDocument mapToEntity(DocumentsTableData row) {
    VerificationStage? stage;
    if (row.currentStageJson != null) {
      final json = jsonDecode(row.currentStageJson!) as Map<String, dynamic>;
      stage = VerificationStage(
        stage: json['stage'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        issues: (json['issues'] as List<dynamic>).cast<String>(),
      );
    }

    return VerificationDocument(
      id: row.id,
      type: DocumentType.fromApi(row.type),
      status: VerificationStatus.fromApi(row.status),
      progress: row.progress,
      filePath: row.filePath,
      originalName: row.originalName,
      fileSize: row.fileSize,
      uploadedAt: row.uploadedAt,
      verifiedAt: row.verifiedAt,
      expiresAt: row.expiresAt,
      rejectionReason: row.rejectionReason,
      currentStage: stage,
      estimatedProcessingTime: row.estimatedProcessingTime,
      retryCount: row.retryCount,
    );
  }

  static String? stageToJson(VerificationStage? stage) {
    if (stage == null) return null;
    return jsonEncode({
      'stage': stage.stage,
      'confidence': stage.confidence,
      'issues': stage.issues,
    });
  }
}
