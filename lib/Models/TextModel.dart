import 'package:flutter/material.dart';

class TextModel {
  Size textSize;
  Offset textPosition;
  String text;
  String textFontFamily;
  double fontSize;
  Color textColor;

  TextModel(
      {required this.textSize,
      required this.textPosition,
      required this.text,
      required this.textFontFamily,
      required this.fontSize,
      required this.textColor});
}
