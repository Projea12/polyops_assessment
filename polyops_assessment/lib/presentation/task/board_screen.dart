import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polyops_assessment/core/sync/sync_service.dart';
import 'package:polyops_assessment/presentation/task/conflict_resolution_sheet.dart';
import 'package:polyops_assessment/presentation/task/task_form_sheet.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/sync_conflict.dart';
import '../../../domain/entities/task_status.dart';
import 'bloc/board_bloc.dart';
import 'board_column.dart';


class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>
    with WidgetsBindingObserver {
  final _syncService = getIt<SyncService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncService.sync());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _syncService.sync();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BoardBloc>()..add(const LoadBoard()),
      child: const _BoardView(),
    );
  }
}

class _BoardView extends StatelessWidget {
  const _BoardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF2FB),
      body: Column(
        children: [
          const _BoardAppBar(),
          Expanded(
            child: BlocBuilder<BoardBloc, BoardState>(
              builder: (context, state) => switch (state) {
                BoardInitial() => const SizedBox.shrink(),
                BoardLoading() => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1B5E37),
                      strokeWidth: 2.5,
                    ),
                  ),
                BoardError(:final message) => _ErrorView(message: message),
                BoardLoaded() => _BoardColumns(state: state),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _BoardAppBar extends StatelessWidget {
  const _BoardAppBar();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E37), Color(0xFF2A7D52)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo mark
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SWAMP_',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                  Text(
                    'Smart Waste Management',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _ConflictBadgeButton(),
              const SizedBox(width: 8),
              _AddTaskButton(),
            ],
          ),
          const SizedBox(height: 18),
          BlocBuilder<BoardBloc, BoardState>(
            buildWhen: (prev, curr) => curr is BoardLoaded,
            builder: (context, state) {
              if (state is! BoardLoaded) return const SizedBox.shrink();
              final todo = state.tasksFor(TaskStatus.todo).length;
              final inProgress =
                  state.tasksFor(TaskStatus.inProgress).length;
              final done = state.tasksFor(TaskStatus.done).length;
              final total = todo + inProgress + done;
              final pct =
                  total == 0 ? 0.0 : done / total;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.dashboard_outlined,
                        label: 'Total',
                        value: total,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.timelapse_rounded,
                        label: 'In Progress',
                        value: inProgress,
                        color: const Color(0xFFFBBF24),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Done',
                        value: done,
                        color: const Color(0xFF6EE7B7),
                      ),
                    ],
                  ),
                  if (total > 0) ...[
                    const SizedBox(height: 12),
                    _ProgressBar(pct: pct, done: done, total: total),
                  ],
                ],
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
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            '$value $label',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double pct;
  final int done;
  final int total;

  const _ProgressBar(
      {required this.pct, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${(pct * 100).round()}% complete',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '$done / $total tasks done',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 5,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF6EE7B7),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConflictBadgeButton extends StatelessWidget {
  final _syncService = getIt<SyncService>();

  _ConflictBadgeButton();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SyncConflict>>(
      stream: _syncService.conflictsStream,
      initialData: _syncService.conflicts,
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        if (count == 0) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => ConflictResolutionSheet.show(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.merge_type_rounded,
                    size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 5),
                Text(
                  '$count conflict${count == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => TaskFormSheet.show(context),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 17, color: Color(0xFF1B5E37)),
            SizedBox(width: 6),
            Text(
              'New Task',
              style: TextStyle(
                color: Color(0xFF1B5E37),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Board columns ─────────────────────────────────────────────────────────────

class _BoardColumns extends StatelessWidget {
  final BoardLoaded state;
  const _BoardColumns({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: TaskStatus.values
            .map(
              (status) => SizedBox(
                width: 270,
                height: double.infinity,
                child: BoardColumn(
                  status: status,
                  tasks: state.tasksFor(status),
                ),
              ),
            )
            .toList(),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline_rounded,
                size: 32, color: Colors.red.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
