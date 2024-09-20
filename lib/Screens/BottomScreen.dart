import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_editor/Controllers/BottomScreenController.dart';
import 'package:provider/provider.dart';

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer(
          builder: (context, BottomScreenController controller, child) {
        return BottomNavigationBar(
          backgroundColor: Color.fromRGBO(43, 46, 50, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          currentIndex: controller.selectedScreenIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) => controller.onBottomBarItemChanged(index),
        );
      }),
      body: Consumer(
          builder: (context, BottomScreenController controller, child) {
        return controller.getView();
      }),
    );
  }
}
