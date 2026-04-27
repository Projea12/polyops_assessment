import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/failures/failures.dart';
import 'package:polyops_assessment/domain/usecases/task/add_comment_usecase.dart';

import '../../helpers/test_helpers.dart';

void main() {
  late MockITaskRepository repository;
  late AddCommentUseCase useCase;

  setUp(() {
    repository = MockITaskRepository();
    useCase = AddCommentUseCase(repository);
  });

  test('returns ValidationFailure when content is blank', () async {
    final result = await useCase(taskId: 'task-1', content: '   ');
    expect(result.isLeft(), isTrue);
    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('Expected failure'),
    );
    verifyNever(() => repository.addComment(taskId: any(named: 'taskId'), content: any(named: 'content')));
  });

  test('returns ValidationFailure when content exceeds 2000 characters', () async {
    final longContent = 'a' * 2001;
    final result = await useCase(taskId: 'task-1', content: longContent);
    expect(result.isLeft(), isTrue);
    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('Expected failure'),
    );
    verifyNever(() => repository.addComment(taskId: any(named: 'taskId'), content: any(named: 'content')));
  });

  test('trims whitespace before delegating to repository', () async {
    final comment = makeComment();
    when(() => repository.addComment(taskId: any(named: 'taskId'), content: any(named: 'content')))
        .thenAnswer((_) async => ok(comment));

    await useCase(taskId: 'task-1', content: '  hello  ');

    verify(() => repository.addComment(taskId: 'task-1', content: 'hello')).called(1);
  });

  test('delegates to repository for valid content', () async {
    final comment = makeComment();
    when(() => repository.addComment(taskId: any(named: 'taskId'), content: any(named: 'content')))
        .thenAnswer((_) async => ok(comment));

    final result = await useCase(taskId: 'task-1', content: 'Valid comment');
    expect(result.isRight(), isTrue);
  });
}
