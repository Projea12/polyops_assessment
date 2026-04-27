import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

// Resolved at compile time via --dart-define=APP_ENV=prod.
// Defaults to 'dev' so flutter run always uses the mock datasource.
const _appEnv = String.fromEnvironment('APP_ENV', defaultValue: Environment.dev);

@InjectableInit()
Future<void> configureDependencies() async => getIt.init(environment: _appEnv);
