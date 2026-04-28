import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:polyops_assessment/presentation/task/board_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/di/injection.dart';
import 'core/observer/app_bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'presentation/documents/dashboard/document_dashboard_screen.dart';
import 'presentation/sync/bloc/sync_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  runApp(const Polysops());
}

class Polysops extends StatelessWidget {
  const Polysops({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncBloc>(
      create: (_) => getIt<SyncBloc>()..add(const SyncTriggered()),
      child: MaterialApp(
        title: 'Polysops',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
        ],
        theme: AppTheme.light,
        home: const _AppShell(),
      ),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> with WidgetsBindingObserver {
  int _index = 0;

  static const _screens = [
    BoardScreen(),
    DocumentDashboardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SyncBloc>().add(const SyncTriggered());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BlocBuilder<SyncBloc, SyncState>(
        buildWhen: (prev, curr) =>
            prev.conflicts.length != curr.conflicts.length,
        builder: (context, syncState) {
          final conflictCount = syncState.conflicts.length;
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: conflictCount > 0,
                  label: Text('$conflictCount'),
                  child: const Icon(Icons.dashboard_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: conflictCount > 0,
                  label: Text('$conflictCount'),
                  child: const Icon(Icons.dashboard_rounded),
                ),
                label: 'Board',
              ),
              const NavigationDestination(
                icon: Icon(Icons.shield_outlined),
                selectedIcon: Icon(Icons.shield_rounded),
                label: 'KYC Docs',
              ),
            ],
          );
        },
      ),
    );
  }
}
