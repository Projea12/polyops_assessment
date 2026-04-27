abstract class TaskFormState {
  const TaskFormState();
}

final class TaskFormIdle extends TaskFormState {
  const TaskFormIdle();
}

final class TaskFormSubmitting extends TaskFormState {
  const TaskFormSubmitting();
}

final class TaskFormSuccess extends TaskFormState {
  const TaskFormSuccess();
}

final class TaskFormFailure extends TaskFormState {
  final String message;
  const TaskFormFailure(this.message);
}
