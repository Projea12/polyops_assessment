import 'package:flutter_bloc/flutter_bloc.dart';

// ── Event ─────────────────────────────────────────────────────────────────────

sealed class NavigationEvent {
  const NavigationEvent();
}

final class NavigationDestinationSelected extends NavigationEvent {
  final int index;
  const NavigationDestinationSelected(this.index);
}

// ── State ─────────────────────────────────────────────────────────────────────

class NavigationState {
  final int index;
  const NavigationState(this.index);
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(0)) {
    on<NavigationDestinationSelected>(_onDestinationSelected);
  }

  void _onDestinationSelected(
    NavigationDestinationSelected event,
    Emitter<NavigationState> emit,
  ) =>
      emit(NavigationState(event.index));
}
