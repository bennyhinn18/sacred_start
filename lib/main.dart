import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SacredStartApp());
}

class SacredStartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sacred Start',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeScreen(),
    );
  }
}
