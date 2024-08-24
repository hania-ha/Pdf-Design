import 'package:flutter/material.dart';
import 'dart:io';

class Screen2 extends StatefulWidget {
  final File imageFile;

  Screen2({required this.imageFile});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  bool _isPaintingMode = false;
  bool _isStampMode = false;
  bool _isSignMode = false; // Add a new state for Sign mode
  bool _isBottomBarVisible = true;
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = [];

  void _togglePaintingMode() {
    setState(() {
      _isPaintingMode = !_isPaintingMode;
      _isStampMode = false;
      _isSignMode = false; // Exit sign mode if needed
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
      _isStampMode = false;
      _isSignMode = false; // Exit sign mode if needed
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
                  _isPaintingMode = false; // Exit painting mode
                  _isStampMode = false; // Exit stamp mode if needed
                  _isSignMode = false; // Exit sign mode
                  _isBottomBarVisible = true; // Show the bottom bar
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
                GestureDetector(
                  onPanStart: (details) {
                    if (_isPaintingMode) _startDrawing(details.localPosition);
                  },
                  onPanUpdate: (details) {
                    if (_isPaintingMode) _updateDrawing(details.localPosition);
                  },
                  onPanEnd: (details) {
                    if (_isPaintingMode) _endDrawing();
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(_points, _selectedColor, _brushSize),
                    child: Container(),
                  ),
                ),
              ],
            ),
          ),
          if (_isBottomBarVisible) ...[
            if (_isPaintingMode) _buildColorPalette(),
            if (_isPaintingMode) _buildBrushSizeSlider(),
            if (!_isPaintingMode && !_isStampMode && !_isSignMode)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.brush, "Paint", _togglePaintingMode),
                    _buildIconButton(Icons.edit, "Sign", _toggleSignMode),
                    _buildIconButton(Icons.format_paint, "Stamp", _toggleStampMode),
                    _buildIconButton(Icons.text_fields, "Text", () {
                      // Handle Text action
                    }),
                    _buildIconButton(Icons.calendar_today, "Date", _openDateModalSheet),
                  ],
                ),
              ),
            if (_isSignMode) _buildSignOptions(),
          ],
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
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.grey,
          thumbColor: Colors.white,
          overlayColor: Colors.white.withAlpha(32),
        ),
        child: Slider(
          value: _brushSize,
          min: 1.0,
          max: 10.0,
          onChanged: (value) {
            setState(() {
              _brushSize = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSignOptions() {
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

  return Container(
    color: Color.fromRGBO(43, 46, 50, 1), // Bottom navigation bar color
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Bottom bar with red plus sign and font family options
        Row(
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
                height: 60, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: fontFamilies.length,
                  itemBuilder: (context, index) {
                    return Container(
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildSignatureOption(String signature, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          signature,
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
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
