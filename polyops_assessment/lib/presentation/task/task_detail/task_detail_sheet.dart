import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../domain/entities/activity_entry.dart';
import '../../../../domain/entities/comment.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/entities/task_priority.dart';
import '../../../../domain/entities/task_status.dart';
import 'task_detail_bloc/task_detail_bloc.dart';

class TaskDetailSheet extends StatelessWidget {
  final String taskId;
  const TaskDetailSheet._({required this.taskId});

  static Future<void> show(BuildContext context, String taskId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) =>
            getIt<TaskDetailBloc>()..add(TaskDetailSubscribed(taskId)),
        child: _TaskDetailContent(taskId: taskId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _TaskDetailContent(taskId: taskId);
}

// ─────────────────────────────────────────────────────────────────────────────

class _TaskDetailContent extends StatelessWidget {
  final String taskId;
  const _TaskDetailContent({required this.taskId});

  static const _green = Color(0xFF1B5E37);

  static Future<void> _pickDueDate(
    BuildContext context,
    TaskDetailLoaded state,
    TaskDetailBloc bloc,
  ) async {
    final now = DateTime.now();
    final initial = state.draftDueDate ?? now.add(const Duration(days: 1));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx)
            .copyWith(colorScheme: const ColorScheme.light(primary: _green)),
        child: child!,
      ),
    );
    if (pickedDate == null || !context.mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: state.draftDueDate != null
          ? TimeOfDay.fromDateTime(state.draftDueDate!)
          : const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx)
            .copyWith(colorScheme: const ColorScheme.light(primary: _green)),
        child: child!,
      ),
    );
    if (!context.mounted) return;
    final time = pickedTime ?? const TimeOfDay(hour: 9, minute: 0);
    bloc.add(TaskDetailDueDateChanged(DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      time.hour,
      time.minute,
    )));
  }

  static void _save(
    TaskDetailLoaded state,
    TaskDetailBloc bloc,
  ) {
    final titleText = bloc.titleController.text.trim();
    if (titleText.isEmpty || state.draftDueDate == null) return;
    final description = bloc.quillController.document.toPlainText().trim();
    final richDescription =
        jsonEncode(bloc.quillController.document.toDelta().toJson());
    final task = state.task;
    bloc.add(TaskDetailSaveRequested(Task(
      id: task.id,
      title: titleText,
      description: description,
      richDescription: richDescription,
      status: state.draftStatus ?? task.status,
      priority: state.draftPriority ?? task.priority,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      dueDate: state.draftDueDate,
      isPending: task.isPending,
      boardPosition: task.boardPosition,
      comments: task.comments,
      activityHistory: task.activityHistory,
    )));
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    Task task,
    TaskDetailBloc bloc,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete task?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text(
          'This will permanently delete "${task.title}" and all its comments.',
          style: const TextStyle(color: Color(0xFF546E7A)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    bloc.add(TaskDetailDeleteRequested(task.id));
  }

  static void _submitComment(
    BuildContext context,
    String taskId,
    TaskDetailBloc bloc,
  ) {
    final content = bloc.commentController.text.trim();
    if (content.isEmpty) return;
    FocusScope.of(context).unfocus();
    bloc.add(TaskDetailCommentSubmitted(taskId: taskId, content: content));
    bloc.commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final bloc = context.read<TaskDetailBloc>();

    return DefaultTabController(
      length: 3,
      child: BlocListener<TaskDetailBloc, TaskDetailState>(
        listener: (context, state) {
          if (state is TaskDetailSaveSuccess) {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.pop(context);
            messenger.showSnackBar(SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text('Task updated successfully'),
                ],
              ),
              backgroundColor: _green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ));
          } else if (state is TaskDetailDeleteSuccess) {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.pop(context);
            messenger.showSnackBar(SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.delete_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 10),
                  Text('Task deleted successfully'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ));
          } else if (state is TaskDetailLoaded && state.operationError != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.operationError!),
              backgroundColor: Colors.red.shade700,
            ));
          }
        },
        child: BlocBuilder<TaskDetailBloc, TaskDetailState>(
          builder: (context, state) {
            if (state is TaskDetailLoading || state is TaskDetailInitial) {
              return Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.94),
                padding: EdgeInsets.only(bottom: bottom),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF1B5E37)),
                  ),
                ),
              );
            }

            if (state is TaskDetailError) {
              return Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(child: Text(state.message)),
              );
            }

            if (state is! TaskDetailLoaded) return const SizedBox.shrink();

            final task = state.task;

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.94),
                padding: EdgeInsets.only(bottom: bottom),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SheetHandle(),
                    _SheetHeader(
                      task: task,
                      isEditing: state.isEditing,
                      titleController: bloc.titleController,
                      onEdit: () => bloc.add(const TaskDetailEditEntered()),
                      onCancel: () => bloc.add(const TaskDetailEditCancelled()),
                    ),
                    const SizedBox(height: 10),
                    if (state.isEditing) ...[
                      _EditStatusRow(
                        status: state.draftStatus ?? task.status,
                        onChanged: (s) =>
                            bloc.add(TaskDetailStatusChanged(s)),
                      ),
                      const SizedBox(height: 8),
                      _EditPriorityRow(
                        selected: state.draftPriority ?? task.priority,
                        onChanged: (p) =>
                            bloc.add(TaskDetailPriorityChanged(p)),
                      ),
                      const SizedBox(height: 8),
                      _EditDueDateRow(
                        dueDate: state.draftDueDate,
                        onTap: () => _pickDueDate(context, state, bloc),
                        onClear: () =>
                            bloc.add(const TaskDetailDueDateChanged(null)),
                      ),
                    ] else
                      _ViewMetaRow(task: task),
                    const SizedBox(height: 12),
                    TabBar(
                      labelColor: _green,
                      unselectedLabelColor: Colors.grey.shade500,
                      indicatorColor: _green,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      tabs: [
                        const Tab(text: 'Description'),
                        Tab(
                          child: _CountTabLabel(
                            label: 'Comments',
                            count: task.comments.length,
                            color: _green,
                          ),
                        ),
                        Tab(
                          child: _CountTabLabel(
                            label: 'Activity',
                            count: task.activityHistory.length,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _DescriptionTab(
                            controller: bloc.quillController,
                            readOnly: !state.isEditing,
                          ),
                          _CommentsTab(
                            comments: task.comments,
                            commentController: bloc.commentController,
                            isSubmitting: state.isSubmittingComment,
                            onSubmit: () =>
                                _submitComment(context, task.id, bloc),
                          ),
                          _ActivityTab(entries: task.activityHistory),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: bloc.titleController,
                      builder: (_, titleVal, __) {
                        final canSave = titleVal.text.trim().isNotEmpty &&
                            state.draftDueDate != null;
                        return _BottomBar(
                          isEditing: state.isEditing,
                          isSubmitting: state.isSaving,
                          canSave: canSave,
                          onDelete: () =>
                              _confirmDelete(context, task, bloc),
                          onEdit: () =>
                              bloc.add(const TaskDetailEditEntered()),
                          onCancel: () =>
                              bloc.add(const TaskDetailEditCancelled()),
                          onSave: () => _save(state, bloc),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Handle ────────────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Sheet header ──────────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  final Task task;
  final bool isEditing;
  final TextEditingController titleController;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const _SheetHeader({
    required this.task,
    required this.isEditing,
    required this.titleController,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: isEditing
                ? TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2332),
                      height: 1.25,
                    ),
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Task title *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF1B5E37), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF1B5E37), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                  )
                : Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2332),
                      height: 1.3,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          _IconBtn(
            icon: isEditing ? Icons.close_rounded : Icons.edit_outlined,
            color: isEditing
                ? Colors.grey.shade600
                : const Color(0xFF1B5E37),
            bgColor: isEditing
                ? Colors.grey.shade100
                : const Color(0xFF1B5E37).withValues(alpha: 0.08),
            onTap: isEditing ? onCancel : onEdit,
            tooltip: isEditing ? 'Cancel editing' : 'Edit task',
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final String tooltip;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

// ── View metadata ─────────────────────────────────────────────────────────────

class _ViewMetaRow extends StatelessWidget {
  final Task task;
  const _ViewMetaRow({required this.task});

  Color _statusColor(TaskStatus s) => switch (s) {
        TaskStatus.todo => const Color(0xFF6366F1),
        TaskStatus.inProgress => const Color(0xFFF59E0B),
        TaskStatus.done => const Color(0xFF10B981),
      };

  IconData _statusIcon(TaskStatus s) => switch (s) {
        TaskStatus.todo => Icons.circle_outlined,
        TaskStatus.inProgress => Icons.timelapse_rounded,
        TaskStatus.done => Icons.check_circle_rounded,
      };

  Color _priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.low => const Color(0xFF78909C),
        TaskPriority.medium => const Color(0xFFF57C00),
        TaskPriority.high => const Color(0xFFE53935),
        TaskPriority.critical => const Color(0xFF6A1B9A),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _MetaChip(
            icon: _statusIcon(task.status),
            label: task.status.label,
            color: _statusColor(task.status),
          ),
          _MetaChip(
            icon: Icons.flag_outlined,
            label: task.priority.label,
            color: _priorityColor(task.priority),
          ),
          if (task.dueDate != null)
            _MetaChip(
              icon: task.isOverdue
                  ? Icons.warning_amber_rounded
                  : Icons.calendar_today_outlined,
              label: DateFormat('EEE, MMM d · h:mm a').format(task.dueDate!),
              color: task.isOverdue
                  ? const Color(0xFFE53935)
                  : const Color(0xFF546E7A),
            ),
          _MetaChip(
            icon: Icons.access_time_rounded,
            label:
                'Created ${DateFormat('MMM d, yyyy').format(task.createdAt)}',
            color: Colors.grey.shade500,
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ── Edit fields ───────────────────────────────────────────────────────────────

class _EditStatusRow extends StatelessWidget {
  final TaskStatus status;
  final ValueChanged<TaskStatus> onChanged;

  const _EditStatusRow({required this.status, required this.onChanged});

  Color _colorFor(TaskStatus s) => switch (s) {
        TaskStatus.todo => const Color(0xFF6366F1),
        TaskStatus.inProgress => const Color(0xFFF59E0B),
        TaskStatus.done => const Color(0xFF10B981),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text('Status',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(width: 14),
          ...TaskStatus.values.map((s) {
            final isSelected = s == status;
            final color = _colorFor(s);
            return GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Text(s.label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : color)),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EditPriorityRow extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority> onChanged;

  const _EditPriorityRow(
      {required this.selected, required this.onChanged});

  Color _colorFor(TaskPriority p) => switch (p) {
        TaskPriority.low => const Color(0xFF78909C),
        TaskPriority.medium => const Color(0xFFF57C00),
        TaskPriority.high => const Color(0xFFE53935),
        TaskPriority.critical => const Color(0xFF6A1B9A),
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text('Priority',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500)),
          const SizedBox(width: 14),
          Wrap(
            spacing: 6,
            children: TaskPriority.values.map((p) {
              final isSelected = p == selected;
              final color = _colorFor(p);
              return GestureDetector(
                onTap: () => onChanged(p),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? color : color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(p.label,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : color)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _EditDueDateRow extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _EditDueDateRow(
      {required this.dueDate, required this.onTap, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final hasDate = dueDate != null;
    final color =
        hasDate ? const Color(0xFF1B5E37) : Colors.red.shade400;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Due date *',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500)),
            const SizedBox(width: 14),
            Icon(Icons.calendar_today_outlined, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              hasDate
                  ? DateFormat('EEE, MMM d · h:mm a').format(dueDate!)
                  : 'Required — tap to set',
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight:
                      hasDate ? FontWeight.w600 : FontWeight.normal),
            ),
            if (hasDate) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onClear,
                child:
                    Icon(Icons.close, size: 14, color: Colors.grey.shade400),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Tab label ─────────────────────────────────────────────────────────────────

class _CountTabLabel extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountTabLabel({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (count > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ],
    );
  }
}

// ── Description tab ───────────────────────────────────────────────────────────

class _DescriptionTab extends StatelessWidget {
  final QuillController controller;
  final bool readOnly;

  const _DescriptionTab(
      {required this.controller, required this.readOnly});

  static const _toolbarConfig = QuillSimpleToolbarConfig(
    showFontFamily: true,
    showFontSize: true,
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
  );

  Widget _wrapEditorTheme({required Widget child}) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF37474F),
        height: 1.5,
        fontFamily: null,
      ),
      child: child,
    );
  }

  Widget _wrapToolbarTheme({required Widget child}) {
    return Theme(
      data: ThemeData(
        colorScheme: const ColorScheme.light(primary: Color(0xFF1B5E37)),
        iconTheme:
            const IconThemeData(size: 20, color: Color(0xFF546E7A)),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            minimumSize: const Size(32, 32),
            padding: const EdgeInsets.all(4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (readOnly) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: IgnorePointer(
          child: _wrapEditorTheme(
            child: QuillEditor.basic(
              controller: controller,
              config: const QuillEditorConfig(
                expands: false,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _wrapToolbarTheme(
            child: Container(
              color: const Color(0xFFF8FAFC),
              child: QuillSimpleToolbar(
                controller: controller,
                config: _toolbarConfig,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _wrapEditorTheme(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 160, maxHeight: 400),
              child: QuillEditor.basic(
                controller: controller,
                config: const QuillEditorConfig(
                  placeholder: 'Add a description...',
                  padding: EdgeInsets.all(16),
                  expands: false,
                  scrollable: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Comments tab ──────────────────────────────────────────────────────────────

class _CommentsTab extends StatelessWidget {
  final List<Comment> comments;
  final TextEditingController commentController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _CommentsTab({
    required this.comments,
    required this.commentController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: comments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 36, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('No comments yet',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 13)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      _CommentBubble(comment: comments[i]),
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              _Avatar(initial: 'J'),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: commentController,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Color(0xFF1B5E37), width: 1.5),
                    ),
                    suffixIcon: isSubmitting
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF1B5E37),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send_rounded,
                                color: Color(0xFF1B5E37), size: 18),
                            onPressed: onSubmit,
                          ),
                  ),
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final Comment comment;
  const _CommentBubble({required this.comment});

  @override
  Widget build(BuildContext context) {
    final initial = comment.authorName.isNotEmpty
        ? comment.authorName[0].toUpperCase()
        : '?';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(initial: initial),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(comment.authorName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Color(0xFF1A2332))),
                  const SizedBox(width: 8),
                  Text(
                      DateFormat('MMM d · h:mm a')
                          .format(comment.createdAt),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400)),
                  if (comment.isEdited) ...[
                    const SizedBox(width: 4),
                    Text('(edited)',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade400)),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Text(comment.content,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF37474F),
                        height: 1.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Activity tab ──────────────────────────────────────────────────────────────

class _ActivityTab extends StatelessWidget {
  final List<ActivityEntry> entries;
  const _ActivityTab({required this.entries});

  IconData _iconFor(ActivityAction a) => switch (a) {
        ActivityAction.taskCreated => Icons.add_circle_outline_rounded,
        ActivityAction.taskUpdated => Icons.edit_outlined,
        ActivityAction.taskMoved => Icons.swap_horiz_rounded,
        ActivityAction.taskDeleted => Icons.delete_outline_rounded,
        ActivityAction.commentAdded => Icons.chat_bubble_outline_rounded,
        ActivityAction.commentEdited => Icons.edit_note_rounded,
        ActivityAction.priorityChanged => Icons.flag_outlined,
        ActivityAction.dueDateSet => Icons.calendar_today_outlined,
        ActivityAction.dueDateCleared => Icons.event_busy_outlined,
      };

  Color _colorFor(ActivityAction a) => switch (a) {
        ActivityAction.taskCreated => const Color(0xFF10B981),
        ActivityAction.taskUpdated => const Color(0xFF6366F1),
        ActivityAction.taskMoved => const Color(0xFFF59E0B),
        ActivityAction.taskDeleted => const Color(0xFFE53935),
        ActivityAction.commentAdded => const Color(0xFF0EA5E9),
        ActivityAction.commentEdited => const Color(0xFF0EA5E9),
        ActivityAction.priorityChanged => const Color(0xFF6A1B9A),
        ActivityAction.dueDateSet => const Color(0xFF1B5E37),
        ActivityAction.dueDateCleared => const Color(0xFF78909C),
      };

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded,
                size: 36, color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Text('No activity yet',
                style: TextStyle(
                    color: Colors.grey.shade400, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        final color = _colorFor(entry.action);
        final isLast = i == entries.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_iconFor(entry.action),
                        size: 15, color: color),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: Colors.grey.shade200,
                        margin:
                            const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(entry.description,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A2332))),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(entry.actorName,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500)),
                          Text(' · ',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400)),
                          Text(
                              DateFormat('MMM d, yyyy · h:mm a')
                                  .format(entry.timestamp),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade400)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Shared avatar ─────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initial;
  const _Avatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFF1B5E37),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(initial,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ),
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool isEditing;
  final bool isSubmitting;
  final bool canSave;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _BottomBar({
    required this.isEditing,
    required this.isSubmitting,
    required this.canSave,
    required this.onDelete,
    required this.onEdit,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: isSubmitting ? null : onDelete,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade600,
              side: BorderSide(color: Colors.red.shade200),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing
                ? FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: canSave
                          ? const Color(0xFF1B5E37)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed:
                        isSubmitting || !canSave ? null : onSave,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            canSave
                                ? 'Save changes'
                                : 'Set title & due date to save',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: canSave ? 15 : 12,
                              color: canSave
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1B5E37),
                      side: const BorderSide(color: Color(0xFF1B5E37)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: onEdit,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('Edit task',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
