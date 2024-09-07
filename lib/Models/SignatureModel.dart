import 'package:flutter/material.dart';

class SignatureModel {
  String signatureText;
  Offset signaturePosition;
  double signatureWith;
  double signatureHeight;
  String signatureFontFamilty;
  Color signatureColor;
  double signatureFontSize;

  SignatureModel({
    required this.signatureText,
    required this.signaturePosition,
    required this.signatureWith,
    required this.signatureHeight,
    required this.signatureFontFamilty,
    required this.signatureColor,
    required this.signatureFontSize,
  });
}
