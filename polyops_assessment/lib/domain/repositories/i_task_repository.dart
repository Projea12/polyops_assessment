import 'package:fpdart/fpdart.dart' hide Task;

import '../entities/board_task.dart';
import '../entities/task.dart';
import '../entities/task_status.dart';
import '../entities/comment.dart';
import '../entities/activity_entry.dart';
import '../failures/failures.dart';

abstract class ITaskRepository {
  Stream<List<BoardTask>> watchBoardTasksByStatus(TaskStatus status);
  Stream<List<Task>> watchTasksByStatus(TaskStatus status);
  Stream<Task> watchTask(String id);

  Future<Either<Failure, Task>> getTask(String id);
  Future<Either<Failure, List<Task>>> getAllTasks();

  Future<Either<Failure, Task>> createTask({
    required String title,
    required String description,
    String? richDescription,
    required String priority,
    DateTime? dueDate,
  });

  Future<Either<Failure, Task>> updateTask(Task task);

  Future<Either<Failure, Task>> moveTask({
    required String taskId,
    required TaskStatus from,
    required TaskStatus to,
    required int newPosition,
  });

  Future<Either<Failure, Unit>> deleteTask(String id);

  Future<Either<Failure, Comment>> addComment({
    required String taskId,
    required String content,
  });

  Future<Either<Failure, Unit>> deleteComment({
    required String taskId,
    required String commentId,
  });

  Stream<List<ActivityEntry>> watchActivityForTask(String taskId);
}
