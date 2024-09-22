import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_editor/Screens/HomeScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:share_plus/share_plus.dart';

class SaveScreenController {
  void saveImageFile(Uint8List data, String fileName, BuildContext context) {
    DocumentFileSavePlus().saveFile(data, fileName, 'image/png');
    storeFileToPhoneDirectory(data, "$fileName.png", context);
  }

  void saveDocumentFile(
      Uint8List data, String fileName, BuildContext context) async {
    showDialog(
      context: context,
      builder: (contex) {
        return const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 10,
        );
      },
    );
    Uint8List? pdfImage = await generatePdf(data);
    context.pop();
    if (pdfImage != null) {
      DocumentFileSavePlus()
          .saveFile(pdfImage, "$fileName.pdf", 'appliation/pdf');
    }
    storeFileToPhoneDirectory(pdfImage, "$fileName.pdf", context);
  }

  void storeFileToPhoneDirectory(
      Uint8List data, String fileName, BuildContext context) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();

      final newDirectory = Directory('${appDir.path}/PDFFiles');

      if (!(await newDirectory.exists())) {
        await newDirectory.create();
      }
      final newFile = File("${newDirectory.path}/$fileName");
      await newFile.create();
      await newFile.writeAsBytes(data.buffer.asUint8List());
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return saveDialog(context);
            });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickIosDirectory(Uint8List data, String fileName) async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      print("Picking directory not supported");
      return;
    }
    final pickedDirectory = await FlutterFileDialog.pickDirectory();
    if (pickedDirectory != null) {
      try {
        final filePath = await FlutterFileDialog.saveFileToDirectory(
          directory: pickedDirectory,
          data: data,
          mimeType: "appliation/pdf",
          fileName: "fileName",
          replace: true,
        );

        print("File Path:: $filePath");
      } catch (e) {}
    }
  }

  Future<void> shareFile(Uint8List data, String fileName) async {
    try {
      Uint8List? pdfImage = await generatePdf(data);
      // Get the temporary directory of the device.
      final directory = await getTemporaryDirectory();

      // Create a temporary file.
      final file = File('${directory.path}/$fileName.pdf');

      // Write the data to the file.
      await file.writeAsBytes(pdfImage);

      // Share the file.
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      // Handle any exceptions here.
      print('Error sharing file: $e');
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

  Widget saveDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF212326),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        'File Has Been Saved To Downloads',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Close',
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
