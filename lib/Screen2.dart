import 'package:flutter/material.dart';
import 'dart:io';
import 'SignatureScreen.dart'; // Import the SignatureScreen file

class Screen2 extends StatefulWidget {
  final File imageFile;

  Screen2({required this.imageFile});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  bool _isPaintingMode = false;
  bool _isStampMode = false;
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = []; // List to store drawing points

  void _togglePaintingMode() {
    setState(() {
      _isPaintingMode = !_isPaintingMode;
      _isStampMode = false; // Ensure stamp mode is off when painting mode is toggled
    });
  }

  void _toggleStampMode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StampSelectionScreen(),
      ),
    );
    setState(() {
      _isStampMode = false; // Ensure stamp mode is turned off after navigating
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
      _points.add(null); // Add a null point to signify the end of a stroke
    });
  }

  void _navigateToSignatureScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignatureScreen(imageFile: widget.imageFile),
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
                    Navigator.of(context).pop(); // Close the modal sheet
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
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: _isPaintingMode || _isStampMode
            ? Text(
                _isPaintingMode ? "Pencil Tool" : "Stamp Tool",
                style: TextStyle(color: Colors.white),
              )
            : null,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (_isPaintingMode || _isStampMode)
            TextButton(
              onPressed: () {
                // Handle the "Done" button action
              },
              child: Text(
                "Done",
                style: TextStyle(
                  color: Color.fromRGBO(47, 168, 255, 1), // Blue color for "Done"
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
                if (_isPaintingMode)
                  GestureDetector(
                    onPanStart: (details) {
                      _startDrawing(details.localPosition);
                    },
                    onPanUpdate: (details) {
                      _updateDrawing(details.localPosition);
                    },
                    onPanEnd: (details) {
                      _endDrawing();
                    },
                    child: CustomPaint(
                      painter: _DrawingPainter(_points, _selectedColor, _brushSize),
                      child: Container(),
                    ),
                  ),
              ],
            ),
          ),
          if (_isPaintingMode) _buildColorPalette(),
          if (_isPaintingMode) _buildBrushSizeSlider(),
          if (!_isPaintingMode && !_isStampMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.brush, "Paint", _togglePaintingMode),
                  _buildIconButton(Icons.edit, "Sign", _navigateToSignatureScreen),
                  _buildIconButton(Icons.format_paint, "Stamp", _toggleStampMode),
                  _buildIconButton(Icons.text_fields, "Text", () {
                    // Handle Text action
                  }),
                  _buildIconButton(Icons.calendar_today, "Date", _openDateModalSheet ), 
                    // Handle Date action
                  
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
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
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
        canvas.drawCircle(points[i]!, brushSize / 2, paint);
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
                color: Color.fromRGBO(47, 168, 255, 1), // Blue color for "Done"
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
            color: Color.fromRGBO(43, 46, 50, 1), // Match Scaffold background color
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                width: 230, // Set the width of the button
                height: 50, // Set the height of the button
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Apply" button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(66, 69, 73, 1), // Grey color for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Circular radius
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

