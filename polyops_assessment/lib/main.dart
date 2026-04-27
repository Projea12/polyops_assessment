import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:polyops_assessment/presentation/task/board_screen.dart';

import 'core/di/injection.dart';
import 'core/observer/app_bloc_observer.dart';
import 'presentation/documents/dashboard/document_dashboard_screen.dart';


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
      title: 'Polysops',
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
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  int _index = 0;

  static const _screens = [
    BoardScreen(),
    DocumentDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCFCE7),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded,
                color: Color(0xFF1B5E37)),
            label: 'Board',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield_rounded,
                color: Color(0xFF1B5E37)),
            label: 'KYC Docs',
          ),
        ],
      ),
    );
  }
}
