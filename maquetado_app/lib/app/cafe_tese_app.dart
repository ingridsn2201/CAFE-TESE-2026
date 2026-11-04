import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'routes.dart';

class CafeTeseApp extends StatefulWidget {
  const CafeTeseApp({super.key});

  @override
  State<CafeTeseApp> createState() => _CafeTeseAppState();
}

class _CafeTeseAppState extends State<CafeTeseApp> {
  final AppState appState = AppState.demo();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: appState,
      child: MaterialApp(
        title: 'Cafe TESE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: AppRoutes.bienvenida,
        routes: AppRoutes.buildRoutes(),
      ),
    );
  }
}
