import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_editor/Models/EditorModel.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

enum EditingTool {
  PAINT,
  SIGN,
  STAMP,
  TEXT,
  DATE,
  NONE,
}

class Pdfeditorcontroller with ChangeNotifier {
  EditingTool currentEditingTool = EditingTool.NONE;
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? _imageFile;

  bool isPaintingMode = false;
  bool isStampMode = false;
  bool isSignMode = false;
  bool isBottomBarVisible = true;
  Color selectedColor = Colors.black;
  double brushSize = 5.0;
  int? selectedStickerIndex;
  String? selectedSignature = "Roboto";

  // String? selectedSignature;
  List<PdfEditorModel> _pdfEditorItems = [];

  List<PdfEditorModel> get pdfEditorItems => _pdfEditorItems;

  set pdfEditorItems(List<PdfEditorModel> value) {
    pdfEditorItems = value;
    notifyListeners();
  }

  Offset signaturePosition = Offset(20, 20);
  Size signatureSize = Size(100, 40);

  List<Offset?> points = []; // List to store drawing points\

  void onSignaturePositionChange(
      int index, double xPosition, double yPosition) {
    // signaturePosition = ;

    pdfEditorItems[index].signatureModel?.signaturePosition = Offset(
      signaturePosition.dx + xPosition,
      signaturePosition.dy + yPosition,
    );
  }

  void toggleEditingTool(EditingTool editingTool) {
    currentEditingTool = editingTool;
    notifyListeners();
  }

  void toggleColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void onColorPallateSliderChanged(double value) {
    brushSize = value;
    notifyListeners();
  }

  void togglePaintingMode() {
    resetValues();
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

  void toggleStampMode() {
    isStampMode = !isStampMode;
    isSignMode = false;
    notifyListeners();
  }

  void toggleSignMode() {
    resetValues();
    isSignMode = !isSignMode;
  }

  void handleSignatureSelection(String signature) {
    selectedSignature = signature;
    notifyListeners();
  }

  void resetValues() {
    isStampMode = false;
    isSignMode = false;
    isPaintingMode = false;
    isBottomBarVisible = true;
    notifyListeners();
  }

  // Future<String> loadAsset() async {
  //   return await rootBundle.loadString('assets/stampsImages.json');
  // }

  void exportImage() async {
    final pdf = pw.Document();
    Uint8List? exportedImageBytes = await screenshotController.capture();
    if (exportedImageBytes != null) {
      Uint8List? pdfImage = await generatePdf(exportedImageBytes);
      if (pdfImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String filePath =
            "${tempDir.path}/${DateTime.now().microsecondsSinceEpoch.toString()}.pdf";
        File(filePath).createSync();

        File(filePath).writeAsBytes(pdfImage.buffer.asUint8List());
        print(filePath);
        print(Directory(filePath));
        if (kDebugMode) {
          // final result = await ImageGallerySaver.saveImage(
          //     exportedImageBytes.buffer.asUint8List());
          OpenFile.open(filePath);
        }
      }
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
        clip: true,
        margin: pw.EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.fill, // Fill the entire page with the image
              alignment: pw.Alignment.center, // Align the image to center
            ),
          );
        },
      ),
    ); // Page

    return await pdf.save();
  }
}
