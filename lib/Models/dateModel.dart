import 'package:flutter/material.dart';

class DateModel {
  Widget dateWidget;
  double dateWidgetWidth;
  double dateWidgetHeight;
  Offset dateWidgetPosition;

  DateModel({
    required this.dateWidget,
    required this.dateWidgetHeight,
    required this.dateWidgetPosition,
    required this.dateWidgetWidth,
  });
}
