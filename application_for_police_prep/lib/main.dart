import 'package:flutter/material.dart';
import 'package:application_for_police_prep/screens/splash_screen.dart';

void main() {
  runApp(const PolicePrepApp());
}

class PolicePrepApp extends StatelessWidget {
  const PolicePrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nepal Police Exam Prep',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}
