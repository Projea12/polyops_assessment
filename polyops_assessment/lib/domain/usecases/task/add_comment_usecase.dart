import 'package:fpdart/fpdart.dart' hide Task;
import 'package:injectable/injectable.dart';
import 'package:polyops_assessment/domain/failure/failures.dart';

import '../../entities/comment.dart';
import '../../repositories/i_task_repository.dart';

@lazySingleton
class AddCommentUseCase {
  final ITaskRepository _repository;

  const AddCommentUseCase(this._repository);

  Future<Either<Failure, Comment>> call({
    required String taskId,
    required String content,
  }) {
    if (content.trim().isEmpty) {
      return Future.value(left(const ValidationFailure('Comment cannot be empty')));
    }
    if (content.trim().length > 2000) {
      return Future.value(left(const ValidationFailure('Comment cannot exceed 2000 characters')));
    }
    return _repository.addComment(taskId: taskId, content: content.trim());
  }
}
