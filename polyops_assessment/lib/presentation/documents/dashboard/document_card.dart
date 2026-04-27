import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final color = statusColor(doc.status);
    final bg = statusBackground(doc.status);

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
                  // Type icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF2FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      documentTypeIcon(doc.type),
                      color: kGreen,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.type.label,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doc.originalName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
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
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon(doc.status), size: 11, color: color),
                        const SizedBox(width: 4),
                        Text(
                          doc.status.label,
                          style: TextStyle(
                            fontSize: 11,
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
                            backgroundColor:
                                const Color(0xFFE5E7EB),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(doc.progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              if (doc.currentStage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                  child: Text(
                    doc.currentStage!.stage,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF)),
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
                    const Icon(Icons.info_outline_rounded,
                        size: 12, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        doc.rejectionReason!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFEF4444),
                        ),
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
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9CA3AF)),
                  ),
                  if (doc.retryCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Retry ${doc.retryCount}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (doc.isOptimistic)
                    const _OptimisticChip()
                  else
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: Colors.grey.shade300),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 8,
            height: 8,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Color(0xFFF97316),
            ),
          ),
          SizedBox(width: 5),
          Text(
            'Uploading',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFF97316),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
