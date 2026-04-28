import 'package:fpdart/fpdart.dart' hide Task;
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/entities/board_task.dart';
import 'package:polyops_assessment/domain/entities/comment.dart';
import 'package:polyops_assessment/domain/entities/document_type.dart';
import 'package:polyops_assessment/domain/entities/sync_conflict.dart';
import 'package:polyops_assessment/domain/entities/task.dart';
import 'package:polyops_assessment/domain/entities/task_priority.dart';
import 'package:polyops_assessment/domain/entities/task_status.dart';
import 'package:polyops_assessment/domain/entities/verification_document.dart';
import 'package:polyops_assessment/domain/entities/verification_status.dart';
import 'package:polyops_assessment/domain/failures/failures.dart';
import 'package:polyops_assessment/domain/repositories/i_document_repository.dart';
import 'package:polyops_assessment/domain/repositories/i_task_repository.dart';
import 'package:polyops_assessment/domain/services/i_sync_service.dart';
import 'package:polyops_assessment/domain/usecases/document/pick_document_file_usecase.dart';
import 'package:polyops_assessment/domain/usecases/document/upload_document_usecase.dart';
import 'package:polyops_assessment/domain/usecases/document/watch_document_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/add_comment_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/delete_task_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/move_task_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/update_task_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/watch_board_tasks_usecase.dart';
import 'package:polyops_assessment/domain/usecases/task/watch_task_usecase.dart';

// ── Mocks ────────────────────────────────────────────────────────────────────

class MockITaskRepository extends Mock implements ITaskRepository {}
class MockIDocumentRepository extends Mock implements IDocumentRepository {}
class MockISyncService extends Mock implements ISyncService {}

class MockWatchTaskUseCase extends Mock implements WatchTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockAddCommentUseCase extends Mock implements AddCommentUseCase {}
class MockWatchBoardTasksByStatusUseCase extends Mock implements WatchBoardTasksByStatusUseCase {}
class MockMoveTaskUseCase extends Mock implements MoveTaskUseCase {}
class MockWatchDocumentUseCase extends Mock implements WatchDocumentUseCase {}
class MockUploadDocumentUseCase extends Mock implements UploadDocumentUseCase {}
class MockPickDocumentFileUseCase extends Mock implements PickDocumentFileUseCase {}

// ── Fixtures ─────────────────────────────────────────────────────────────────

final _now = DateTime(2025, 1, 1);

Task makeTask({
  String id = 'task-1',
  String title = 'Test Task',
  String description = 'Description',
  TaskStatus status = TaskStatus.todo,
  TaskPriority priority = TaskPriority.medium,
  DateTime? updatedAt,
  DateTime? dueDate,
  bool isPending = false,
  List<Comment> comments = const [],
}) =>
    Task(
      id: id,
      title: title,
      description: description,
      status: status,
      priority: priority,
      createdAt: _now,
      updatedAt: updatedAt ?? _now,
      dueDate: dueDate,
      isPending: isPending,
      comments: comments,
    );

BoardTask makeBoardTask({
  String id = 'task-1',
  String title = 'Test Task',
  TaskStatus status = TaskStatus.todo,
  int boardPosition = 0,
  DateTime? updatedAt,
}) =>
    BoardTask(
      id: id,
      title: title,
      description: 'Description',
      status: status,
      priority: TaskPriority.medium,
      boardPosition: boardPosition,
      updatedAt: updatedAt ?? _now,
    );

VerificationDocument makeDocument({
  String id = 'doc-1',
  VerificationStatus status = VerificationStatus.pending,
  double progress = 0.0,
  bool isOptimistic = false,
  int retryCount = 0,
}) =>
    VerificationDocument(
      id: id,
      type: DocumentType.passport,
      status: status,
      progress: progress,
      filePath: '/tmp/doc.pdf',
      originalName: 'doc.pdf',
      fileSize: 1024,
      uploadedAt: _now,
      isOptimistic: isOptimistic,
      retryCount: retryCount,
    );

SyncConflict makeSyncConflict({
  String taskId = 'task-1',
  String fieldName = 'title',
}) =>
    SyncConflict(
      taskId: taskId,
      taskTitle: 'Test Task',
      fieldName: fieldName,
      localValue: 'Local Title',
      serverValue: 'Server Title',
      localUpdatedAt: _now,
      serverUpdatedAt: _now.add(const Duration(minutes: 1)),
      serverActorName: 'Alice',
    );

Comment makeComment({String id = 'comment-1', String taskId = 'task-1'}) =>
    Comment(
      id: id,
      taskId: taskId,
      authorId: 'user-1',
      authorName: 'John',
      content: 'A comment',
      createdAt: _now,
    );

// ── Either helpers ────────────────────────────────────────────────────────────

Either<Failure, T> ok<T>(T value) => right(value);
Either<Failure, T> failWith<T>(String message) => left(NetworkFailure(message));
