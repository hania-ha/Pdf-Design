import 'package:flutter/material.dart';

class StampModel {
  double stampWidth;
  double stampHeight;
  Offset stampPosition;
  String stampPath;

  StampModel(
      {required this.stampHeight,
      required this.stampWidth,
      required this.stampPosition,
      required this.stampPath});
}
