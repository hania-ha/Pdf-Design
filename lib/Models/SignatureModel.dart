import 'package:flutter/material.dart';

class SignatureModel {
  String signatureText;
  Offset signaturePosition;
  double signatureWith;
  double signatureHeight;

  SignatureModel({
    required this.signatureText,
    required this.signaturePosition,
    required this.signatureWith,
    required this.signatureHeight,
  });
}
