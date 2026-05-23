import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Penny Pulse',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // always use dark fintech theme
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
