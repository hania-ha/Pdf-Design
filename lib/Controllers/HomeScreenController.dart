import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_editor/Screens/PdfEditorScreen.dart';
import 'package:pdf_editor/Screens/SaveScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:pdf/widgets.dart' as pw;

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
          if (pdfTool != PdfTool.ImageToPDF) {
            context.push(
              PdfEditorScreen(
                imageFile: file!,
                pdfTool: pdfTool,
              ),
            );
          } else {
            // context.pop();
            try {
              if (file != null) {
                context.push(SaveScreen(
                  imageBytes: file!.readAsBytesSync(),
                  fileName:
                      DateTime.now().millisecondsSinceEpoch.toStringAsFixed(0),
                  fileSize: (file!.readAsBytesSync().lengthInBytes / 1000)
                      .toStringAsFixed(2),
                ));
              }
            } catch (e) {}
          }
        }
      }
    } catch (e) {
      isImagePicking = false;
    } finally {
      isImagePicking = false;
    }
  }

  Future<Uint8List> generatePdf(Uint8List exportedImageBytes) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(exportedImageBytes);
    pdf.addPage(
      pw.Page(
        pageFormat:
            PdfPageFormat.a4.applyMargin(left: 0, top: 0, right: 0, bottom: 0),
        orientation: pw.PageOrientation.portrait,
        clip: false,
        margin: pw.EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.cover, // Fill the entire page with the image
              alignment: pw.Alignment.center, // Align the image to center
            ),
          );
        },
      ),
    ); // Page

    return await pdf.save();
  }

  late Future<List<FileSystemEntity>> files;

  void getFilesInDirectory() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    Directory pdfDir = Directory("${appDir.path}/PDFFiles");

    files = pdfDir.listSync() as Future<
        List<
            FileSystemEntity>>; // Returns a list of FileSystemEntity (files & directories)
  }
}
