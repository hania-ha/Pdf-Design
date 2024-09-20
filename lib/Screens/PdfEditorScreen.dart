import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Screens/PremiumScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
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

  String selectedSignature = '';
  String? userSignature;

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

  GlobalKey globalKey = GlobalKey();
  Size? size;
  Offset? offset;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Pdfeditorcontroller().loadAsset();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISPOSE");
  }

  double _imageWidth = 0;
  double _imageHeight = 0;

  // Load image and get its dimensions
  void _loadImage() {
    final image = Image.file(widget.imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
        print("Width: Height:: ${_imageWidth} :: ${_imageHeight}");
      }),
    );
  }

  // Offset signaturePosition = Offset(20, 20);
  Size signatureSize = Size(100, 60);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context);
    return PopScope(
      onPopInvoked: (value) {
        Provider.of<Pdfeditorcontroller>(context, listen: false).resetValues();
      },
      child: Scaffold(
        backgroundColor: AppColors.primarybgColor,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 90,
              // color: Colors.red,
              child: pdfeditorcontroller.currentEditingTool == EditingTool.NONE
                  ? _buildBottomBar(pdfeditorcontroller)
                  : pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
                      ? _buildColorPalette()
                      : pdfeditorcontroller.currentEditingTool ==
                              EditingTool.PAINT
                          ? _buildColorPalette()
                          : pdfeditorcontroller.currentEditingTool ==
                                      EditingTool.SIGN &&
                                  pdfeditorcontroller.checkIfSignatureExist() ==
                                      true
                              ? _buildSignSelection(pdfeditorcontroller)
                              : pdfeditorcontroller.currentEditingTool ==
                                          EditingTool.SIGN &&
                                      pdfeditorcontroller
                                              .checkIfSignatureExist() ==
                                          false
                                  ? _buildAddSignature(pdfeditorcontroller,
                                      toAddSimpleText: false)
                                  : pdfeditorcontroller.currentEditingTool ==
                                          EditingTool.TEXT
                                      ? _buildAddSignature(pdfeditorcontroller,
                                          toAddSimpleText: true)
                                      : _buildBottomBar(pdfeditorcontroller),
            ),
          ],
        ),
        // bottomNavigationBar: _buildBottomBar(pdfeditorcontroller),
        // bottomNavigationBar:

        // if (pdfeditorcontroller.currentEditingTool == EditingTool.PAINT)
        //   _buildBrushSizeSlider(),

        appBar: AppBar(
          backgroundColor: AppColors.secondaryBgColor,
          elevation: 0,
          title: Text(
            pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
                ? "Paint Tool"
                : pdfeditorcontroller.currentEditingTool == EditingTool.SIGN
                    ? "Sign Tool"
                    : pdfeditorcontroller.currentEditingTool ==
                            EditingTool.STAMP
                        ? "Stamp Tool"
                        : pdfeditorcontroller.currentEditingTool ==
                                EditingTool.TEXT
                            ? "Text Tool"
                            : pdfeditorcontroller.currentEditingTool ==
                                    EditingTool.DATE
                                ? "Date Tool"
                                : "PDF Editor",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            // if (_isPaintingMode || _isStampMode || _isSignMode)

            IconButton(
                onPressed: () {
                  pdfeditorcontroller.deleteItem();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            TextButton(
              onPressed: () {
                if (pdfeditorcontroller.currentEditingTool !=
                    EditingTool.NONE) {
                  pdfeditorcontroller.toggleEditingTool(EditingTool.NONE);
                } else {
                  if (Inappservice().isUserPro()) {
                    pdfeditorcontroller.exportImage(context);
                  } else {
                    if (pdfeditorcontroller.isBasicAvailable()) {
                      pdfeditorcontroller.exportImage(context);
                    } else {
                      context.push(PremiumScreen());
                    }
                  }
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
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              pdfeditorcontroller.toggleItemSelection(-1);
              pdfeditorcontroller.toggleEditingTool(EditingTool.NONE);
            },
            child: Column(
              children: [
                if (kDebugMode)
                  ElevatedButton(
                      onPressed: () {
                        pdfeditorcontroller.resetCounterInTesting();
                      },
                      child: Text("Reset Counter")),
                Container(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: size.height * 0.6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * .9,
                        height: size.height * .60,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: AssetImage(
                              AppConsts.bgCanvas,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Screenshot(
                          controller: pdfeditorcontroller.screenshotController,
                          child: Stack(
                            children: [
                              Align(
                                child: Container(
                                  key: globalKey,
                                  child: Image.file(
                                    widget.imageFile,
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onPanStart: pdfeditorcontroller
                                              .currentEditingTool ==
                                          EditingTool.PAINT
                                      ? (details) =>
                                          _startDrawing(details.localPosition)
                                      : null,
                                  onPanUpdate: pdfeditorcontroller
                                              .currentEditingTool ==
                                          EditingTool.PAINT
                                      ? (details) =>
                                          _updateDrawing(details.localPosition)
                                      : null,
                                  onPanEnd:
                                      pdfeditorcontroller.currentEditingTool ==
                                              EditingTool.PAINT
                                          ? (details) => _endDrawing()
                                          : null,
                                  child: CustomPaint(
                                    painter: _DrawingPainter(
                                        _points, _selectedColor, _brushSize),
                                    size: Size.infinite,
                                  ),
                                ),
                              ),
                              pdfeditorcontroller.pdfEditorItems.isEmpty
                                  ? Container()
                                  : Stack(
                                      children: [
                                        for (int i = 0;
                                            i <
                                                pdfeditorcontroller
                                                    .pdfEditorItems.length;
                                            i++) ...[
                                          GestureDetector(
                                            onPanUpdate: (details) {
                                              pdfeditorcontroller
                                                  .onPositionChange(
                                                      i,
                                                      details.delta.dx,
                                                      details.delta.dy,
                                                      647);

                                              pdfeditorcontroller
                                                  .toggleItemSelection(i);

                                              pdfeditorcontroller
                                                  .toggleEditingTool(
                                                      pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .editingTool);
                                            },
                                            onTap: () {
                                              pdfeditorcontroller
                                                  .toggleItemSelection(i);

                                              pdfeditorcontroller
                                                  .toggleEditingTool(
                                                      pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .editingTool);
                                            },
                                            child: Stack(
                                              children: [
                                                if (pdfeditorcontroller
                                                        .getItemEditingType(
                                                            i) ==
                                                    EditingTool.SIGN)
                                                  Positioned(
                                                    left: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .signatureModel
                                                        ?.signaturePosition
                                                        .dx,
                                                    top: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .signatureModel
                                                        ?.signaturePosition
                                                        .dy,
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          width: pdfeditorcontroller
                                                              .pdfEditorItems[i]
                                                              .signatureModel
                                                              ?.signatureSize
                                                              .width,
                                                          height: pdfeditorcontroller
                                                              .pdfEditorItems[i]
                                                              .signatureModel
                                                              ?.signatureSize
                                                              .height,
                                                          decoration: pdfeditorcontroller
                                                                      .selectedItemIndex ==
                                                                  i
                                                              ? BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2,
                                                                  ),
                                                                )
                                                              : BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                          child: FittedBox(
                                                            child: Text(
                                                              pdfeditorcontroller
                                                                      .pdfEditorItems[
                                                                          i]
                                                                      .signatureModel
                                                                      ?.signatureText
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                fontFamily: pdfeditorcontroller
                                                                    .getFontFamily(
                                                                        i,
                                                                        isSimpleText:
                                                                            false),
                                                                color: pdfeditorcontroller
                                                                    .getSignatureColor(
                                                                        i),
                                                                fontSize:
                                                                    pdfeditorcontroller
                                                                        .getFontSize(
                                                                            i),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightBottom(
                                                              i,
                                                              pdfeditorcontroller,
                                                              EditingTool.SIGN),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.SIGN),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftBottom(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.SIGN),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.SIGN),
                                                      ],
                                                    ),
                                                  ),
                                                if (pdfeditorcontroller
                                                        .getItemEditingType(
                                                            i) ==
                                                    EditingTool.STAMP)
                                                  Positioned(
                                                    left: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .stampModel
                                                        ?.stampPosition
                                                        .dx,
                                                    top: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .stampModel
                                                        ?.stampPosition
                                                        .dy,
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          decoration: pdfeditorcontroller
                                                                      .selectedItemIndex ==
                                                                  i
                                                              ? BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2,
                                                                  ),
                                                                )
                                                              : BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                          child: Image.asset(
                                                            pdfeditorcontroller
                                                                .getStampImage(
                                                                    i),
                                                            width: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .stampModel!
                                                                .stampSize
                                                                .width,
                                                            height: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .stampModel!
                                                                .stampSize
                                                                .height,
                                                          ),
                                                        ),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightBottom(
                                                              i,
                                                              pdfeditorcontroller,
                                                              EditingTool
                                                                  .STAMP),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool
                                                                  .STAMP),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftBottom(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool
                                                                  .STAMP),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool
                                                                  .STAMP),
                                                      ],
                                                    ),
                                                  ),
                                                if (pdfeditorcontroller
                                                        .getItemEditingType(
                                                            i) ==
                                                    EditingTool.DATE)
                                                  Positioned(
                                                    left: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .dateModel
                                                        ?.dateWidgetPosition
                                                        .dx,
                                                    top: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .dateModel
                                                        ?.dateWidgetPosition
                                                        .dy,
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 2,
                                                            ),
                                                          ),

                                                          width:
                                                              pdfeditorcontroller
                                                                  .pdfEditorItems[
                                                                      i]
                                                                  .dateModel
                                                                  ?.dataSize
                                                                  .width,
                                                          // height: pdfeditorcontroller
                                                          //     .pdfEditorItems[i]
                                                          //     .dateModel
                                                          //     ?.dataSize
                                                          //     .height,
                                                          child:
                                                              pdfeditorcontroller
                                                                  .pdfEditorItems[
                                                                      i]
                                                                  .dateModel
                                                                  ?.dateWidget,
                                                        ),
                                                        // if (pdfeditorcontroller
                                                        //         .selectedItemIndex ==
                                                        //     i)
                                                        //   PinchRightBottom(
                                                        //       i,
                                                        //       pdfeditorcontroller,
                                                        //       EditingTool.DATE),
                                                        // if (pdfeditorcontroller
                                                        //         .selectedItemIndex ==
                                                        //     i)
                                                        //   PinchLeftTop(pdfeditorcontroller,
                                                        //       i, EditingTool.DATE),
                                                        // if (pdfeditorcontroller
                                                        //         .selectedItemIndex ==
                                                        //     i)
                                                        //   PinchLeftBottom(
                                                        //       pdfeditorcontroller,
                                                        //       i,
                                                        //       EditingTool.DATE),
                                                        // if (pdfeditorcontroller
                                                        //         .selectedItemIndex ==
                                                        //     i)
                                                        //   PinchRightTop(pdfeditorcontroller,
                                                        //       i, EditingTool.DATE),
                                                      ],
                                                    ),
                                                  ),
                                                if (pdfeditorcontroller
                                                        .getItemEditingType(
                                                            i) ==
                                                    EditingTool.TEXT)
                                                  Positioned(
                                                    left: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .textModel
                                                        ?.textPosition
                                                        .dx,
                                                    top: pdfeditorcontroller
                                                        .pdfEditorItems[i]
                                                        .textModel
                                                        ?.textPosition
                                                        .dy,
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          // width: signatureSize.width,
                                                          // height: signatureSize.height,
                                                          width:
                                                              pdfeditorcontroller
                                                                  .pdfEditorItems[
                                                                      i]
                                                                  .textModel!
                                                                  .textSize
                                                                  .width,
                                                          height:
                                                              pdfeditorcontroller
                                                                  .pdfEditorItems[
                                                                      i]
                                                                  .textModel!
                                                                  .textSize
                                                                  .height,
                                                          decoration: pdfeditorcontroller
                                                                      .selectedItemIndex ==
                                                                  i
                                                              ? BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2,
                                                                  ),
                                                                )
                                                              : BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .transparent,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                          child: FittedBox(
                                                            child: Text(
                                                              pdfeditorcontroller
                                                                      .pdfEditorItems[
                                                                          i]
                                                                      .textModel
                                                                      ?.text
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                fontFamily: pdfeditorcontroller
                                                                    .getFontFamily(
                                                                        i,
                                                                        isSimpleText:
                                                                            true),
                                                                color: pdfeditorcontroller
                                                                    .getTextColor(
                                                                        i),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.TEXT),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchLeftBottom(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.TEXT),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightTop(
                                                              pdfeditorcontroller,
                                                              i,
                                                              EditingTool.TEXT),
                                                        if (pdfeditorcontroller
                                                                .selectedItemIndex ==
                                                            i)
                                                          PinchRightBottom(
                                                              i,
                                                              pdfeditorcontroller,
                                                              EditingTool.TEXT),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned PinchRightTop(
      Pdfeditorcontroller pdfeditorcontroller, int i, EditingTool editingTool) {
    return Positioned(
      right: -5,
      top: -5,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (editingTool == EditingTool.SIGN) {
            setState(() {
              pdfeditorcontroller
                  .pdfEditorItems[i].signatureModel?.signatureSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.width +
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );
              pdfeditorcontroller.onPositionChange(i, 0, details.delta.dy, i);
            });
          } else if (editingTool == EditingTool.STAMP) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].stampModel?.stampSize =
                  Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.width +
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );
              pdfeditorcontroller.onPositionChange(i, 0, details.delta.dy, i);
            });
          } else if (editingTool == EditingTool.TEXT) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].textModel?.textSize = Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.width +
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );
              pdfeditorcontroller.onPositionChange(i, 0, details.delta.dy, i);
            });
          }
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color.fromRGBO(47, 168, 255, 1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ),
    );
  }

  Positioned PinchLeftBottom(
      Pdfeditorcontroller pdfeditorcontroller, int i, EditingTool editingTool) {
    return Positioned(
      left: -5,
      bottom: -5,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (editingTool == EditingTool.SIGN) {
            setState(() {
              pdfeditorcontroller
                  .pdfEditorItems[i].signatureModel?.signatureSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.height +
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(i, details.delta.dx, 0, i);
            });
          } else if (editingTool == EditingTool.STAMP) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].stampModel?.stampSize =
                  Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.height +
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(i, details.delta.dx, 0, i);
            });
          } else if (editingTool == EditingTool.TEXT) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].textModel?.textSize = Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.height +
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(i, details.delta.dx, 0, i);
            });
          }

          // setState(() {
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(47, 168, 255, 1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ),
    );
  }

  Positioned PinchLeftTop(
      Pdfeditorcontroller pdfeditorcontroller, int i, EditingTool sign) {
    return Positioned(
      left: -5,
      top: -5,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (sign == EditingTool.SIGN) {
            setState(() {
              pdfeditorcontroller
                  .pdfEditorItems[i].signatureModel?.signatureSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].signatureModel!
                            .signatureSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(
                  i, details.delta.dx, details.delta.dy, i);
            });
          } else if (sign == EditingTool.STAMP) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].stampModel?.stampSize =
                  Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].stampModel!.stampSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(
                  i, details.delta.dx, details.delta.dy, i);
            });
          } else if (sign == EditingTool.TEXT) {
            setState(() {
              pdfeditorcontroller.pdfEditorItems[i].textModel?.textSize = Size(
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller
                            .pdfEditorItems[i].textModel!.textSize.height -
                        details.delta.dy)
                    .clamp(50.0, double.infinity),
              );

              pdfeditorcontroller.onPositionChange(
                  i, details.delta.dx, details.delta.dy, i);
            });
          }
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(47, 168, 255, 1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ),
    );
  }

  Positioned PinchRightBottom(
      int i, Pdfeditorcontroller pdfEdiorController, EditingTool editingTool) {
    return Positioned(
      right: -5,
      bottom: -5,
      child: GestureDetector(
        onPanUpdate: (details) {
          print(details);

          if (editingTool == EditingTool.SIGN) {
            setState(() {
              pdfEdiorController
                      .pdfEditorItems[i].signatureModel?.signatureSize =
                  Size(
                      (pdfEdiorController.pdfEditorItems[i].signatureModel!
                                  .signatureSize.width +
                              details.delta.dx)
                          .clamp(50.0, double.infinity),
                      (pdfEdiorController.pdfEditorItems[i].signatureModel!
                                  .signatureSize.height +
                              details.delta.dy)
                          .clamp(50.0, double.infinity));
            });
          } else if (editingTool == EditingTool.STAMP) {
            setState(() {
              pdfEdiorController.pdfEditorItems[i].stampModel?.stampSize = Size(
                  (pdfEdiorController
                              .pdfEditorItems[i].stampModel!.stampSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController
                              .pdfEditorItems[i].stampModel!.stampSize.height +
                          details.delta.dy)
                      .clamp(50.0, double.infinity));
            });
          } else if (editingTool == EditingTool.TEXT) {
            setState(() {
              pdfEdiorController.pdfEditorItems[i].textModel?.textSize = Size(
                  (pdfEdiorController
                              .pdfEditorItems[i].textModel!.textSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController
                              .pdfEditorItems[i].textModel!.textSize.height +
                          details.delta.dy)
                      .clamp(50.0, double.infinity));
            });
          } else if (editingTool == EditingTool.DATE) {
            setState(() {
              pdfEdiorController.pdfEditorItems[i].dateModel?.dataSize = Size(
                  (pdfEdiorController
                              .pdfEditorItems[i].dateModel!.dataSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController
                              .pdfEditorItems[i].dateModel!.dataSize.height +
                          details.delta.dy)
                      .clamp(50.0, double.infinity));
            });
          }
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color.fromRGBO(47, 168, 255, 1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
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
    // List<String> fontFamilies = [
    //   'Roboto',
    //   'Arial',
    //   'Courier',
    //   'Georgia',
    //   'Times New Roman',
    //   'Verdana',
    //   'Helvetica',
    //   'Comic Sans MS',
    //   'Trebuchet MS',
    //   'Tahoma',
    // ];
    return Container(
      color: const Color.fromRGBO(43, 46, 50, 1),
      height: 60,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              String? userSignature = await showSignatureAddDialog();
              if (userSignature != null) {
                if (kDebugMode) {
                  print(userSignature);
                }
                controller.handleSignatureSelection(userSignature);
              } else {
                if (kDebugMode) {
                  print("User Didn't Write Something");
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.red, size: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.signatureFontFamilies.length,
              itemBuilder: (context, index) {
                String fontFamily = controller.signatureFontFamilies[index];
                return GestureDetector(
                  onTap: () {
                    controller.toggleSignatureFontFamily(fontFamily, index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 70,
                    height: 30,
                    padding: EdgeInsets.all(4.0),
                    decoration:
                        controller.currentlySelectedFontFamilyIndex == index
                            ? BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                    child: Center(
                      child: Text(
                        // controller.getCurrentlySelectedSign().toString(),
                        fontFamily,
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
          ),
        ],
      ),
    );
  }

  Widget _buildAddSignature(Pdfeditorcontroller controller,
      {required bool toAddSimpleText}) {
    return GestureDetector(
      onTap: () async {
        String? userSignature =
            await showSignatureAddDialog(toAddSimpleText: toAddSimpleText);
        if (userSignature != null) {
          if (toAddSimpleText) {
            controller.addText(userSignature);
          } else {
            controller.handleSignatureSelection(userSignature);
          }
        } else {
          print("User Didn't Write Something");
        }
      },
      child: Container(
          color: AppColors.secondaryBgColor,
          // color: Colors.red,
          height: 80,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.red, size: 24),
                  ),
                ),
                Text(
                  toAddSimpleText ? "Add Text" : "Add Signature",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          )),
    );
  }

  Future<dynamic> showSignatureAddDialog({bool? toAddSimpleText}) {
    String? UserSignature;
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: ThemeData(useMaterial3: true),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(vertical: 50),
              backgroundColor: AppColors.primarybgColor,
              title: Text(
                toAddSimpleText != null && toAddSimpleText
                    ? "Write Your Text"
                    : "Write Your Signature",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      UserSignature = value;
                    },
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(UserSignature);
                      },
                      child: const Text(
                        "Add Signature",
                        style: TextStyle(fontSize: 14),
                      ))
                ],
              ),
            ),
          );
        });
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
            _openStampModalSheet(context, pdfeditorcontroller);
          }),
          _buildIconButton(Icons.text_fields, "Text", onTap: () {
            pdfeditorcontroller.toggleEditingTool(EditingTool.TEXT);
          }),
          _buildIconButton(Icons.calendar_month, "Date", onTap: () {
            _openDateModalSheet(context, pdfeditorcontroller);
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

  void _openDateModalSheet(
      BuildContext context, Pdfeditorcontroller controller) {
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
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          _buildDateOption(dateFormats[index], colors[index],
                              onTapped: () {
                            context.pop();
                            if (Inappservice().isUserPro()) {
                              controller.addDate(_buildDateOption(
                                  dateFormats[index], colors[index],
                                  onTapped: () {}));
                            } else {
                              context.push(PremiumScreen());
                            }
                          }),
                          GestureDetector(
                              onTap: () {
                                try {
                                  context.pop();
                                  context.push(PremiumScreen());
                                } catch (e) {}
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Image.asset(
                                  AppConsts.proCrown,
                                  width: 25,
                                  height: 25,
                                ),
                              )),
                        ],
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  void _openStampModalSheet(
      BuildContext context, Pdfeditorcontroller controller) {
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
            height: size.height * .90,
            child: StampsWidget(context, controller));
      },
    );
  }

  Widget _buildDateOption(String date, Color color,
      {required Function() onTapped}) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
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
      // Check if the point is inside the container size before drawing
      if (points[i] != null && points[i + 1] != null) {
        if (_isInBounds(points[i]!, size) &&
            _isInBounds(points[i + 1]!, size)) {
          canvas.drawLine(points[i]!, points[i + 1]!, paint);
        }
      } else if (points[i] != null && points[i + 1] == null) {
        if (_isInBounds(points[i]!, size)) {
          canvas.drawPoints(PointMode.points, [points[i]!], paint);
        }
      }
    }
  }

  bool _isInBounds(Offset point, Size size) {
    return point.dx >= 0 &&
        point.dx <= size.width &&
        point.dy >= 0 &&
        point.dy <= size.height;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Widget StampsWidget(BuildContext context, Pdfeditorcontroller controller) {
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
            itemCount: 15,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 0.7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              String stamp = 'assets/Stamps/${index + 1}.png';
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                      onTap: () {
                        try {
                          context.pop();
                          if (Inappservice().isUserPro()) {
                            controller.addStamp(stamp);
                          } else {
                            context.push(PremiumScreen());
                          }
                        } catch (e) {}
                      },
                      child: Image.asset(stamp)),
                  GestureDetector(
                      onTap: () {
                        try {
                          context.pop();
                          context.push(PremiumScreen());
                        } catch (e) {}
                      },
                      child: Image.asset(
                        AppConsts.proCrown,
                        width: 30,
                        height: 30,
                      )),
                ],
              );
            }),
      )
    ],
  );
}
