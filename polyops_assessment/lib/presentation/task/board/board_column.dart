import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polyops_assessment/presentation/task/task_detail/task_card.dart';

import '../../../../domain/entities/board_task.dart';
import '../../../../domain/entities/task_status.dart';
import 'bloc/board_bloc.dart';

class BoardColumn extends StatefulWidget {
  final TaskStatus status;
  final List<BoardTask> tasks;
  const BoardColumn({
    super.key,
    required this.status,
    required this.tasks,
  });

  @override
  State<BoardColumn> createState() => _BoardColumnState();
}

class _BoardColumnState extends State<BoardColumn> {
  final _scrollController = ScrollController();
  bool _isAutoScrolling = false;

  static const _edgeScrollThreshold = 80.0;
  static const _edgeScrollSpeed = 300.0;

  Color get _accentColor => switch (widget.status) {
        TaskStatus.todo => const Color(0xFF6366F1),
        TaskStatus.inProgress => const Color(0xFFF59E0B),
        TaskStatus.done => const Color(0xFF10B981),
      };

  IconData get _icon => switch (widget.status) {
        TaskStatus.todo => Icons.circle_outlined,
        TaskStatus.inProgress => Icons.timelapse_rounded,
        TaskStatus.done => Icons.check_circle_rounded,
      };

  @override
  void dispose() {
    _isAutoScrolling = false;
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_scrollController.hasClients) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final local = renderBox.globalToLocal(event.position);
    final height = renderBox.size.height;

    if (local.dy < _edgeScrollThreshold) {
      _startAutoScroll(-_edgeScrollSpeed);
    } else if (local.dy > height - _edgeScrollThreshold) {
      _startAutoScroll(_edgeScrollSpeed);
    } else {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll(double speed) {
    if (_isAutoScrolling) return;
    _isAutoScrolling = true;
    _autoScrollTick(speed);
  }

  void _autoScrollTick(double speed) {
    if (!_isAutoScrolling || !_scrollController.hasClients) return;
    final current = _scrollController.offset;
    final target = (current + speed / 60).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.jumpTo(target);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isAutoScrolling) _autoScrollTick(speed);
    });
  }

  void _stopAutoScroll() {
    _isAutoScrolling = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BoardBloc, BoardState, bool>(
      selector: (state) =>
          state is BoardLoaded && state.dragOverColumn == widget.status,
      builder: (context, isDragOver) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isDragOver
              ? _accentColor.withValues(alpha: 0.04)
              : const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDragOver
                ? _accentColor.withValues(alpha: 0.4)
                : const Color(0xFFE8EEF4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDragOver ? 0.08 : 0.04),
              blurRadius: isDragOver ? 16 : 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ColumnHeader(
                status: widget.status,
                count: widget.tasks.length,
                accentColor: _accentColor,
                icon: _icon,
              ),
              Expanded(
                child: DragTarget<TaskDragData>(
                  onWillAcceptWithDetails: (d) =>
                      d.data.fromStatus != widget.status,
                  onAcceptWithDetails: (d) {
                    HapticFeedback.lightImpact();
                    _stopAutoScroll();
                    context.read<BoardBloc>().add(MoveTask(
                          taskId: d.data.task.id,
                          from: d.data.fromStatus,
                          to: widget.status,
                          newPosition: widget.tasks.length,
                        ));
                  },
                  onMove: (_) => context
                      .read<BoardBloc>()
                      .add(HoverColumn(status: widget.status)),
                  onLeave: (_) {
                    _stopAutoScroll();
                    context
                        .read<BoardBloc>()
                        .add(const HoverColumn(status: null));
                  },
                  builder: (context, _, _) => Listener(
                    onPointerMove: _handlePointerMove,
                    onPointerUp: (_) => _stopAutoScroll(),
                    onPointerCancel: (_) => _stopAutoScroll(),
                    child: widget.tasks.isEmpty
                        ? _EmptyState(
                            accentColor: _accentColor,
                            isDragOver: isDragOver,
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding:
                                const EdgeInsets.fromLTRB(10, 8, 10, 80),
                            itemCount: widget.tasks.length,
                            itemBuilder: (context, index) {
                              final task = widget.tasks[index];
                              return TaskCard(
                                key: ValueKey(task.id),
                                task: task,
                                fromStatus: widget.status,
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _ColumnHeader extends StatelessWidget {
  final TaskStatus status;
  final int count;
  final Color accentColor;
  final IconData icon;

  const _ColumnHeader({
    required this.status,
    required this.count,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: accentColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accentColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              status.label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                color: accentColor,
                letterSpacing: 0.1,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  final Color accentColor;
  final bool isDragOver;

  const _EmptyState({required this.accentColor, required this.isDragOver});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isDragOver
                    ? accentColor.withValues(alpha: 0.14)
                    : accentColor.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: isDragOver
                    ? Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Icon(
                isDragOver ? Icons.add_rounded : Icons.inbox_outlined,
                color: accentColor.withValues(
                    alpha: isDragOver ? 0.8 : 0.4),
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isDragOver ? 'Drop here' : 'No tasks',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDragOver
                    ? accentColor.withValues(alpha: 0.8)
                    : Colors.grey.shade400,
              ),
            ),
            if (!isDragOver) ...[
              const SizedBox(height: 4),
              Text(
                'Drag a card or create one',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
