import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/task_priority.dart';
import 'bloc/task_form_bloc.dart';

class TaskFormSheet extends StatelessWidget {
  const TaskFormSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<TaskFormBloc>(),
        child: const TaskFormSheet._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _TaskFormContent();
  }
}

class _TaskFormContent extends StatefulWidget {
  const _TaskFormContent();

  @override
  State<_TaskFormContent> createState() => _TaskFormContentState();
}

class _TaskFormContentState extends State<_TaskFormContent> {
  final _titleController = TextEditingController();
  final _quillController = QuillController.basic();
  final _titleFocus = FocusNode();

  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  static const _green = Color(0xFF1B5E37);

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty && _dueDate != null;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now.add(const Duration(days: 1));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _green),
        ),
        child: child!,
      ),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _dueDate != null
          ? TimeOfDay.fromDateTime(_dueDate!)
          : const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _green),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;

    final time = pickedTime ?? const TimeOfDay(hour: 9, minute: 0);
    setState(() {
      _dueDate = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day,
        time.hour, time.minute,
      );
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _titleFocus.requestFocus();
      return;
    }
    context.read<TaskFormBloc>().add(TaskFormSubmitted(
      title: title,
      description: _quillController.document.toPlainText().trim(),
      richDescription:
          jsonEncode(_quillController.document.toDelta().toJson()),
      priority: _priority,
      dueDate: _dueDate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return BlocListener<TaskFormBloc, TaskFormState>(
      listener: (context, state) {
        if (state is TaskFormSuccess) Navigator.pop(context);
        if (state is TaskFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.red.shade700,
          ));
        }
      },
      child: BlocBuilder<TaskFormBloc, TaskFormState>(
        builder: (context, state) {
          final isSubmitting = state is TaskFormSubmitting;
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.92,
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SheetHandle(),
                const SizedBox(height: 4),
                const Text(
                  'New Task',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TitleField(
                          controller: _titleController,
                          focusNode: _titleFocus,
                        ),
                        const SizedBox(height: 20),
                        _SectionLabel('Description'),
                        const SizedBox(height: 8),
                        _RichDescriptionField(
                            controller: _quillController),
                        const SizedBox(height: 20),
                        _SectionLabel('Priority'),
                        const SizedBox(height: 8),
                        _PrioritySelector(
                          selected: _priority,
                          onChanged: (p) =>
                              setState(() => _priority = p),
                        ),
                        const SizedBox(height: 20),
                        _SectionLabel('Due Date'),
                        const SizedBox(height: 8),
                        _DueDatePicker(
                          selected: _dueDate,
                          onTap: _pickDueDate,
                          onClear: () =>
                              setState(() => _dueDate = null),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                _SubmitButton(
                  isLoading: isSubmitting,
                  canSubmit: _canSubmit && !isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF546E7A),
        letterSpacing: 0.3,
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _TitleField({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: 'Title *',
        hintText: 'What needs to be done?',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF1B5E37), width: 2),
        ),
      ),
    );
  }
}

class _RichDescriptionField extends StatelessWidget {
  final QuillController controller;
  const _RichDescriptionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: controller,
            config: const QuillSimpleToolbarConfig(
              showBoldButton: true,
              showItalicButton: true,
              showUnderLineButton: true,
              showStrikeThrough: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: true,
              showAlignmentButtons: false,
              showLeftAlignment: false,
              showCenterAlignment: false,
              showRightAlignment: false,
              showJustifyAlignment: false,
              showHeaderStyle: false,
              showListNumbers: true,
              showListBullets: true,
              showListCheck: false,
              showCodeBlock: false,
              showQuote: false,
              showIndent: false,
              showLink: false,
              showUndo: true,
              showRedo: true,
              showSuperscript: false,
              showSubscript: false,
              showSmallButton: false,
              showDividers: true,
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 140,
            child: QuillEditor.basic(
              controller: controller,
              config: const QuillEditorConfig(
                placeholder: 'Add a description...',
                padding: EdgeInsets.all(12),
                expands: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  const _PrioritySelector(
      {required this.selected, required this.onChanged});

  Color _colorFor(TaskPriority p) => switch (p) {
        TaskPriority.low => const Color(0xFF78909C),
        TaskPriority.medium => const Color(0xFFF57C00),
        TaskPriority.high => const Color(0xFFE53935),
        TaskPriority.critical => const Color(0xFF6A1B9A),
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: TaskPriority.values.map((p) {
        final isSelected = p == selected;
        final color = _colorFor(p);
        return FilterChip(
          label: Text(
            p.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : color,
            ),
          ),
          selected: isSelected,
          onSelected: (_) => onChanged(p),
          backgroundColor: color.withValues(alpha: 0.08),
          selectedColor: color,
          checkmarkColor: Colors.white,
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }).toList(),
    );
  }
}

class _DueDatePicker extends StatelessWidget {
  final DateTime? selected;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DueDatePicker({
    required this.selected,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected != null
                ? const Color(0xFF1B5E37)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selected != null
              ? const Color(0xFF1B5E37).withValues(alpha: 0.05)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: selected != null
                  ? const Color(0xFF1B5E37)
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Text(
              selected != null
                  ? DateFormat('EEE, MMM d yyyy · h:mm a')
                      .format(selected!)
                  : 'Set due date and time',
              style: TextStyle(
                fontSize: 14,
                color: selected != null
                    ? const Color(0xFF1B5E37)
                    : Colors.grey.shade500,
                fontWeight: selected != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (selected != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close,
                    size: 18, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool canSubmit;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.isLoading,
    required this.canSubmit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor:
              canSubmit ? const Color(0xFF1B5E37) : Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading || !canSubmit ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                canSubmit ? 'Create Task' : 'Add title & due date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: canSubmit ? Colors.white : Colors.grey.shade500,
                ),
              ),
      ),
    );
  }
}
