import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:pdf_editor/Screens/HistoryView.dart';
import 'package:pdf_editor/Screens/HomeScreen.dart';

class BottomScreenController with ChangeNotifier {
  int selectedScreenIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    HistoryView(),
    Container(),
  ];
  void onBottomBarItemChanged(int index) {
    selectedScreenIndex = index;
    notifyListeners();
  }

  Widget getView() {
    
    return screens[selectedScreenIndex];
  }
}
