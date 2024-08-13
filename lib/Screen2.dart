import 'package:flutter/material.dart';
import 'dart:io';
import 'SignatureScreen.dart';

class Screen2 extends StatefulWidget {
  final File imageFile;

  Screen2({required this.imageFile});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  bool _isPaintingMode = false;
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = []; // List to store drawing points

  void _togglePaintingMode() {
    setState(() {
      _isPaintingMode = !_isPaintingMode;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        title: _isPaintingMode
            ? Text(
                "Pencil Tool",
                style: TextStyle(color: Colors.white),
              )
            : null,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
          if (!_isPaintingMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconButton(Icons.draw, "Paint", _togglePaintingMode),
                  _buildIconButton(Icons.edit, "Sign", _navigateToSignatureScreen),
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
