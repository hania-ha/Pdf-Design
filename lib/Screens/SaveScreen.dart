import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

class SaveScreen extends StatelessWidget {
  SaveScreen({super.key, required this.imageBytes});
  Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 35, 38, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: Text(
          "Choose Format",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 24,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Home",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.red,
                child: AspectRatio(
                    aspectRatio: 1 / 2,
                    child: Container(
                      color: Colors.amber,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenSize * .22,
                            height: (screenSize * .60) / 2,
                            color: Colors.red,

                            // margin: EdgeInsets.all(100),
                          ),
                          Text("Assignment.pdf"),
                          Text("File size: 238KB"),
                        ],
                      ),
                    )),
              )),
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.green,
              ))
        ],
      ),
      // bottomNavigationBar: Container(
      //   color: Color.fromRGBO(43, 46, 50, 1),
      //   padding: EdgeInsets.symmetric(vertical: 16.0),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       _buildBottomBarOption(
      //         iconPath: 'assets/pdficon.png',
      //         label: "Save as PDF",
      //       ),
      //       _buildBottomBarOption(
      //         iconPath: 'assets/save.png',
      //         label: "Save as PNG",
      //       ),
      //       _buildBottomBarOption(
      //         iconPath: 'assets/shareicon.png',
      //         label: "Share file",
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildBottomBarOption(
      {required String iconPath, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
