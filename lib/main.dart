import 'package:covid19_tracker/loading_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(CovidApp());

class CovidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black54,
        appBarTheme: AppBarTheme(color: Colors.black12),
      ),
      home: LoadingScreen(),
    );
  }
}
