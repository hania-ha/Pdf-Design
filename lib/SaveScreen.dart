import 'package:flutter/material.dart';
import 'dart:io';

class SaveScreen extends StatelessWidget {
  final File imageFile;
  final String? editedSignature;
  final Offset signaturePosition;
  final Size signatureSize;

  SaveScreen({
    required this.imageFile,
    this.editedSignature,
    required this.signaturePosition,
    required this.signatureSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 35, 38, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: Text(
          "Choose Format",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 24,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the Home screen
            },
            child: Text(
              "Home",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Display the image
          Positioned.fill(
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
          // Display the signature if available
          if (editedSignature != null)
            Positioned(
              left: signaturePosition.dx,
              top: signaturePosition.dy,
              child: SizedBox(
                width: signatureSize.width,
                height: signatureSize.height,
                child: Image.asset(
                  editedSignature!, // Path to the signature asset
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(43, 46, 50, 1),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Ensures it takes only the necessary height
          children: [
            _buildBottomBarOption(
              iconPath: 'assets/pdf_icon.png', // Replace with your asset path
              label: "Save as PDF",
            ),
            _buildBottomBarOption(
              iconPath: 'assets/png_icon.png', // Replace with your asset path
              label: "Save as PNG",
            ),
            _buildBottomBarOption(
              iconPath: 'assets/share_icon.png', // Replace with your asset path
              label: "Share file",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarOption({required String iconPath, required String label}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(66, 69, 73, 1),
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 28,
            height: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
