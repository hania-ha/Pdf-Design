import 'package:flutter/material.dart';
import 'Screen1.dart';  
import 'Screen2.dart';
import 'SignatureScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screen1(),  
    );
  }
}
