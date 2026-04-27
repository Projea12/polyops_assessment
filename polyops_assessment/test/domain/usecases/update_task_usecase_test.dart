import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polyops_assessment/domain/failures/failures.dart';
import 'package:polyops_assessment/domain/usecases/task/update_task_usecase.dart';

import '../../helpers/test_helpers.dart';

void main() {
  late MockITaskRepository repository;
  late UpdateTaskUseCase useCase;

  setUp(() {
    repository = MockITaskRepository();
    useCase = UpdateTaskUseCase(repository);
  });

  setUpAll(() {
    registerFallbackValue(makeTask());
  });

  test('returns ValidationFailure when title is empty', () async {
    final task = makeTask(title: '   ');
    final result = await useCase(task);
    expect(result.isLeft(), isTrue);
    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('Expected left but got right'),
    );
    verifyNever(() => repository.updateTask(any()));
  });

  test('delegates to repository when title is valid', () async {
    final task = makeTask(title: 'Valid Title');
    when(() => repository.updateTask(any())).thenAnswer((_) async => ok(task));

    final result = await useCase(task);

    expect(result.isRight(), isTrue);
    verify(() => repository.updateTask(task)).called(1);
  });

  test('returns repository failure on network error', () async {
    final task = makeTask(title: 'Valid Title');
    when(() => repository.updateTask(any()))
        .thenAnswer((_) async => failWith('Network error'));

    final result = await useCase(task);
    expect(result.isLeft(), isTrue);
  });
}
