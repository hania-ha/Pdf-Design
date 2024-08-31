import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'SignatureScreen.dart';

class PdfEditorScreen extends StatefulWidget {
  final File imageFile;
  PdfTool pdfTool = PdfTool.General;

  PdfEditorScreen({required this.imageFile, required this.pdfTool});

  @override
  _PdfEditorScreenState createState() => _PdfEditorScreenState();
}






class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double brushSize;

  _DrawingPainter(this.points, this.color, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StampSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        title: Text(
          "Pencil Tool",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
         iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the screen
            },
            child: Text(
              "Done",
              style: TextStyle(
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
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 20, // Increased spacing between columns
              mainAxisSpacing: 20, // Increased spacing between rows
              padding: EdgeInsets.all(16.0),
              children: List.generate(12, (index) {
                return _buildStamp(
                  "Stamp $index",
                  Colors.primaries[index % Colors.primaries.length],
                  index,
                );
              }),
            ),
          ),
          Container(
            color: Color.fromRGBO(43, 46, 50, 1),
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(66, 69, 73, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStamp(String label, Color color, int index) {
    return GestureDetector(
      onTap: () {
        // Handle stamp selection
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}




class _Screen2State extends State<Screen2> {
  bool _isPaintingMode = false;
  bool _isStampMode = false;
  bool _isSignMode = false;
  bool _isBottomBarVisible = true;
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = [];
  String _selectedSignature = '';


  List<String> fontFamilies = [
    'Roboto',
    'Arial',
    'Courier New',
    'Georgia',
    'Times New Roman',
    'Verdana',
    'Tahoma',
    'Trebuchet MS',
    'Comic Sans MS',
    'Helvetica'
  ];

  void _togglePaintingMode() {
    setState(() {
      _isPaintingMode = !_isPaintingMode;
      _isStampMode = false;
      _isSignMode = false;
    });
  }

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  void _navigateToSignatureScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignatureScreen(imageFile: widget.imageFile),
  void _toggleStampMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StampSelectionScreen(),
      ),
    );
    setState(() {
      _isStampMode = false;
      _isSignMode = false;
    });
  }

  void _toggleSignMode() {
    setState(() {
      _isSignMode = !_isSignMode;
      _isPaintingMode = false;
      _isStampMode = false;
    });
  }

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


  Widget _buildSignOptions() {
    return Container(
      color: Color.fromRGBO(43, 46, 50, 1),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fontFamilies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Update the selected signature
                        _selectedSignature = fontFamilies[index];
                      });
                    },
                    child: Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Sign",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: fontFamilies[index],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDateModalSheet() {
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Edit Date",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ),
                    _buildDateOption("01 Jan 2024", Colors.red),
                    _buildDateOption("14 Feb 2024", Colors.green),
                    _buildDateOption("25 Mar 2024", Colors.blue),
                    _buildDateOption("01 Apr 2024", Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        );
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
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: _isPaintingMode || _isStampMode || _isSignMode
            ? Text(
                _isPaintingMode ? "Pencil Tool" : _isStampMode ? "Stamp Tool" : "Sign Tool",
                style: TextStyle(color: Colors.white),
              )
            : null,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_isPaintingMode || _isStampMode || _isSignMode)
            TextButton(
              onPressed: () {
                setState(() {
                  _isPaintingMode = false;
                  _isStampMode = false;
                  _isSignMode = false;
                  _isBottomBarVisible = true;
                });
              },
              child: Text(
                "Done",
                style: TextStyle(
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
            child: Stack(
              children: [
                Center(
                  child: Image.file(
                    widget.imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          if (pdfeditorcontroller.isPaintingMode)
            _buildColorPalette(pdfeditorcontroller),
          if (pdfeditorcontroller.isPaintingMode)
            _buildBrushSizeSlider(pdfeditorcontroller),
          if (!pdfeditorcontroller.isPaintingMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.draw, "Paint",
                      pdfeditorcontroller.togglePaintingMode),
                  _buildIconButton(
                      Icons.edit, "Sign", _navigateToSignatureScreen),
                  _buildIconButton(Icons.format_paint, "Stamp", () {
                    // Handle Stamp action
                  }),
                  _buildIconButton(Icons.text_fields, "Text", () {
                    // Handle Text action
                  }),
                  _buildIconButton(Icons.calendar_month, "Date", () {
                    // Handle Date action
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
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

  Widget _buildColorPalette(Pdfeditorcontroller controller) {
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
              controller.toggleColor(color);
            },
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: controller.selectedColor == color
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBrushSizeSlider(Pdfeditorcontroller controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
          activeTrackColor: controller.selectedColor,
          inactiveTrackColor: Colors.grey[800],
          thumbColor: controller.selectedColor,
          overlayColor: controller.selectedColor.withOpacity(0.2),
        ),
        child: Slider(
          value: controller.brushSize,
          min: 1.0,
          max: 20.0,
          onChanged: (value) {
            controller.onColorPallateSliderChanged(value);
          },
        ),
      ),
    );
  }
}