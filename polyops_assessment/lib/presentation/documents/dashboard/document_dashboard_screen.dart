import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../domain/entities/verification_status.dart';
import '../bloc/document_bloc.dart';
import '../upload/document_upload_sheet.dart';
import 'connectivity_banner.dart';
import 'document_card.dart';

class DocumentDashboardScreen extends StatelessWidget {
  const DocumentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DocumentBloc>()
        ..add(const DocumentEvent.subscriptionRequested()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final ext = AppThemeExtension.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: ext.appBackground,
      body: BlocListener<DocumentBloc, DocumentState>(
        listenWhen: (prev, curr) =>
            prev is DocumentLoaded &&
            curr is DocumentLoaded &&
            prev.uploadStatus != curr.uploadStatus,
        listener: (context, state) {
          if (state is! DocumentLoaded) return;
          if (state.uploadStatus == DocumentUploadStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Document uploaded successfully'),
                backgroundColor: ext.statusVerifiedDark,
              ),
            );
            context
                .read<DocumentBloc>()
                .add(const DocumentEvent.uploadStatusReset());
          } else if (state.uploadStatus == DocumentUploadStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.uploadError ?? 'Upload failed'),
                backgroundColor: cs.error,
              ),
            );
            context
                .read<DocumentBloc>()
                .add(const DocumentEvent.uploadStatusReset());
          }
        },
        child: Column(
          children: [
            const _DashboardHeader(),
            BlocBuilder<DocumentBloc, DocumentState>(
              buildWhen: (prev, curr) =>
                  curr is DocumentLoaded &&
                  (prev is! DocumentLoaded ||
                      prev.connectivityStatus != curr.connectivityStatus),
              builder: (context, state) {
                if (state is! DocumentLoaded) return const SizedBox.shrink();
                return ConnectivityBanner(status: state.connectivityStatus);
              },
            ),
            Expanded(
              child: BlocBuilder<DocumentBloc, DocumentState>(
                builder: (context, state) => switch (state) {
                  DocumentInitial() ||
                  DocumentLoading() =>
                    Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 2.5),
                    ),
                  DocumentError(:final message) =>
                    _ErrorView(message: message),
                  DocumentLoaded(:final documents) when documents.isEmpty =>
                    const _EmptyState(),
                  DocumentLoaded(:final documents) => ListView.builder(
                      padding: const EdgeInsets.only(top: 16, bottom: 100),
                      itemCount: documents.length,
                      itemBuilder: (_, i) =>
                          DocumentCard(document: documents[i]),
                    ),
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<DocumentBloc, DocumentState>(
        buildWhen: (prev, curr) =>
            curr is DocumentLoaded &&
            (prev is! DocumentLoaded ||
                prev.uploadStatus != curr.uploadStatus),
        builder: (context, state) {
          if (state is! DocumentLoaded) return const SizedBox.shrink();
          final uploading =
              state.uploadStatus == DocumentUploadStatus.uploading;
          final cs = Theme.of(context).colorScheme;
          final ext = AppThemeExtension.of(context);
          return FloatingActionButton.extended(
            onPressed: uploading ? null : () => DocumentUploadSheet.show(context),
            backgroundColor:
                uploading ? ext.textSecondary : cs.primary,
            elevation: 3,
            icon: uploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.upload_rounded, color: Colors.white),
            label: Text(
              uploading ? 'Uploading…' : 'Upload Document',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          );
        },
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final cs = Theme.of(context).colorScheme;
    final ext = AppThemeExtension.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, ext.brandGreenMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Center(
                  child: Icon(Icons.shield_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KYC Verification',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                  ),
                  Text(
                    'Document verification dashboard',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          BlocBuilder<DocumentBloc, DocumentState>(
            buildWhen: (prev, curr) => curr is DocumentLoaded,
            builder: (context, state) {
              if (state is! DocumentLoaded) return const SizedBox.shrink();
              final docs = state.documents;
              final total = docs.length;
              final verified = docs
                  .where((d) => d.status == VerificationStatus.verified)
                  .length;
              final pending = docs
                  .where((d) =>
                      d.status == VerificationStatus.pending ||
                      d.status == VerificationStatus.processing)
                  .length;
              final rejected = docs
                  .where((d) => d.status == VerificationStatus.rejected)
                  .length;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _StatChip(
                      icon: Icons.folder_outlined,
                      label: 'Total',
                      value: total,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.verified_rounded,
                      label: 'Verified',
                      value: verified,
                      color: AppColors.chipVerified,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.timelapse_rounded,
                      label: 'Pending',
                      value: pending,
                      color: AppColors.chipPending,
                    ),
                    if (rejected > 0) ...[
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.cancel_outlined,
                        label: 'Rejected',
                        value: rejected,
                        color: AppColors.chipRejected,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.upload_file_rounded,
                size: 32, color: cs.primary),
          ),
          const SizedBox(height: 20),
          Text('No documents yet',
              style: tt.titleMedium?.copyWith(fontSize: 17)),
          const SizedBox(height: 8),
          Text(
            'Tap Upload Document to submit\nyour first KYC document.',
            textAlign: TextAlign.center,
            style: tt.bodyMedium
                ?.copyWith(color: AppThemeExtension.of(context).textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cs.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 32, color: cs.error),
          ),
          const SizedBox(height: 16),
          Text('Something went wrong',
              style: tt.titleMedium?.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            message,
            style: tt.bodyMedium?.copyWith(
                color: AppThemeExtension.of(context).textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
