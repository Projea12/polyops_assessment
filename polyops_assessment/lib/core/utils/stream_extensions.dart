import 'dart:async';

extension StreamDebounceX<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    Timer? timer;
    late StreamController<T> controller;
    late StreamSubscription<T> sub;

    controller = StreamController<T>(
      onListen: () {
        sub = listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              if (!controller.isClosed) controller.add(data);
            });
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        sub.cancel();
      },
    );

    return controller.stream;
  }
}
