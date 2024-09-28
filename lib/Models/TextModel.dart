import 'package:flutter/material.dart';

class TextModel {
  Offset textPosition;
  String text;
  String textFontFamily;
  double fontSize;
  Color textColor;

  TextModel(
      {required this.textPosition,
      required this.text,
      required this.textFontFamily,
      required this.fontSize,
      required this.textColor});
}
