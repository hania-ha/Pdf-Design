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

class _PdfEditorScreenState extends State<PdfEditorScreen> {
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
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
        // title: _isPaintingMode
        //     ? Text(
        //         "Pencil Tool",
        //         style: TextStyle(color: Colors.white),
        //       )
        //     : null,
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
