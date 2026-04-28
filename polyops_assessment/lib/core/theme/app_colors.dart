import 'package:flutter/material.dart';

// Raw color palette — internal to the theme layer.
// Widgets must never import this file directly; use Theme.of(context) instead.
abstract final class AppColors {
  // Brand
  static const brandGreen = Color(0xFF1B5E37);
  static const brandGreenMid = Color(0xFF2A7D52);
  static const brandGreenLight = Color(0xFFDCFCE7);
  static const brandGreenSurface = Color(0xFFF0FDF4);
  static const brandGreenBorder = Color(0xFFBBF7D0);

  // Surfaces
  static const appBackground = Color(0xFFEDF2FB);
  static const surfaceWhite = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF3F4F6);

  // Text
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF374151);

  // Borders / dividers
  static const borderLight = Color(0xFFE5E7EB);

  // Status — foreground
  static const statusNoneFg = Color(0xFF9CA3AF);
  static const statusPendingFg = Color(0xFFF97316);
  static const statusProcessingFg = Color(0xFF3B82F6);
  static const statusVerifiedFg = Color(0xFF10B981);
  static const statusVerifiedDark = Color(0xFF059669);
  static const statusRejectedFg = Color(0xFFEF4444);

  // Status — background
  static const statusNoneBg = Color(0xFFF9FAFB);
  static const statusPendingBg = Color(0xFFFFF7ED);
  static const statusPendingBorder = Color(0xFFFED7AA);
  static const statusProcessingBg = Color(0xFFEFF6FF);
  static const statusVerifiedBg = Color(0xFFECFDF5);
  static const statusRejectedBg = Color(0xFFFEF2F2);

  // On-gradient chip tints (used on dark green header)
  static const chipVerified = Color(0xFF6EE7B7);
  static const chipPending = Color(0xFFFBBF24);
  static const chipRejected = Color(0xFFFCA5A5);

  // Rejected banner
  static const rejectedBannerBorder = Color(0xFFFECACA);
  static const rejectedDarkText = Color(0xFF991B1B);

  // Verified banner
  static const verifiedBannerBorder = Color(0xFFA7F3D0);
  static const verifiedDarkText = Color(0xFF065F46);

  // Connectivity banner — heartbeat
  static const heartbeatBg = Color(0xFFFFFBEB);
  static const heartbeatText = Color(0xFF92400E);
}
