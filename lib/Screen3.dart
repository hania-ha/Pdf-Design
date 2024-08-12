import 'package:flutter/material.dart';
import 'dart:io';

class Screen3 extends StatelessWidget {
  final File imageFile;

  Screen3({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    // Debugging: Print the image file path to check if it's correct
    print("Image file path: ${imageFile.path}");

    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1), 
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1, 
                child: Container(
                  decoration: BoxDecoration(
                    image: imageFile.existsSync() 
                      ? DecorationImage(
                          image: FileImage(imageFile),
                          fit: BoxFit.cover,
                        )
                      : null,
                    color: imageFile.existsSync() ? null : Colors.red, // Show red background if file doesn't exist
                  ),
                  child: !imageFile.existsSync() 
                    ? Center(
                        child: Text(
                          'Image not found!',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(Icons.edit, "Edit"),
                _buildIconButton(Icons.draw, "Sign"),
                _buildIconButton(Icons.format_paint_sharp, "Stamp"),
                _buildIconButton(Icons.text_fields, "Text"),
                _buildIconButton(Icons.calendar_today, "Calendar"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: () {
            // Handle icon tap
          },
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
