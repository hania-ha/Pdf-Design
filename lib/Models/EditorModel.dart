import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Models/SignatureModel.dart';
import 'package:pdf_editor/Models/StampModel.dart';
import 'package:pdf_editor/Models/TextModel.dart';
import 'package:pdf_editor/Models/dateModel.dart';

class PdfEditorModel {
  SignatureModel? signatureModel;
  StampModel? stampModel;
  DateModel? dateModel;
  EditingTool editingTool;
  TextModel? textModel;
  Offset pdfItemPosition;
  Size itemSize;

  PdfEditorModel({
    this.signatureModel,
    this.stampModel,
    this.dateModel,
    this.textModel,
    required this.editingTool,
    required this.pdfItemPosition,
    required this.itemSize,
  });
}
