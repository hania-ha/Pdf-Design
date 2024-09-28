import 'package:flutter/material.dart';

class DateModel {
  Widget dateWidget;
  Size dataSize;
  Offset dateWidgetPosition;
  Color dateColor;
  DateTime date;
  String dateFormat;

  DateModel({
    required this.dateWidget,
    required this.dateWidgetPosition,
    required this.dataSize,
    required this.dateColor,
    required this.date,
    required this.dateFormat,
  });
}
