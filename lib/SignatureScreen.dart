import 'package:flutter/material.dart';
import 'dart:io';
import 'SaveScreen.dart';

class SignatureScreen extends StatefulWidget {
  final File imageFile;

  SignatureScreen({required this.imageFile});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  String? selectedSignature;
  Offset signaturePosition = Offset(20, 20); // Initial position
  Size signatureSize = Size(100, 40); // Initial size

  void _handleSignatureSelection(String signature) {
    setState(() {
      selectedSignature = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> fontFamilies = [
      'Roboto',
      'Arial',
      'Courier',
      'Georgia',
      'Times New Roman',
      'Verdana',
      'Helvetica',
      'Comic Sans MS',
      'Trebuchet MS',
      'Tahoma',
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 35, 38, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: Text(
          "Add signature",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SaveScreen(
                    imageFile: widget.imageFile,
                    editedSignature: selectedSignature,
                    signaturePosition: signaturePosition,
                    signatureSize: signatureSize,
                  ),
                ),
              );
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
            ),
          ),
          if (selectedSignature != null)
            Positioned(
              left: signaturePosition.dx,
              top: signaturePosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    signaturePosition = Offset(
                      signaturePosition.dx + details.delta.dx,
                      signaturePosition.dy + details.delta.dy,
                    );
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      width: signatureSize.width,
                      height: signatureSize.height,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(47, 168, 255, 1), // Blue border
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Sign",
                          style: TextStyle(
                            fontFamily: selectedSignature,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    // Resize handles
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            signatureSize = Size(
                              (signatureSize.width + details.delta.dx)
                                  .clamp(50.0, double.infinity),
                              (signatureSize.height + details.delta.dy)
                                  .clamp(50.0, double.infinity),
                            );
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(47, 168, 255, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -10,
                      top: -10,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            signatureSize = Size(
                              (signatureSize.width - details.delta.dx)
                                  .clamp(50.0, double.infinity),
                              (signatureSize.height - details.delta.dy)
                                  .clamp(50.0, double.infinity),
                            );
                            signaturePosition = Offset(
                              signaturePosition.dx + details.delta.dx,
                              signaturePosition.dy + details.delta.dy,
                            );
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(47, 168, 255, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      top: -10,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            signatureSize = Size(
                              (signatureSize.width + details.delta.dx)
                                  .clamp(50.0, double.infinity),
                              (signatureSize.height - details.delta.dy)
                                  .clamp(50.0, double.infinity),
                            );
                            signaturePosition = Offset(
                              signaturePosition.dx,
                              signaturePosition.dy + details.delta.dy,
                            );
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(47, 168, 255, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -10,
                      bottom: -10,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            signatureSize = Size(
                              (signatureSize.width - details.delta.dx)
                                  .clamp(50.0, double.infinity),
                              (signatureSize.height + details.delta.dy)
                                  .clamp(50.0, double.infinity),
                            );
                            signaturePosition = Offset(
                              signaturePosition.dx + details.delta.dx,
                              signaturePosition.dy,
                            );
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(47, 168, 255, 1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromRGBO(43, 46, 50, 1), // Match bottom bar color
        height: 60, // Reduced height for bottom bar
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fontFamilies.length + 1, // Add one for the plus icon
          itemBuilder: (context, index) {
            if (index == 0) {
              // Plus icon
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: 40, // Width for plus icon
                height: 40, // Height for plus icon
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2), // Red outline
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.red, size: 24),
                ),
              );
            }

            String fontFamily = fontFamilies[index - 1];
            return GestureDetector(
              onTap: () => _handleSignatureSelection(fontFamily),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: 70, // Reduced width for signature options
                height: 30, // Reduced height for signature options
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for each signature option
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    "Sign",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Colors.black,
                      fontSize: 14, // Adjust font size if needed
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}