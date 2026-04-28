import 'package:flutter/material.dart';

import '../../domain/entities/document_type.dart';
import '../../domain/entities/verification_status.dart';

// Pure data mapping — status/type → icon. Color tokens live in AppThemeExtension.

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
