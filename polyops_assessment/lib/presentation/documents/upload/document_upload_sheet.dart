import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/document_type.dart';
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
    );
  }

  @override
  Widget build(BuildContext context) => const _UploadContent();
}

class _UploadContent extends StatefulWidget {
  const _UploadContent();

  @override
  State<_UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<_UploadContent> {
  DocumentType? _selectedType;
  String? _selectedPath;
  String? _selectedName;
  int? _selectedSize;

  bool get _canUpload =>
      _selectedType != null && _selectedPath != null;

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() {
      _selectedPath = image.path;
      _selectedName = image.name;
      _selectedSize = bytes.length;
    });
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      maxHeight: 2048,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    setState(() {
      _selectedPath = image.path;
      _selectedName = image.name;
      _selectedSize = bytes.length;
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.path == null) return;
    setState(() {
      _selectedPath = file.path;
      _selectedName = file.name;
      _selectedSize = file.size;
    });
  }

  void _submit(BuildContext context) {
    if (!_canUpload) return;
    context.read<DocumentBloc>().add(DocumentEvent.uploadRequested(
          filePath: _selectedPath!,
          type: _selectedType!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

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
      child: Container(
        margin: EdgeInsets.only(bottom: bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                'Upload Document',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Select document type and choose a file.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ),

            // Document type selector
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                'DOCUMENT TYPE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
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
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _TypeChip(
                              type: type,
                              selected: _selectedType == type,
                              onTap: () =>
                                  setState(() => _selectedType = type),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            // File source
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text(
                'SELECT FILE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
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
                    onTap: _pickFromGallery,
                  ),
                  const SizedBox(width: 8),
                  _SourceButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: _pickFromCamera,
                  ),
                  const SizedBox(width: 8),
                  _SourceButton(
                    icon: Icons.picture_as_pdf_rounded,
                    label: 'PDF',
                    onTap: _pickPdf,
                  ),
                ],
              ),
            ),

            // Selected file info
            if (_selectedPath != null)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file_rounded,
                        size: 18, color: kGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedName ?? 'Selected file',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_selectedSize != null)
                            Text(
                              '${(_selectedSize! / 1024).toStringAsFixed(1)} KB',
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF6B7280)),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedPath = null;
                        _selectedName = null;
                        _selectedSize = null;
                      }),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: Color(0xFF9CA3AF)),
                    ),
                  ],
                ),
              ),

            // Upload button
            BlocBuilder<DocumentBloc, DocumentState>(
              builder: (context, state) {
                final uploading = state is DocumentLoaded &&
                    state.uploadStatus == DocumentUploadStatus.uploading;
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      16, 20, 16, 20 + MediaQuery.of(context).padding.bottom),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          (_canUpload && !uploading) ? () => _submit(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        disabledBackgroundColor:
                            const Color(0xFFE5E7EB),
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
                          : const Text(
                              'Upload Document',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? kGreen : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kGreen : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          children: [
            Icon(
              documentTypeIcon(type),
              size: 22,
              color: selected ? Colors.white : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF374151),
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
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: const Color(0xFF374151)),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
