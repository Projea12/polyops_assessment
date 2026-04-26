import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polyops_assessment/core/sync/sync_service.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/sync_conflict.dart';

class ConflictResolutionSheet extends StatefulWidget {
  const ConflictResolutionSheet._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ConflictResolutionSheet._(),
    );
  }

  @override
  State<ConflictResolutionSheet> createState() =>
      _ConflictResolutionSheetState();
}

class _ConflictResolutionSheetState extends State<ConflictResolutionSheet> {
  final _syncService = getIt<SyncService>();
  late List<SyncConflict> _conflicts;
  final Set<String> _resolving = {};

  @override
  void initState() {
    super.initState();
    _conflicts = List.of(_syncService.conflicts);
  }

  Future<void> _resolve(SyncConflict conflict, {required bool keepLocal}) async {
    setState(() => _resolving.add(conflict.taskId));
    await _syncService.resolveConflict(conflict, keepLocal: keepLocal);
    if (!mounted) return;
    setState(() {
      _resolving.remove(conflict.taskId);
      _conflicts.removeWhere((c) => c.taskId == conflict.taskId);
    });
    if (_conflicts.isEmpty) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _handle(),
          _header(),
          const Divider(height: 1),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              itemCount: _conflicts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _ConflictCard(
                conflict: _conflicts[i],
                isResolving: _resolving.contains(_conflicts[i].taskId),
                onKeepLocal: () => _resolve(_conflicts[i], keepLocal: true),
                onUseServer: () => _resolve(_conflicts[i], keepLocal: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _handle() => Center(
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

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.merge_type_rounded,
                  size: 20, color: Color(0xFFF59E0B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sync Conflicts',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2332))),
                  Text(
                    '${_conflicts.length} conflict${_conflicts.length == 1 ? '' : 's'} need your attention',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ConflictCard extends StatelessWidget {
  final SyncConflict conflict;
  final bool isResolving;
  final VoidCallback onKeepLocal;
  final VoidCallback onUseServer;

  const _ConflictCard({
    required this.conflict,
    required this.isResolving,
    required this.onKeepLocal,
    required this.onUseServer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  conflict.taskTitle,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2332)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  conflict.fieldName.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF59E0B),
                      letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _VersionBox(
                  label: 'Your version',
                  value: conflict.localValue,
                  time: conflict.localUpdatedAt,
                  actor: 'You',
                  color: const Color(0xFF1B5E37),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VersionBox(
                  label: 'Their version',
                  value: conflict.serverValue,
                  time: conflict.serverUpdatedAt,
                  actor: conflict.serverActorName,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          isResolving
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF1B5E37)),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onKeepLocal,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1B5E37),
                          side: const BorderSide(color: Color(0xFF1B5E37)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Keep mine',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: onUseServer,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text('Use theirs',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _VersionBox extends StatelessWidget {
  final String label;
  final String value;
  final DateTime time;
  final String actor;
  final Color color;

  const _VersionBox({
    required this.label,
    required this.value,
    required this.time,
    required this.actor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.3)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A2332)),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(
            '$actor · ${DateFormat('MMM d, h:mm a').format(time)}',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
