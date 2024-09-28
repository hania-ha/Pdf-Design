import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_editor/Controllers/BottomScreenController.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:provider/provider.dart';

Widget exitDialog(BuildContext context) {
  return AlertDialog(
    backgroundColor: Color(0xFF212326),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    content: Text(
      'Are you sure you want to exit?',
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    actions: [
      ElevatedButton(
        onPressed: () {
          SystemNavigator.pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2B2E32),

          //
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Exit',
          style: TextStyle(color: Colors.white),
        ),
      ),
      ElevatedButton(
        onPressed: () {
          context.pop();
        },
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2B2E32),

          //
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}

class BottomScreen extends StatelessWidget {
  const BottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        showDialog(
            context: context,
            builder: (context) {
              return exitDialog(context);
            });
      },
      child: Scaffold(
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
      ),
    );
  }
}
