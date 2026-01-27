import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LoksewaQuizApp());
}

class LoksewaQuizApp extends StatelessWidget {
  const LoksewaQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loksewa Tayari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}