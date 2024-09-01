import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'SignatureScreen.dart';

class PdfEditorScreen extends StatefulWidget {
  final File imageFile;
  final PdfTool pdfTool;

  PdfEditorScreen({required this.imageFile, required this.pdfTool});

  @override
  _PdfEditorScreenState createState() => _PdfEditorScreenState();
}

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = [];

  String _selectedSignature = '';

  // void _toggleSignMode() {
  //   setState(() {
  //     _isSignMode = !_isSignMode;
  //     // _isPaintingMode = false;
  //     _isStampMode = false;
  //   });
  // }

  void _startDrawing(Offset point) {
    setState(() {
      _points.add(point);
    });
  }

  void _updateDrawing(Offset point) {
    setState(() {
      _points.add(point);
    });
  }

  void _endDrawing() {
    setState(() {
      _points.add(null);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Pdfeditorcontroller().loadAsset();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISPOSE");

    Pdfeditorcontroller().resetValues();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: Text(
          pdfeditorcontroller.isPaintingMode
              ? "Pencil Tool"
              : pdfeditorcontroller.isStampMode
                  ? "Stamp Tool"
                  : "Sign Tool",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          // if (_isPaintingMode || _isStampMode || _isSignMode)
          TextButton(
            onPressed: () {
              if (pdfeditorcontroller.currentEditingTool != EditingTool.NONE) {
                pdfeditorcontroller.toggleEditingTool(EditingTool.NONE);
              } else {
                pdfeditorcontroller.exportImage();
              }
              // pdfeditorcontroller.resetValues();
            },
            child: Text(
              pdfeditorcontroller.currentEditingTool != EditingTool.NONE
                  ? "Done"
                  : "Export",
              style: const TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Screenshot(
              controller: pdfeditorcontroller.screenshotController,
              child: Stack(
                children: [
                  Center(
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onPanStart: pdfeditorcontroller.currentEditingTool ==
                            EditingTool.PAINT
                        ? (details) => _startDrawing(details.localPosition)
                        : null,
                    onPanUpdate: pdfeditorcontroller.currentEditingTool ==
                            EditingTool.PAINT
                        ? (details) => _updateDrawing(details.localPosition)
                        : null,
                    onPanEnd: pdfeditorcontroller.currentEditingTool ==
                            EditingTool.PAINT
                        ? (details) => _endDrawing()
                        : null,
                    child: CustomPaint(
                      painter:
                          _DrawingPainter(_points, _selectedColor, _brushSize),
                      size: Size.infinite,
                    ),
                  ),
                  Stack(
                    children: [
                      for (int i = 0;
                          i < pdfeditorcontroller.pdfEditorItems.length;
                          i++)
                        if (pdfeditorcontroller.pdfEditorItems[i].signatureModel
                                ?.signatureText !=
                            null)
                          Positioned(
                            left: pdfeditorcontroller.pdfEditorItems[i]
                                .signatureModel?.signaturePosition.dx,
                            top: pdfeditorcontroller.pdfEditorItems[i]
                                .signatureModel?.signaturePosition.dy,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                pdfeditorcontroller.onSignaturePositionChange(
                                    i, details.delta.dx, details.delta.dy);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: pdfeditorcontroller.pdfEditorItems[i]
                                        .signatureModel?.signatureWith,
                                    height: pdfeditorcontroller
                                        .pdfEditorItems[i]
                                        .signatureModel
                                        ?.signatureHeight,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(47, 168, 255, 1),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign",
                                        style: TextStyle(
                                          fontFamily: pdfeditorcontroller
                                              .selectedSignature,
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
                                      // onPanUpdate: (details) {
                                      //   setState(() {
                                      //     signatureSize = Size(
                                      //       (signatureSize.width +
                                      //               details.delta.dx)
                                      //           .clamp(50.0, double.infinity),
                                      //       (signatureSize.height +
                                      //               details.delta.dy)
                                      //           .clamp(50.0, double.infinity),
                                      //     );
                                      //   });
                                      // },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(47, 168, 255, 1),
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
                                        // setState(() {
                                        //   signatureSize = Size(
                                        //     (signatureSize.width -
                                        //             details.delta.dx)
                                        //         .clamp(50.0, double.infinity),
                                        //     (signatureSize.height -
                                        //             details.delta.dy)
                                        //         .clamp(50.0, double.infinity),
                                        //   );
                                        //   signaturePosition = Offset(
                                        //     signaturePosition.dx +
                                        //         details.delta.dx,
                                        //     signaturePosition.dy +
                                        //         details.delta.dy,
                                        //   );
                                        // });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(47, 168, 255, 1),
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
                                        // setState(() {
                                        //   signatureSize = Size(
                                        //     (signatureSize.width +
                                        //             details.delta.dx)
                                        //         .clamp(50.0, double.infinity),
                                        //     (signatureSize.height -
                                        //             details.delta.dy)
                                        //         .clamp(50.0, double.infinity),
                                        //   );
                                        //   signaturePosition = Offset(
                                        //     signaturePosition.dx,
                                        //     signaturePosition.dy +
                                        //         details.delta.dy,
                                        //   );
                                        // });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(47, 168, 255, 1),
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
                                        // setState(() {
                                        //   signatureSize = Size(
                                        //     (signatureSize.width -
                                        //             details.delta.dx)
                                        //         .clamp(50.0, double.infinity),
                                        //     (signatureSize.height +
                                        //             details.delta.dy)
                                        //         .clamp(50.0, double.infinity),
                                        //   );
                                        //   signaturePosition = Offset(
                                        //     signaturePosition.dx +
                                        //         details.delta.dx,
                                        //     signaturePosition.dy,
                                        //   );
                                        // });
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(47, 168, 255, 1),
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
                ],
              ),
            ),
          ),
          pdfeditorcontroller.currentEditingTool == EditingTool.NONE
              ? _buildBottomBar(pdfeditorcontroller)
              : pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
                  ? _buildColorPalette()
                  : pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
                      ? _buildColorPalette()
                      : pdfeditorcontroller.currentEditingTool ==
                              EditingTool.SIGN
                          ? _buildSignSelection(pdfeditorcontroller)
                          : Container(),
          // if (pdfeditorcontroller.isBottomBarVisible)
          //   _buildBottomBar(pdfeditorcontroller),
          // if (pdfeditorcontroller.isPaintingMode) _buildColorPalette(),
          if (pdfeditorcontroller.currentEditingTool == EditingTool.PAINT)
            _buildBrushSizeSlider(),
          // if (pdfeditorcontroller.isSignMode)
          //   _buildSignSelection(pdfeditorcontroller),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label,
      {required VoidCallback onTap}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onTap,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildColorPalette() {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.brown,
      Colors.black,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: _selectedColor == color
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBrushSizeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
          activeTrackColor: _selectedColor,
          inactiveTrackColor: Colors.grey[800],
          thumbColor: _selectedColor,
          overlayColor: _selectedColor.withOpacity(0.2),
        ),
        child: Slider(
          value: _brushSize,
          min: 1.0,
          max: 20.0,
          onChanged: (value) {
            setState(() {
              _brushSize = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSignSelection(Pdfeditorcontroller controller) {
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
    return Container(
      color: Color.fromRGBO(43, 46, 50, 1),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fontFamilies.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: Center(
                child: Icon(Icons.add, color: Colors.red, size: 24),
              ),
            );
          }

          String fontFamily = fontFamilies[index - 1];
          return GestureDetector(
            onTap: () => controller.handleSignatureSelection(fontFamily),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: 70,
              height: 30,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(Pdfeditorcontroller pdfeditorcontroller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(Icons.draw, "Paint",
              onTap: () =>
                  pdfeditorcontroller.toggleEditingTool(EditingTool.PAINT)),
          _buildIconButton(Icons.edit, "Sign",
              onTap: () =>
                  pdfeditorcontroller.toggleEditingTool(EditingTool.SIGN)),
          _buildIconButton(Icons.format_paint, "Stamp", onTap: () {
            // pdfeditorcontroller.toggleEditingTool(EditingTool.STAMP);
            _openStampModalSheet(context);
          }),
          _buildIconButton(Icons.text_fields, "Text", onTap: () {
            pdfeditorcontroller.toggleEditingTool(EditingTool.TEXT);
          }),
          _buildIconButton(Icons.calendar_month, "Date", onTap: () {
            _openDateModalSheet(context);
          }),
        ],
      ),
    );
  }

  List<Color> generateRandomColors(int count) {
    final random = Random();
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      // Generate random color components
      int r = random.nextInt(256);
      int g = random.nextInt(256);
      int b = random.nextInt(256);

      // Increase brightness to ensure good contrast against black
      // This can be done by ensuring the color is sufficiently bright
      if ((r * 0.299 + g * 0.587 + b * 0.114) < 186) {
        r = (r + 128).clamp(0, 255).toInt();
        g = (g + 128).clamp(0, 255).toInt();
        b = (b + 128).clamp(0, 255).toInt();
      }

      colors.add(Color.fromRGBO(r, g, b, 1.0));
    }
    return colors;
  }

  void _openDateModalSheet(BuildContext context) {
    final now = DateTime.now();

    // Define date formats
    final dateFormats = [
      DateFormat('yyyy-MM-dd').format(now),
      DateFormat('dd/MM/yyyy').format(now),
      DateFormat('MM-dd-yyyy').format(now),
      DateFormat('yyyy/MM/dd').format(now),
      DateFormat('EEEE, MMMM d, yyyy').format(now),
      DateFormat('MMM d, yyyy').format(now),
      DateFormat('d MMM yyyy').format(now),
      DateFormat('dd MMMM yyyy').format(now),
      DateFormat('yyyy.MM.dd').format(now),
      DateFormat('yy-MM-dd').format(now),
      DateFormat('MMMM d, yyyy').format(now),
      DateFormat('d-MMM-yyyy').format(now),
      DateFormat('d MMM yyyy').format(now),
      DateFormat('MM/yyyy').format(now),
      DateFormat('yyyy/MMM/dd').format(now),
      DateFormat('dd.MM.yyyy').format(now),
    ];
    final colors = generateRandomColors(dateFormats.length);
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: Color.fromRGBO(43, 46, 50, 1),
                elevation: 0,
                title: Center(
                  child: Text(
                    "Add Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Container(
                height: size.height * .40,
                child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    itemCount: dateFormats.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return _buildDateOption(
                          dateFormats[index], colors[index]);
                    }),
              )
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //
              //       _buildDateOption("01 Jan 2024", Colors.red),
              //       _buildDateOption("14 Feb 2024", Colors.green),
              //       _buildDateOption("25 Mar 2024", Colors.blue),
              //       _buildDateOption("01 Apr 2024", Colors.orange),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _openStampModalSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      barrierColor: Colors.black.withOpacity(0.9),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
            height: size.height * .90, child: StampsWidget(context));
      },
    );
  }

  Widget _buildDateOption(String date, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          date,
          style: TextStyle(color: color, fontSize: 16),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double brushSize;

  _DrawingPainter(this.points, this.color, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget StampsWidget(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Column(
    children: [
      AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: Center(
          child: Text(
            "Add Stamp",
            style: TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      Expanded(
        child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: 24,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 0.7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Image.asset('assets/Stamps/${index + 1}.png');
            }),
      )
    ],
  );
}
