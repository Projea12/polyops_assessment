import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  ConnectivityService(this._connectivity);

  bool get isOnline => _isOnline;
  Stream<bool> get onlineStream => _controller.stream;

  @PostConstruct()
  void init() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final online = results.any((r) => r != ConnectivityResult.none);
        if (online != _isOnline) {
          _isOnline = online;
          _controller.add(online);
          debugPrint('[Connectivity] ${online ? 'Online' : 'Offline'}');
        }
      },
    );

    // Seed initial state
    _connectivity.checkConnectivity().then((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      _controller.add(_isOnline);
    });
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
