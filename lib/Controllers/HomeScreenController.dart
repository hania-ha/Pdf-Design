import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_editor/Screens/PdfEditorScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/utils/enums.dart';

class HomeScreenController with ChangeNotifier {
  File? _file;

  File? get file => _file;

  set file(File? value) {
    _file = value;
    notifyListeners();
  }

  bool isImagePicking = false;
  // PdfTool pdfTool = PdfTool.General;

  void pickImage(BuildContext context, PdfTool pdfTool) async {
    try {
      if (isImagePicking) return; //To Prevent Spamming
      isImagePicking = true;
      XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xfile != null) {
        isImagePicking = false;
        file = File(xfile.path);
        if (context.mounted) {
          context.push(PdfEditorScreen(
            imageFile: file!,
            pdfTool: pdfTool,
          ));
        }
      }
    } catch (e) {
      isImagePicking = false;
    } finally {
      isImagePicking = false;
    }
  }

  void navigateToEditor() {}
}
