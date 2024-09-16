import 'package:flutter/material.dart';

class StampModel {
  Size stampSize;
  Offset stampPosition;
  String stampPath;

  StampModel(
      {required this.stampSize,
      required this.stampPosition,
      required this.stampPath});
}
