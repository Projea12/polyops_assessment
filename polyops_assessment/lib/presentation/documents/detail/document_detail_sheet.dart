import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme_extension.dart';
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
    final ext = AppThemeExtension.of(context);

    return Container(
      height: screenHeight * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ext.borderLight,
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
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) => switch (state) {
                DocumentDetailInitial() || DocumentDetailLoading() => Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                DocumentDetailError(:final message) => Center(
                    child: Text(message,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: ext.textSecondary)),
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
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final statusColors = ext.statusColorsFor(doc.status);

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
                    color: ext.appBackground,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(documentTypeIcon(doc.type),
                      color: cs.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.type.label, style: tt.titleLarge),
                      Text(
                        doc.originalName,
                        style: tt.bodySmall,
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
                    color: statusColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon(doc.status),
                          size: 13, color: statusColors.foreground),
                      const SizedBox(width: 5),
                      Text(
                        doc.status.label,
                        style: tt.labelLarge
                            ?.copyWith(color: statusColors.foreground),
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
                          backgroundColor: ext.borderLight,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              statusColors.foreground),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(doc.progress * 100).round()}%',
                    style: tt.titleSmall
                        ?.copyWith(color: statusColors.foreground),
                  ),
                ],
              ),
            ),
            if (doc.currentStage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: ext.statusColorsFor(
                                VerificationStatus.processing)
                            .foreground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(doc.currentStage!.stage,
                        style:
                            tt.bodyMedium?.copyWith(color: ext.textMuted)),
                  ],
                ),
              ),
            const SizedBox(height: 12),
          ],

          // Rejection box
          if (doc.status == VerificationStatus.rejected) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ext.statusColorsFor(VerificationStatus.rejected)
                    .background,
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
                        Icon(Icons.error_outline_rounded,
                            size: 16, color: cs.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            doc.rejectionReason!,
                            style: tt.bodyMedium
                                ?.copyWith(color: const Color(0xFF991B1B)),
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
                          backgroundColor: cs.error,
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
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Verified banner
          if (doc.status == VerificationStatus.verified &&
              doc.verifiedAt != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ext.statusColorsFor(VerificationStatus.verified)
                    .background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_rounded,
                      size: 20, color: ext.statusVerifiedDark),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Verified',
                          style: tt.bodyLarge?.copyWith(
                              color: const Color(0xFF065F46))),
                      if (doc.expiresAt != null)
                        Text(
                          'Expires ${DateFormat('MMM d, y').format(doc.expiresAt!)}',
                          style: tt.labelSmall
                              ?.copyWith(color: ext.statusVerifiedDark),
                        ),
                    ],
                  ),
                ],
              ),
            ),

          // Tabs
          TabBar(
            labelColor: cs.primary,
            unselectedLabelColor: ext.textTertiary,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: tt.bodyLarge,
            tabs: const [
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
        _DetailRow(label: 'File name', value: doc.originalName),
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
              label: 'Retry count', value: doc.retryCount.toString()),
        _DetailRow(label: 'Document ID', value: doc.id, mono: true),
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
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: tt.bodySmall?.copyWith(
                    color: ext.textTertiary,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(
              value,
              style: tt.bodyLarge?.copyWith(
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
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;

    if (entries.isEmpty) {
      return Center(
        child: Text('No audit entries yet.',
            style: tt.bodyMedium?.copyWith(color: ext.textTertiary)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: entries.length,
      separatorBuilder: (_, i) => const SizedBox.shrink(),
      itemBuilder: (_, index) {
        final entry = entries[index];
        final isLast = index == entries.length - 1;
        final toColor =
            ext.statusColorsFor(entry.toStatus).foreground;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          color: ext.borderLight,
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
                      Text(
                        '${entry.fromStatus.label} → ${entry.toStatus.label}',
                        style: tt.bodyLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM d, y · HH:mm:ss')
                            .format(entry.timestamp),
                        style: tt.labelSmall,
                      ),
                      if (entry.note != null) ...[
                        const SizedBox(height: 4),
                        Text(entry.note!,
                            style: tt.bodySmall
                                ?.copyWith(color: ext.textSecondary)),
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
