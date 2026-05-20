import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/data_repository.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const TransportApp());
}

/// Root widget of the application.
///
/// Provides a single [DataRepository] above the widget tree. Today that
/// repository returns dummy data — when the backend exists, swap the
/// repository's method bodies (in `lib/data/data_repository.dart`) and
/// nothing else needs to change.
class TransportApp extends StatelessWidget {
  const TransportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataRepository(),
      child: MaterialApp(
        title: 'Transport Schedule',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeShell(),
      ),
    );
  }
}
