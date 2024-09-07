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
import 'package:pdf_editor/Models/SignatureModel.dart';
import 'package:pdf_editor/Models/StampModel.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui';

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
  int selectedItemIndex = -1;
  int currentlySelectedFontFamilyIndex = 0;
  GlobalKey imageWidgetKey = GlobalKey();

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
  void calculateWidgetSize() {
    print("calculateWidgetSize");
    RenderBox? renderBox =
        imageWidgetKey.currentContext?.findRenderObject() as RenderBox;

    var offset = renderBox.localToGlobal(Offset.zero);
    var size = renderBox.size;
    print("Widget Size:: ${size}");
  }

  void toggleItemSelection(int index, {EditingTool? editingTool}) {
    selectedItemIndex = index;
    notifyListeners();
  }

  String? getCurrentlySelectedSign() {
    String? sign;
    if (currentEditingTool == EditingTool.SIGN) {
      sign = pdfEditorItems[selectedItemIndex].signatureModel?.signatureText;
    }

    return sign;
  }

  void toggleSignatureFontFamily(String fontFamily, int index) {
    print(selectedItemIndex);
    print(fontFamily);

    pdfEditorItems[selectedItemIndex].signatureModel?.signatureFontFamilty =
        fontFamily;
    currentlySelectedFontFamilyIndex = index;
    notifyListeners();
  }

  String getFontFamily(int i) {
    return pdfEditorItems[i].signatureModel!.signatureFontFamilty;
  }

  Color getSignatureColor(int i) {
    return pdfEditorItems[i].signatureModel!.signatureColor;
  }

  double getFontSize(int i) {
    return pdfEditorItems[i].signatureModel!.signatureFontSize;
  }

  EditingTool getItemEditingType(int i) {
    return pdfEditorItems[i].editingTool;
  }

  bool checkIfSignatureExist() {
    for (int i = 0; i < pdfEditorItems.length; i++) {
      if (pdfEditorItems[i].editingTool == EditingTool.SIGN) {
        return true;
      }
    }
    return false;
  }

  void onPositionChange(int index, double xPosition, double yPosition, int i) {
    // signaturePosition = ;

    if (currentEditingTool == EditingTool.SIGN) {
      try {
        pdfEditorItems[index].signatureModel?.signaturePosition = Offset(
          (pdfEditorItems[index].signatureModel?.signaturePosition.dx ?? 0) +
              xPosition,
          (pdfEditorItems[index].signatureModel?.signaturePosition.dy ?? 0) +
              yPosition,
        );
      } catch (e) {}

      print(pdfEditorItems[index].signatureModel?.signaturePosition);
    }
    if (currentEditingTool == EditingTool.STAMP) {
      pdfEditorItems[index].stampModel?.stampPosition = Offset(
        (pdfEditorItems[index].stampModel?.stampPosition.dx ?? 0) + xPosition,
        (pdfEditorItems[index].stampModel?.stampPosition.dy ?? 0) + yPosition,
      );
    }

    notifyListeners();
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
    // selectedSignature = signature;
    pdfEditorItems.add(PdfEditorModel(
      signatureModel: SignatureModel(
        signatureText: signature.toString(),
        signaturePosition: Offset(0, 0),
        signatureWith: 70,
        signatureHeight: 30,
        signatureFontFamilty: signatureFontFamilies[0],
        signatureColor: Colors.black,
        signatureFontSize: 18,
      ),
      editingTool: EditingTool.SIGN,
    ));

    print(pdfEditorItems);

    notifyListeners();
  }

  void addStamp(String stampSrc) {
    try {
      pdfEditorItems.add(PdfEditorModel(
          editingTool: EditingTool.STAMP,
          stampModel: StampModel(
            stampHeight: 70,
            stampWidth: 50,
            stampPosition: Offset(0, 0),
            stampPath: stampSrc,
          )));
    } catch (e) {
    } finally {}

    notifyListeners();
  }

  void resetValues() {
    isStampMode = false;
    isSignMode = false;
    isPaintingMode = false;
    isBottomBarVisible = true;
    pdfEditorItems.clear();
    currentEditingTool == EditingTool.NONE;
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

  List<String> signatureFontFamilies = [
    'DancingMedium',
    'GreatVibesRegular',
    'RougeScriptRegular',
    'BilboRegular'
  ];
}
