import 'package:flutter/material.dart';

class SaveScreen extends StatelessWidget {
  final Image editedImage;

  SaveScreen({required this.editedImage});

  @override
  Widget build(BuildContext context) {
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            height: 300, // Adjust this height as needed
            width: double.infinity,
            child: editedImage,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    // Save as PDF logic
                  },
                  leading: Icon(Icons.picture_as_pdf, color: Colors.white),
                  title: Text("Save as PDF", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  onTap: () {
                    // Save as PNG logic
                  },
                  leading: Icon(Icons.image, color: Colors.white),
                  title: Text("Save as PNG", style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  onTap: () {
                    // Share file logic
                  },
                  leading: Icon(Icons.share, color: Colors.white),
                  title: Text("Share File", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(43, 46, 50, 1),
        height: 80, // Increased height for the bottom bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomBarItem(
              icon: Icons.picture_as_pdf,
              text: "Save as PDF",
              onTap: () {
                // Save as PDF logic
              },
            ),
            BottomBarItem(
              icon: Icons.image,
              text: "Save as PNG",
              onTap: () {
                // Save as PNG logic
              },
            ),
            BottomBarItem(
              icon: Icons.share,
              text: "Share File",
              onTap: () {
                // Share file logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  BottomBarItem({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
