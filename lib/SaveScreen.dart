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
    // Get the screen size
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
            Navigator.pop(context); // Cancel action
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 24, // Increased font size
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
      body: Column(
        children: [
          // Image display section
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0), // Margins around the image
            height: screenHeight * 0.40, // Adjusted height for the image display
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Document info section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Document Name: ${imageFile.uri.pathSegments.last}",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "File Size: ${(imageFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(43, 46, 50, 1),
        height: 270, // Height of the bottom bar
        child: Column(
          children: [
            SizedBox(height: 18), // Adds space at the top of the bottom bar
            _buildBottomBarOption(
              icon: Icons.picture_as_pdf,
              label: "Save as PDF",
            ),
            _buildBottomBarOption(
              icon: Icons.image,
              label: "Save as PNG",
            ),
            _buildBottomBarOption(
              icon: Icons.share,
              label: "Share file",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarOption({required IconData icon, required String label}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7), // Reduced the vertical margin
      decoration: BoxDecoration(
        color: Color.fromRGBO(66, 69, 73, 1),
        borderRadius: BorderRadius.circular(8), // Smaller radius for rounded corners
      ),
      width: 300, // Width of each option
      height: 60, // Height of each option
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
          crossAxisAlignment: CrossAxisAlignment.center, // Center content vertically
          children: [
            Icon(icon, color: Colors.white, size: 28), // Adjust icon size as needed
            SizedBox(width: 12), // Space between the icon and the label
            Text(
              label,
              style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 18), // Increased font size
            ),
          ],
        ),
      ),
    );
  }
}
