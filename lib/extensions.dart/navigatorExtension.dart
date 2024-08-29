import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  void push(Widget page) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => page));
  }
}
