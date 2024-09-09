import 'package:flutter/material.dart';

class TextModel {
  double textWidth;
  double textHeight;
  Offset textPosition;
  String text;
  String textFontFamily;
  double fontSize;
  Color textColor;

  TextModel({
    required this.textWidth,
    required this.textHeight,
    required this.textPosition,
    required this.text,
    required this.textFontFamily,
    required this.fontSize,
    required this.textColor
  });
}
