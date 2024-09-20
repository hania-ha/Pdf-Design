import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class SaveScreenController {
  void saveImageFile(Uint8List data, String fileName) {
    DocumentFileSavePlus().saveFile(data, fileName, 'image/png');
    storeFileToPhoneDirectory(data, "$fileName.png");
  }

  void saveDocumentFile(Uint8List data, String fileName) async {
    Uint8List? pdfImage = await generatePdf(data);
    if (pdfImage != null) {
      DocumentFileSavePlus()
          .saveFile(pdfImage, "$fileName.pdf", 'appliation/pdf');
    }
    storeFileToPhoneDirectory(data, fileName);
  }

  void storeFileToPhoneDirectory(Uint8List data, String fileName) async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();

      final newDirectory = Directory('${appDir.path}/PDFFiles');

      if (!(await newDirectory.exists())) {
        await newDirectory.create();
      }
      final newFile = File("${newDirectory.path}/$fileName.pdf");
      await newFile.create(recursive: true);
      await newFile.writeAsBytes(data.buffer.asUint8List());
    } catch (e) {}
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
}
