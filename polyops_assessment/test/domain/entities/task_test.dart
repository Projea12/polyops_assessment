import 'package:flutter_test/flutter_test.dart';
import 'package:polyops_assessment/domain/entities/task_status.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Task.isOverdue', () {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    test('true when dueDate is in the past and status is not done', () {
      final task = makeTask(dueDate: yesterday, status: TaskStatus.todo);
      expect(task.isOverdue, isTrue);
    });

    test('false when dueDate is in the past but status is done', () {
      final task = makeTask(dueDate: yesterday, status: TaskStatus.done);
      expect(task.isOverdue, isFalse);
    });

    test('false when dueDate is in the future', () {
      final task = makeTask(dueDate: tomorrow, status: TaskStatus.todo);
      expect(task.isOverdue, isFalse);
    });

    test('false when dueDate is null', () {
      final task = makeTask(dueDate: null);
      expect(task.isOverdue, isFalse);
    });
  });

  group('Task equality', () {
    test('equal when id and updatedAt match', () {
      final t1 = makeTask(id: 'x', updatedAt: DateTime(2025));
      final t2 = makeTask(id: 'x', updatedAt: DateTime(2025), title: 'Different');
      expect(t1, equals(t2));
    });

    test('not equal when updatedAt differs', () {
      final t1 = makeTask(id: 'x', updatedAt: DateTime(2025, 1, 1));
      final t2 = makeTask(id: 'x', updatedAt: DateTime(2025, 1, 2));
      expect(t1, isNot(equals(t2)));
    });

    test('not equal when id differs', () {
      final t1 = makeTask(id: 'a', updatedAt: DateTime(2025));
      final t2 = makeTask(id: 'b', updatedAt: DateTime(2025));
      expect(t1, isNot(equals(t2)));
    });
  });

  group('Task.copyWith', () {
    test('returns new instance with updated fields', () {
      final original = makeTask(title: 'Original', status: TaskStatus.todo);
      final updated = original.copyWith(title: 'Updated', status: TaskStatus.done);

      expect(updated.title, 'Updated');
      expect(updated.status, TaskStatus.done);
      expect(updated.id, original.id);
      expect(updated.description, original.description);
    });

    test('preserves all unchanged fields', () {
      final original = makeTask(isPending: true);
      final updated = original.copyWith(title: 'New Title');
      expect(updated.isPending, isTrue);
    });
  });
}
