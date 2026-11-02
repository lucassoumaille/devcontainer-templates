import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'features/home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const _seedColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: !AppConfig.isProduction,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
