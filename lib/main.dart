import 'package:flutter/material.dart';
import 'Screen1.dart';  
import 'Screen2.dart';
import 'SignatureScreen.dart';
import 'SplashScreen.dart';
import 'package:device_preview/device_preview.dart';
import 'PremiumScreen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,  
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      home: SplashScreen(),
      builder: DevicePreview.appBuilder,  
      locale: DevicePreview.locale(context),
    );
  }
}
