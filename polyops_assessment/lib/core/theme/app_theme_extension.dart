import 'package:flutter/material.dart';

import '../../domain/entities/connectivity_status.dart';
import '../../domain/entities/verification_status.dart';
import 'app_colors.dart';

@immutable
class StatusColors {
  final Color foreground;
  final Color background;

  const StatusColors({required this.foreground, required this.background});

  StatusColors lerp(StatusColors other, double t) => StatusColors(
        foreground: Color.lerp(foreground, other.foreground, t)!,
        background: Color.lerp(background, other.background, t)!,
      );
}

@immutable
class ConnectivityColors {
  final Color background;
  final Color foreground;

  const ConnectivityColors(
      {required this.background, required this.foreground});

  ConnectivityColors lerp(ConnectivityColors other, double t) =>
      ConnectivityColors(
        background: Color.lerp(background, other.background, t)!,
        foreground: Color.lerp(foreground, other.foreground, t)!,
      );
}

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // Surfaces
  final Color appBackground;
  final Color brandGreenSurface;
  final Color brandGreenBorder;
  final Color brandGreenMid;
  final Color surfaceSubtle;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;

  // Borders
  final Color borderLight;

  // Status semantic
  final Color statusVerifiedDark;
  final Color rejectedBannerBorder;
  final Color rejectedDarkText;
  final Color verifiedBannerBorder;
  final Color verifiedDarkText;

  // On-gradient header chip tints
  final Color gradientChipVerified;
  final Color gradientChipPending;
  final Color gradientChipRejected;

  final Map<VerificationStatus, StatusColors> _statusColors;
  final Map<ConnectivityStatus, ConnectivityColors> _connectivityColors;

  const AppThemeExtension({
    required this.appBackground,
    required this.brandGreenSurface,
    required this.brandGreenBorder,
    required this.brandGreenMid,
    required this.surfaceSubtle,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.borderLight,
    required this.statusVerifiedDark,
    required this.rejectedBannerBorder,
    required this.rejectedDarkText,
    required this.verifiedBannerBorder,
    required this.verifiedDarkText,
    required this.gradientChipVerified,
    required this.gradientChipPending,
    required this.gradientChipRejected,
    required Map<VerificationStatus, StatusColors> statusColors,
    required Map<ConnectivityStatus, ConnectivityColors> connectivityColors,
  })  : _statusColors = statusColors,
        _connectivityColors = connectivityColors;

  StatusColors statusColorsFor(VerificationStatus status) =>
      _statusColors[status] ?? _statusColors[VerificationStatus.none]!;

  ConnectivityColors connectivityColorsFor(ConnectivityStatus status) =>
      _connectivityColors[status]!;

  static AppThemeExtension of(BuildContext context) =>
      Theme.of(context).extension<AppThemeExtension>()!;

  static const AppThemeExtension light = AppThemeExtension(
    appBackground: AppColors.appBackground,
    brandGreenSurface: AppColors.brandGreenSurface,
    brandGreenBorder: AppColors.brandGreenBorder,
    brandGreenMid: AppColors.brandGreenMid,
    surfaceSubtle: AppColors.surfaceSubtle,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textMuted: AppColors.textMuted,
    borderLight: AppColors.borderLight,
    statusVerifiedDark: AppColors.statusVerifiedDark,
    rejectedBannerBorder: AppColors.rejectedBannerBorder,
    rejectedDarkText: AppColors.rejectedDarkText,
    verifiedBannerBorder: AppColors.verifiedBannerBorder,
    verifiedDarkText: AppColors.verifiedDarkText,
    gradientChipVerified: AppColors.chipVerified,
    gradientChipPending: AppColors.chipPending,
    gradientChipRejected: AppColors.chipRejected,
    statusColors: {
      VerificationStatus.none: StatusColors(
        foreground: AppColors.statusNoneFg,
        background: AppColors.statusNoneBg,
      ),
      VerificationStatus.pending: StatusColors(
        foreground: AppColors.statusPendingFg,
        background: AppColors.statusPendingBg,
      ),
      VerificationStatus.processing: StatusColors(
        foreground: AppColors.statusProcessingFg,
        background: AppColors.statusProcessingBg,
      ),
      VerificationStatus.verified: StatusColors(
        foreground: AppColors.statusVerifiedFg,
        background: AppColors.statusVerifiedBg,
      ),
      VerificationStatus.rejected: StatusColors(
        foreground: AppColors.statusRejectedFg,
        background: AppColors.statusRejectedBg,
      ),
    },
    connectivityColors: {
      ConnectivityStatus.live: ConnectivityColors(
        background: AppColors.statusVerifiedBg,
        foreground: AppColors.verifiedDarkText,
      ),
      ConnectivityStatus.heartbeat: ConnectivityColors(
        background: AppColors.heartbeatBg,
        foreground: AppColors.heartbeatText,
      ),
      ConnectivityStatus.offline: ConnectivityColors(
        background: AppColors.statusRejectedBg,
        foreground: AppColors.rejectedDarkText,
      ),
    },
  );

  @override
  AppThemeExtension copyWith({
    Color? appBackground,
    Color? brandGreenSurface,
    Color? brandGreenBorder,
    Color? brandGreenMid,
    Color? surfaceSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textMuted,
    Color? borderLight,
    Color? statusVerifiedDark,
    Color? rejectedBannerBorder,
    Color? rejectedDarkText,
    Color? verifiedBannerBorder,
    Color? verifiedDarkText,
    Color? gradientChipVerified,
    Color? gradientChipPending,
    Color? gradientChipRejected,
    Map<VerificationStatus, StatusColors>? statusColors,
    Map<ConnectivityStatus, ConnectivityColors>? connectivityColors,
  }) =>
      AppThemeExtension(
        appBackground: appBackground ?? this.appBackground,
        brandGreenSurface: brandGreenSurface ?? this.brandGreenSurface,
        brandGreenBorder: brandGreenBorder ?? this.brandGreenBorder,
        brandGreenMid: brandGreenMid ?? this.brandGreenMid,
        surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textTertiary: textTertiary ?? this.textTertiary,
        textMuted: textMuted ?? this.textMuted,
        borderLight: borderLight ?? this.borderLight,
        statusVerifiedDark: statusVerifiedDark ?? this.statusVerifiedDark,
        rejectedBannerBorder:
            rejectedBannerBorder ?? this.rejectedBannerBorder,
        rejectedDarkText: rejectedDarkText ?? this.rejectedDarkText,
        verifiedBannerBorder:
            verifiedBannerBorder ?? this.verifiedBannerBorder,
        verifiedDarkText: verifiedDarkText ?? this.verifiedDarkText,
        gradientChipVerified:
            gradientChipVerified ?? this.gradientChipVerified,
        gradientChipPending: gradientChipPending ?? this.gradientChipPending,
        gradientChipRejected:
            gradientChipRejected ?? this.gradientChipRejected,
        statusColors: statusColors ?? _statusColors,
        connectivityColors: connectivityColors ?? _connectivityColors,
      );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      brandGreenSurface:
          Color.lerp(brandGreenSurface, other.brandGreenSurface, t)!,
      brandGreenBorder:
          Color.lerp(brandGreenBorder, other.brandGreenBorder, t)!,
      brandGreenMid: Color.lerp(brandGreenMid, other.brandGreenMid, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      statusVerifiedDark:
          Color.lerp(statusVerifiedDark, other.statusVerifiedDark, t)!,
      rejectedBannerBorder:
          Color.lerp(rejectedBannerBorder, other.rejectedBannerBorder, t)!,
      rejectedDarkText:
          Color.lerp(rejectedDarkText, other.rejectedDarkText, t)!,
      verifiedBannerBorder:
          Color.lerp(verifiedBannerBorder, other.verifiedBannerBorder, t)!,
      verifiedDarkText:
          Color.lerp(verifiedDarkText, other.verifiedDarkText, t)!,
      gradientChipVerified:
          Color.lerp(gradientChipVerified, other.gradientChipVerified, t)!,
      gradientChipPending:
          Color.lerp(gradientChipPending, other.gradientChipPending, t)!,
      gradientChipRejected:
          Color.lerp(gradientChipRejected, other.gradientChipRejected, t)!,
      statusColors: {
        for (final s in VerificationStatus.values)
          s: (_statusColors[s] ?? _statusColors[VerificationStatus.none]!)
              .lerp(
            other._statusColors[s] ??
                other._statusColors[VerificationStatus.none]!,
            t,
          ),
      },
      connectivityColors: {
        for (final s in ConnectivityStatus.values)
          s: _connectivityColors[s]!
              .lerp(other._connectivityColors[s]!, t),
      },
    );
  }
}
