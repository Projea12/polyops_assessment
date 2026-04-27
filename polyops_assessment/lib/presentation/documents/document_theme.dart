import 'package:flutter/material.dart';

import '../../domain/entities/document_type.dart';
import '../../domain/entities/verification_status.dart';

// Shared visual tokens for the document verification UI.

const kGreen = Color(0xFF1B5E37);
const kGreenLight = Color(0xFF2A7D52);
const kBackground = Color(0xFFEDF2FB);

Color statusColor(VerificationStatus s) => switch (s) {
      VerificationStatus.none => const Color(0xFF9CA3AF),
      VerificationStatus.pending => const Color(0xFFF97316),
      VerificationStatus.processing => const Color(0xFF3B82F6),
      VerificationStatus.verified => const Color(0xFF10B981),
      VerificationStatus.rejected => const Color(0xFFEF4444),
    };

Color statusBackground(VerificationStatus s) => switch (s) {
      VerificationStatus.none => const Color(0xFFF9FAFB),
      VerificationStatus.pending => const Color(0xFFFFF7ED),
      VerificationStatus.processing => const Color(0xFFEFF6FF),
      VerificationStatus.verified => const Color(0xFFECFDF5),
      VerificationStatus.rejected => const Color(0xFFFEF2F2),
    };

IconData statusIcon(VerificationStatus s) => switch (s) {
      VerificationStatus.none => Icons.upload_file_rounded,
      VerificationStatus.pending => Icons.hourglass_top_rounded,
      VerificationStatus.processing => Icons.autorenew_rounded,
      VerificationStatus.verified => Icons.verified_rounded,
      VerificationStatus.rejected => Icons.cancel_rounded,
    };

IconData documentTypeIcon(DocumentType t) => switch (t) {
      DocumentType.passport => Icons.travel_explore_rounded,
      DocumentType.nationalId => Icons.credit_card_rounded,
      DocumentType.utilityBill => Icons.receipt_long_rounded,
    };
