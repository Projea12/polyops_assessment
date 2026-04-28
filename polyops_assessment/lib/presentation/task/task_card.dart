import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:polyops_assessment/presentation/task/task_detail_sheet.dart';

import '../../../domain/entities/board_task.dart';
import '../../../domain/entities/task_priority.dart';
import '../../../domain/entities/task_status.dart';
import 'bloc/board_bloc.dart';

class TaskDragData {
  final BoardTask task;
  final TaskStatus fromStatus;
  const TaskDragData({required this.task, required this.fromStatus});
}

class TaskCard extends StatefulWidget {
  final BoardTask task;
  final TaskStatus fromStatus;

  const TaskCard({
    super.key,
    required this.task,
    required this.fromStatus,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cancelController;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _cancelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _cancelController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _cancelController.dispose();
    super.dispose();
  }

  void _onDragStarted() {
    HapticFeedback.mediumImpact();
    context.read<BoardBloc>().add(DragStarted(taskId: widget.task.id));
  }

  void _onDragEnd(DraggableDetails _) {
    context.read<BoardBloc>().add(const DragEnded());
  }

  void _onDraggableCanceled(Velocity _, Offset __) {
    _cancelController.forward(from: 0);
    HapticFeedback.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BlocSelector<BoardBloc, BoardState, bool>(
        selector: (state) =>
            state is BoardLoaded && state.draggingTaskId == widget.task.id,
        builder: (context, isDragging) => AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isDragging ? 0.2 : 1.0,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Stack(
              children: [
                LongPressDraggable<TaskDragData>(
                  delay: const Duration(milliseconds: 450),
                  data: TaskDragData(
                      task: widget.task, fromStatus: widget.fromStatus),
                  onDragStarted: _onDragStarted,
                  onDragEnd: _onDragEnd,
                  onDraggableCanceled: _onDraggableCanceled,
                  feedback: _DragFeedback(task: widget.task),
                  childWhenDragging: const SizedBox.shrink(),
                  child: _CardBody(
                    task: widget.task,
                    onTap: () => TaskDetailSheet.show(context, widget.task.id),
                  ),
                ),
                if (widget.task.isPending)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: _SyncPendingDot(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Drag feedback ─────────────────────────────────────────────────────────────

class _DragFeedback extends StatelessWidget {
  final BoardTask task;
  const _DragFeedback({required this.task});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Transform.rotate(
        angle: -0.03,
        child: Opacity(
          opacity: 0.93,
          child: SizedBox(
            width: 220,
            child: _CardBody(task: task, shadowElevation: 14),
          ),
        ),
      ),
    );
  }
}

// ── Card body ─────────────────────────────────────────────────────────────────

class _CardBody extends StatelessWidget {
  final BoardTask task;
  final VoidCallback? onTap;
  final double shadowElevation;

  const _CardBody({
    required this.task,
    this.onTap,
    this.shadowElevation = 0,
  });

  Color get _priorityColor => switch (task.priority) {
        TaskPriority.low => const Color(0xFF78909C),
        TaskPriority.medium => const Color(0xFFF57C00),
        TaskPriority.high => const Color(0xFFE53935),
        TaskPriority.critical => const Color(0xFF6A1B9A),
      };

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.isOverdue;
    final isDone = task.isDone;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDone
            ? const Color(0xFFF8FFF9)
            : isOverdue
                ? const Color(0xFFFFF8F8)
                : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: _priorityColor, width: 4)),
        boxShadow: shadowElevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: shadowElevation,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 2,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: _priorityColor.withValues(alpha: 0.06),
          highlightColor: _priorityColor.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDone)
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 1),
                        child: Icon(Icons.check_circle_rounded,
                            size: 15, color: const Color(0xFF10B981)),
                      ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: isDone
                              ? Colors.grey.shade500
                              : const Color(0xFF1A2332),
                          height: 1.3,
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.grey.shade400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _PriorityPill(
                        priority: task.priority, color: _priorityColor),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        height: 1.45),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (task.dueDate != null)
                      _DueDateChip(
                          date: task.dueDate!, isOverdue: isOverdue),
                    const Spacer(),
                    if (task.commentCount > 0)
                      _CommentBadge(count: task.commentCount),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Priority pill ─────────────────────────────────────────────────────────────

class _PriorityPill extends StatelessWidget {
  final TaskPriority priority;
  final Color color;
  const _PriorityPill({required this.priority, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        priority.label.toUpperCase(),
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5),
      ),
    );
  }
}

// ── Due date chip ─────────────────────────────────────────────────────────────

class _DueDateChip extends StatelessWidget {
  final DateTime date;
  final bool isOverdue;
  const _DueDateChip({required this.date, required this.isOverdue});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final diff = dateDay.difference(today).inDays;
    final time = DateFormat('h:mm a').format(date);

    if (isOverdue) {
      final overdueHours = now.difference(date).inHours;
      if (overdueHours < 1) return 'Overdue · just now';
      if (overdueHours < 24) return 'Overdue · ${overdueHours}h ago';
      return 'Overdue · ${now.difference(date).inDays}d ago';
    }
    if (diff == 0) return 'Today $time';
    if (diff == 1) return 'Tomorrow $time';
    if (diff > 1 && diff < 7) return '${DateFormat('EEE').format(date)} $time';
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final color =
        isOverdue ? const Color(0xFFE53935) : const Color(0xFF546E7A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isOverdue
            ? const Color(0xFFE53935).withValues(alpha: 0.08)
            : Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue
                ? Icons.warning_amber_rounded
                : Icons.schedule_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(_label(),
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ── Sync pending dot ──────────────────────────────────────────────────────────

class _SyncPendingDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Pending sync',
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFFF59E0B),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Comment badge ─────────────────────────────────────────────────────────────

class _CommentBadge extends StatelessWidget {
  final int count;
  const _CommentBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chat_bubble_outline_rounded,
            size: 12, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text('$count',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400)),
      ],
    );
  }
}
