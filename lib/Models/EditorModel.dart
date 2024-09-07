import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Models/SignatureModel.dart';
import 'package:pdf_editor/Models/StampModel.dart';

class PdfEditorModel {
  SignatureModel? signatureModel;
  StampModel? stampModel;
  EditingTool editingTool;

  PdfEditorModel({
    this.signatureModel,
    this.stampModel,
    required this.editingTool,
  });
}
