import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme_extension.dart';
import '../../../domain/entities/document_type.dart';
import '../../../domain/entities/file_source.dart';
import '../bloc/document_bloc.dart';
import '../document_theme.dart';

class DocumentUploadSheet extends StatelessWidget {
  const DocumentUploadSheet._();

  static Future<void> show(BuildContext context) {
    final bloc = context.read<DocumentBloc>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: const DocumentUploadSheet._(),
      ),
    ).then((_) => bloc.add(const DocumentDraftCleared()));
  }

  @override
  Widget build(BuildContext context) => const _UploadContent();
}

class _UploadContent extends StatelessWidget {
  const _UploadContent();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return BlocListener<DocumentBloc, DocumentState>(
      listenWhen: (prev, curr) =>
          prev is DocumentLoaded &&
          curr is DocumentLoaded &&
          prev.uploadStatus != curr.uploadStatus,
      listener: (context, state) {
        if (state is! DocumentLoaded) return;
        if (state.uploadStatus == DocumentUploadStatus.success) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          final loaded = state is DocumentLoaded ? state : null;
          final uploading =
              loaded?.uploadStatus == DocumentUploadStatus.uploading;

          return Container(
            margin: EdgeInsets.only(bottom: bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ext.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: Text('Upload Document', style: tt.headlineMedium),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'Select document type and choose a file.',
                    style: tt.bodyMedium?.copyWith(color: ext.textSecondary),
                  ),
                ),

                // Document type selector
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'DOCUMENT TYPE',
                    style: tt.labelMedium?.copyWith(
                      color: ext.textTertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Row(
                    children: DocumentType.values
                        .map((type) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _TypeChip(
                                  type: type,
                                  selected: loaded?.draftType == type,
                                  onTap: () => context
                                      .read<DocumentBloc>()
                                      .add(DocumentTypeSelected(type)),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                // File source
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Text(
                    'SELECT FILE',
                    style: tt.labelMedium?.copyWith(
                      color: ext.textTertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      _SourceButton(
                        icon: Icons.photo_library_rounded,
                        label: 'Gallery',
                        selected:
                            loaded?.activePickerSource == FileSource.gallery,
                        onTap: () => context.read<DocumentBloc>().add(
                            const DocumentPickFileRequested(FileSource.gallery)),
                      ),
                      const SizedBox(width: 8),
                      _SourceButton(
                        icon: Icons.camera_alt_rounded,
                        label: 'Camera',
                        selected:
                            loaded?.activePickerSource == FileSource.camera,
                        onTap: () => context.read<DocumentBloc>().add(
                            const DocumentPickFileRequested(FileSource.camera)),
                      ),
                      const SizedBox(width: 8),
                      _SourceButton(
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'PDF',
                        selected: loaded?.activePickerSource == FileSource.pdf,
                        onTap: () => context.read<DocumentBloc>().add(
                            const DocumentPickFileRequested(FileSource.pdf)),
                      ),
                    ],
                  ),
                ),

                // Selected file info
                if (loaded?.draftFile != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: ext.brandGreenSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ext.brandGreenBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file_rounded,
                            size: 18, color: cs.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loaded!.draftFile!.name,
                                style: tt.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${(loaded.draftFile!.size / 1024).toStringAsFixed(1)} KB',
                                style: tt.labelSmall
                                    ?.copyWith(color: ext.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context
                              .read<DocumentBloc>()
                              .add(const DocumentFileCleared()),
                          child: Icon(Icons.close_rounded,
                              size: 16, color: ext.textTertiary),
                        ),
                      ],
                    ),
                  ),

                // Upload button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      16,
                      20,
                      16,
                      20 + MediaQuery.of(context).padding.bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: ((loaded?.canUpload ?? false) && !uploading)
                          ? () => context
                              .read<DocumentBloc>()
                              .add(const DocumentUploadRequested())
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        disabledBackgroundColor: ext.borderLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: uploading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Text(
                              'Upload Document',
                              style: tt.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final DocumentType type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? cs.primary : ext.surfaceSubtle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? cs.primary : ext.borderLight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              documentTypeIcon(type),
              size: 22,
              color: selected ? Colors.white : ext.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: tt.labelMedium?.copyWith(
                color: selected ? Colors.white : ext.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = AppThemeExtension.of(context);
    final tt = Theme.of(context).textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? cs.primary : ext.surfaceSubtle,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? cs.primary : ext.borderLight,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22,
                  color: selected ? Colors.white : ext.textMuted),
              const SizedBox(height: 6),
              Text(
                label,
                style: tt.labelLarge?.copyWith(
                  color: selected ? Colors.white : ext.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
