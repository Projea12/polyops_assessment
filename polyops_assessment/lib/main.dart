import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:polyops_assessment/core/di/injection.dart';
import 'package:polyops_assessment/core/observer/app_bloc_observer.dart';
import 'package:polyops_assessment/presentation/task/board_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(const Polysops());
}

class Polysops extends StatelessWidget {
  const Polysops({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polyops',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E37),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BoardScreen(),
    );
  }
}

