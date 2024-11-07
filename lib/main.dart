import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/input_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teoría de Colas',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/input': (context) => InputScreen(),
        '/results': (context) => ResultScreen(),
      },
    );
  }
}
