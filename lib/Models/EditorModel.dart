import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Models/SignatureModel.dart';

class PdfEditorModel {
  SignatureModel? signatureModel;
  EditingTool editingTool;

  PdfEditorModel({
    this.signatureModel,
    required this.editingTool,
  });
}
