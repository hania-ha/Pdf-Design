import 'package:flutter/material.dart';

class Pdfeditorcontroller with ChangeNotifier {
  bool isPaintingMode = false;
  Color selectedColor = Colors.black;
  double brushSize = 5.0;
  List<Offset?> points = []; // List to store drawing points\

  void toggleColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void onColorPallateSliderChanged(double value) {
    brushSize = value;
    notifyListeners();
  }

  void togglePaintingMode() {
    isPaintingMode = !isPaintingMode;
    notifyListeners();
  }

  void startDrawing(Offset point) {
    points.add(point);
    notifyListeners();
  }

  void updateDrawing(Offset point) {
    points.add(point);

    notifyListeners();
  }

  void endDrawing() {
    points.add(null); // Add a null point to signify the end of a stroke
    notifyListeners();
  }
}
