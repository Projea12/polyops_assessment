import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/verification_status.dart';
import '../document_theme.dart';
import 'bloc/document_detail_bloc.dart';

class DocumentDetailSheet extends StatelessWidget {
  final String documentId;
  const DocumentDetailSheet._({required this.documentId});

  static Future<void> show(BuildContext context, String documentId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<DocumentDetailBloc>()
          ..add(DocumentDetailEvent.subscriptionRequested(documentId)),
        child: DocumentDetailSheet._(documentId: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      _DetailContent(documentId: documentId);
}

class _DetailContent extends StatelessWidget {
  final String documentId;
  const _DetailContent({required this.documentId});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<DocumentDetailBloc, DocumentDetailState>(
              listenWhen: (prev, curr) =>
                  curr is DocumentDetailLoaded && prev != curr,
              listener: (context, state) {
                if (state is DocumentDetailLoaded &&
                    state.retryError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.retryError!),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                }
              },
              builder: (context, state) => switch (state) {
                DocumentDetailInitial() ||
                DocumentDetailLoading() =>
                  const Center(
                    child: CircularProgressIndicator(color: kGreen),
                  ),
                DocumentDetailError(:final message) => Center(
                    child: Text(message,
                        style: const TextStyle(color: Color(0xFF6B7280))),
                  ),
                DocumentDetailLoaded() => _LoadedView(state: state),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final DocumentDetailLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final doc = state.document;
    final color = statusColor(doc.status);
    final bg = statusBackground(doc.status);

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(documentTypeIcon(doc.type),
                      color: kGreen, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.type.label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        doc.originalName,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon(doc.status), size: 13, color: color),
                      const SizedBox(width: 5),
                      Text(
                        doc.status.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress section
          if (!doc.isTerminal) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: doc.progress),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                      builder: (context, value, child) => ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE5E7EB),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(doc.progress * 100).round()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (doc.currentStage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                          strokeWidth: 1.5, color: Color(0xFF3B82F6)),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      doc.currentStage!.stage,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF374151)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
          ],

          // Rejection reason + retry
          if (doc.status == VerificationStatus.rejected) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doc.rejectionReason != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            size: 16, color: Color(0xFFEF4444)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.rejectionReason!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (doc.canRetry)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: state.isRetrying
                            ? null
                            : () => context.read<DocumentDetailBloc>().add(
                                  DocumentDetailEvent.retryRequested(doc.id),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          disabledBackgroundColor: const Color(0xFFFECACA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: state.isRetrying
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh_rounded,
                                color: Colors.white, size: 18),
                        label: Text(
                          state.isRetrying ? 'Retrying…' : 'Retry Verification',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Verified info
          if (doc.status == VerificationStatus.verified &&
              doc.verifiedAt != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded,
                      size: 20, color: Color(0xFF059669)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF065F46),
                        ),
                      ),
                      if (doc.expiresAt != null)
                        Text(
                          'Expires ${DateFormat('MMM d, y').format(doc.expiresAt!)}',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF059669)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

          // Tabs
          const TabBar(
            labelColor: kGreen,
            unselectedLabelColor: Color(0xFF9CA3AF),
            indicatorColor: kGreen,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle:
                TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Audit Trail'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _DetailsTab(doc: doc),
                _AuditTab(entries: state.auditTrail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  final dynamic doc;
  const _DetailsTab({required this.doc});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _DetailRow(
          label: 'File name',
          value: doc.originalName,
        ),
        _DetailRow(
          label: 'File size',
          value: '${(doc.fileSize / 1024).toStringAsFixed(1)} KB',
        ),
        _DetailRow(
          label: 'Uploaded',
          value: DateFormat('MMM d, y · HH:mm').format(doc.uploadedAt),
        ),
        if (doc.retryCount > 0)
          _DetailRow(
            label: 'Retry count',
            value: doc.retryCount.toString(),
          ),
        _DetailRow(
          label: 'Document ID',
          value: doc.id,
          mono: true,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w600,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuditTab extends StatelessWidget {
  final List<dynamic> entries;
  const _AuditTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text('No audit entries yet.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      itemBuilder: (_, index) {
        final entry = entries[index];
        final isLast = index == entries.length - 1;
        final toColor = statusColor(entry.toStatus);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline spine
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: toColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: const Color(0xFFE5E7EB),
                        ),
                      ),
                    if (isLast) const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${entry.fromStatus.label} → ${entry.toStatus.label}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM d, y · HH:mm:ss')
                            .format(entry.timestamp),
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9CA3AF)),
                      ),
                      if (entry.note != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          entry.note!,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
