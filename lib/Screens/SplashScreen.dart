import 'package:flutter/material.dart';
import 'package:pdf_editor/Screens/BottomScreen.dart';
import 'dart:async';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!)
          ..addListener(() {
            setState(() {});
          });

    _animationController!.forward();

    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const BottomScreen()));
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Background_image.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: AnimatedBuilder(
              animation: _fadeAnimation!,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation!.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/AppIcon.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
