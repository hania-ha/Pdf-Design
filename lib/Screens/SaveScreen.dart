import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Controllers/SaveScreenConroller.dart';
import 'package:pdf_editor/Screens/HomeScreen.dart';
import 'dart:io';

import 'package:pdf_editor/utils/AppColors.dart';
import 'package:provider/provider.dart';

class SaveScreen extends StatelessWidget {
  SaveScreen(
      {super.key,
      required this.imageBytes,
      required this.fileName,
      required this.fileSize});
  Uint8List imageBytes;
  String fileName;
  String fileSize;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 35, 38, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: const Text(
          "Choose Format",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Color.fromRGBO(47, 168, 255, 1),
              // fontSize: 24,
              fontFamily: 'Inter',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DiscardChangesDialog();
                },
              );
            },
            child: const Text(
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
                      color: AppColors.primarybgColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenSize * .22,
                            height: (screenSize * .60) / 2,
                            color: Colors.transparent,
                            child: Image.memory(imageBytes),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$fileName.pdf",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'intern'),
                          ),
                          Text(
                            "File size: $fileSize KB",
                            style: const TextStyle(color: Color(0xFF7C7E84)),
                          ),
                        ],
                      ),
                    )),
              )),
          Expanded(
            flex: 3,
            child: Container(
              color: AppColors.secondaryBgColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  SaveDocumentWidget(
                    size: size,
                    label: 'Save as PDF',
                    logoPath: 'assets/pdficon1.png',
                    onPressed: () {
                      SaveScreenController()
                          .saveDocumentFile(imageBytes, fileName, context);
                    },
                  ),
                  SaveDocumentWidget(
                    size: size,
                    label: 'Save as PNG',
                    logoPath: 'assets/pngsaveicon.png',
                    onPressed: () {
                      SaveScreenController()
                          .saveImageFile(imageBytes, fileName, context);
                    },
                  ),
                  SaveDocumentWidget(
                    size: size,
                    label: 'Share File',
                    logoPath: 'assets/shareicon1.png',
                    onPressed: () {
                      SaveScreenController().shareFile(imageBytes, fileName);
                    },
                  )
                ],
              ),
            ),
          )
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

class SaveDocumentWidget extends StatelessWidget {
  SaveDocumentWidget(
      {super.key,
      required this.size,
      required this.label,
      required this.logoPath,
      required this.onPressed});

  final Size size;
  String label;
  String logoPath;
  Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 66,
        width: size.width * .90,
        decoration: BoxDecoration(
          color: Color(0xFF424549),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(margin: EdgeInsets.all(12), child: Image.asset(logoPath)),
            Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'intern',
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscardChangesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context, listen: false);
    return AlertDialog(
      backgroundColor: Color(0xFF212326),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        'All the changes will be discarded.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel action
          },
          child: Text('Cancel'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF2B2E32),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ok action
            pdfeditorcontroller.resetValues();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2B2E32),

            //
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
