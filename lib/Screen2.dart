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
  Color _selectedColor = Colors.black;
  double _brushSize = 5.0;

  void _togglePaintingMode() {
    setState(() {
      _isPaintingMode = !_isPaintingMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: _isPaintingMode
            ? Color.fromRGBO(43, 46, 50, 1)
            : Color.fromRGBO(43, 46, 50, 1),
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
            child: Center(
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.contain,
              ),
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
                  _buildIconButton(Icons.edit, "Sign", () {
                    // Handle Sign action
                  }),
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
              width: 39, // Increased size
              height: 39, // Increased size
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8), // Rounded corners
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
          trackHeight: 4.0, // Increase the thickness of the slider track
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0), // Larger thumb
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0), // Larger overlay when sliding
          activeTrackColor: Colors.red, // Active track color (upper part)
          inactiveTrackColor: Colors.grey[800], // Inactive track color (lower part)
          thumbColor: Colors.red, // Thumb color
          overlayColor: Colors.red.withOpacity(0.2), // Overlay color when thumb is pressed
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
