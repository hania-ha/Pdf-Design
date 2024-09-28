import 'package:flutter/material.dart';

class SignatureModel {
  String signatureText;
  Offset signaturePosition;

  String signatureFontFamilty;
  Color signatureColor;
  double signatureFontSize;

  SignatureModel({
    required this.signatureText,
    required this.signaturePosition,
    required this.signatureFontFamilty,
    required this.signatureColor,
    required this.signatureFontSize,
  });
}
