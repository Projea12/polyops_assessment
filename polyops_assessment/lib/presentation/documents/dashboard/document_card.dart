import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domain/entities/verification_document.dart';
import '../../../domain/entities/verification_status.dart';
import '../document_theme.dart';
import '../detail/document_detail_sheet.dart';

class DocumentCard extends StatelessWidget {
  final VerificationDocument document;
  const DocumentCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final doc = document;
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;
    final statusColors = ext.statusColorsFor(doc.status);

    return GestureDetector(
      onTap: () => DocumentDetailSheet.show(context, doc.id),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ext.appBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      documentTypeIcon(doc.type),
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.type.label, style: tt.titleMedium),
                        const SizedBox(height: 2),
                        Text(
                          doc.originalName,
                          style: tt.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon(doc.status),
                            size: 11, color: statusColors.foreground),
                        const SizedBox(width: 4),
                        Text(
                          doc.status.label,
                          style: tt.labelMedium
                              ?.copyWith(color: statusColors.foreground),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar — only for active (non-terminal) documents
            if (!doc.isTerminal) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: doc.progress),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 4,
                            backgroundColor: ext.borderLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                statusColors.foreground),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(doc.progress * 100).round()}%',
                      style: tt.labelMedium
                          ?.copyWith(color: statusColors.foreground),
                    ),
                  ],
                ),
              ),
              if (doc.currentStage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                  child: Text(
                    doc.currentStage!.stage,
                    style: tt.labelSmall,
                  ),
                ),
            ],

            // Rejection reason
            if (doc.status == VerificationStatus.rejected &&
                doc.rejectionReason != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 12, color: statusColors.foreground),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doc.rejectionReason!,
                        style:
                            tt.labelSmall?.copyWith(color: statusColors.foreground),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                children: [
                  Text(
                    DateFormat('MMM d, y').format(doc.uploadedAt),
                    style: tt.labelSmall,
                  ),
                  if (doc.retryCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: ext.surfaceSubtle,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Retry ${doc.retryCount}',
                        style: tt.labelSmall?.copyWith(
                          color: ext.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (doc.isOptimistic)
                    const _OptimisticChip()
                  else
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: AppColors.borderLight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptimisticChip extends StatelessWidget {
  const _OptimisticChip();

  @override
  Widget build(BuildContext context) {
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;
    final pendingColors = ext.statusColorsFor(VerificationStatus.pending);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: pendingColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.statusPendingBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: pendingColors.foreground,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Uploading',
            style: tt.labelSmall?.copyWith(
              color: pendingColors.foreground,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
