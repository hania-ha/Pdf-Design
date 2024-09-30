import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/Screens/HomeScreen.dart';
import 'package:pdf_editor/Screens/PremiumScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';

class Stroke {
  List<Offset?> points;
  Color color;

  Stroke({required this.points, required this.color});
}

class PdfEditorScreen extends StatefulWidget {
  final File imageFile;
  final PdfTool pdfTool;

  PdfEditorScreen({required this.imageFile, required this.pdfTool});

  @override
  _PdfEditorScreenState createState() => _PdfEditorScreenState();
}

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  Color _selectedColor = Colors.black;
  Color newColor = Colors.black;
  double _brushSize = 5.0;
  List<Offset?> _points = [];
  List<Stroke> strokes = [];

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
      strokes.add(Stroke(points: List.from(_points), color: _selectedColor));
      _points.clear();
    });
  }

  GlobalKey globalKey = GlobalKey();
  Size? size;
  Offset? offset;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadImage();
      Provider.of<Pdfeditorcontroller>(context, listen: false)
          .toggleEditingTool(EditingTool.NONE);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
  bool toAddNewSignature = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context);
    ProScreenController proScreenController =
        Provider.of<ProScreenController>(context);
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
                  ? _buildBottomBar(pdfeditorcontroller, proScreenController)
                  : pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
                      ? Column(
                          children: [
                            _buildColorPalette(),
                            Container(height: 10),
                            // _buildBrushSizeSlider(),
                          ],
                        )
                      : pdfeditorcontroller.currentEditingTool ==
                                  EditingTool.SIGN &&
                              pdfeditorcontroller.checkIfSignatureExist() ==
                                  true &&
                              toAddNewSignature == false
                          ? _buildSignSelection(pdfeditorcontroller)
                          : pdfeditorcontroller.currentEditingTool ==
                                      EditingTool.SIGN &&
                                  toAddNewSignature
                              ? _buildAddSignature(pdfeditorcontroller,
                                  toAddSimpleText: false)
                              : pdfeditorcontroller.currentEditingTool ==
                                      EditingTool.TEXT
                                  ? _buildAddSignature(pdfeditorcontroller,
                                      toAddSimpleText: true)
                                  : _buildBottomBar(
                                      pdfeditorcontroller, proScreenController),
            ),
          ],
        ),
        // bottomNavigationBar: _buildBottomBar(pdfeditorcontroller),
        // bottomNavigationBar:

        // if (pdfeditorcontroller.currentEditingTool == EditingTool.PAINT)
        //

        appBar: AppBar(
          backgroundColor: AppColors.secondaryBgColor,
          elevation: 0,
          title: const Text(
            "PDF Editor",
            // pdfeditorcontroller.currentEditingTool == EditingTool.PAINT
            //     ? "Paint Tool"
            //     : pdfeditorcontroller.currentEditingTool == EditingTool.SIGN
            //         ? "Sign Tool"
            //         : pdfeditorcontroller.currentEditingTool ==
            //                 EditingTool.STAMP
            //             ? "Stamp Tool"
            //             : pdfeditorcontroller.currentEditingTool ==
            //                     EditingTool.TEXT
            //                 ? "Text Tool"
            //                 : pdfeditorcontroller.currentEditingTool ==
            //                         EditingTool.DATE
            //                     ? "Date Tool"
            //                     : "PDF Editor",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'intern',
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            // if (_isPaintingMode || _isStampMode || _isSignMode)
            // pdfeditorcontroller.selectedItemIndex != -1
            //     ? IconButton(
            //         onPressed: () {
            //           pdfeditorcontroller.deleteItem();
            //         },
            //         icon: Icon(
            //           Icons.delete,
            //           color: Colors.red,
            //         ))
            //     : Container(),
            TextButton(
              onPressed: () {
                setState(() {
                  toAddNewSignature = false;
                });
                if (pdfeditorcontroller.currentEditingTool !=
                    EditingTool.NONE) {
                  pdfeditorcontroller.toggleEditingTool(EditingTool.NONE);
                } else {
                  pdfeditorcontroller.exportImage(context);
                  // if (Inappservice().isUserPro()) {
                  //   pdfeditorcontroller.exportImage(context);
                  // } else {
                  //   if (pdfeditorcontroller.isBasicAvailable()) {
                  //     pdfeditorcontroller.exportImage(context);
                  //   } else {
                  //     context.push(PremiumScreen());
                  //   }
                  // }
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
        body: PopScope(
          canPop: false,
          // ignore: deprecated_member_use
          onPopInvoked: (value) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DiscardChangesDialog();
              },
            );
          },
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                pdfeditorcontroller.toggleItemSelection(-1);
                pdfeditorcontroller.toggleEditingTool(EditingTool.NONE);
                setState(() {
                  toAddNewSignature = false;
                });
              },
              child: Column(
                children: [
                  if (kDebugMode)
                    Container(
                      height: 20,
                    ),
                  Container(
                    constraints: BoxConstraints(maxHeight: size.height * 0.67),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * .9,
                          height: size.height * .67,
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
                            controller:
                                pdfeditorcontroller.screenshotController,
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
                                GestureDetector(
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
                                    painter: _DrawingPainter(strokes, _points,
                                        _selectedColor, _brushSize),
                                    size: Size.infinite,
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
                                                    .toggleItemSelection(-1);
                                                pdfeditorcontroller
                                                        .currentEditingTool =
                                                    EditingTool.NONE;

                                                // pdfeditorcontroller
                                                //     .toggleEditingTool(
                                                //         pdfeditorcontroller
                                                //             .pdfEditorItems[i]
                                                //             .editingTool);
                                                pdfeditorcontroller
                                                    .onPositionChange(
                                                        i,
                                                        details.delta.dx,
                                                        details.delta.dy,
                                                        647);
                                              },
                                              onTap: () {
                                                pdfeditorcontroller
                                                    .toggleItemSelection(i);

                                                pdfeditorcontroller
                                                    .toggleEditingTool(
                                                        pdfeditorcontroller
                                                            .pdfEditorItems[i]
                                                            .editingTool);

                                                if (pdfeditorcontroller
                                                        .currentEditingTool ==
                                                    EditingTool.SIGN) {
                                                  setState(() {
                                                    toAddNewSignature = false;
                                                  });
                                                }
                                              },
                                              // onDoubleTap:

                                              child: Stack(
                                                children: [
                                                  if (pdfeditorcontroller
                                                          .getItemEditingType(
                                                              i) ==
                                                      EditingTool.SIGN)
                                                    Positioned(
                                                      left: pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .pdfItemPosition
                                                          .dx,
                                                      top: pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .pdfItemPosition
                                                          .dy,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            width: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .itemSize
                                                                .width,
                                                            height: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .itemSize
                                                                .height,
                                                            decoration: pdfeditorcontroller
                                                                        .selectedItemIndex ==
                                                                    i
                                                                ? BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2,
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    border:
                                                                        Border
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
                                                                style:
                                                                    TextStyle(
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
                                                                EditingTool
                                                                    .SIGN),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchLeftTop(
                                                                pdfeditorcontroller,
                                                                i,
                                                                EditingTool
                                                                    .SIGN),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchLeftBottom(
                                                                pdfeditorcontroller,
                                                                i,
                                                                EditingTool
                                                                    .SIGN),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchRightTop(
                                                                pdfeditorcontroller,
                                                                i,
                                                                EditingTool
                                                                    .SIGN),
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
                                                          .pdfItemPosition
                                                          .dx,
                                                      top: pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .pdfItemPosition
                                                          .dy,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            decoration: pdfeditorcontroller
                                                                        .selectedItemIndex ==
                                                                    i
                                                                ? BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2,
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    border:
                                                                        Border
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
                                                          .pdfItemPosition
                                                          .dx,
                                                      top: pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .pdfItemPosition
                                                          .dy,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            decoration: pdfeditorcontroller
                                                                        .selectedItemIndex ==
                                                                    i
                                                                ? BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 2,
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .transparent,
                                                                      width: 2,
                                                                    ),
                                                                  ),

                                                            // width: pdfeditorcontroller
                                                            //     .pdfEditorItems[
                                                            //         i]
                                                            //     .dateModel
                                                            //     ?.dataSize
                                                            //     .width,
                                                            // height: pdfeditorcontroller
                                                            //     .pdfEditorItems[i]
                                                            //     .dateModel
                                                            //     ?.dataSize
                                                            //     .height,
                                                            child: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .dateModel
                                                                ?.dateWidget,
                                                          ),

                                                          // IconButton(
                                                          //   icon: Icon(
                                                          //       Icons.edit),
                                                          //   onPressed: () {

                                                          //     // pdfeditorcontroller
                                                          //     //     .editDate(
                                                          //     //         _buildDateOption(
                                                          //     //   "Hello World",
                                                          //     //   pdfeditorcontroller
                                                          //     //       .pdfEditorItems[
                                                          //     //           pdfeditorcontroller
                                                          //     //               .selectedItemIndex]
                                                          //     //       .dateModel!
                                                          //     //       .dateColor,
                                                          //     //   onTapped: () {},
                                                          //     // ));
                                                          //   },
                                                          // ),
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
                                                          .pdfItemPosition
                                                          .dx,
                                                      top: pdfeditorcontroller
                                                          .pdfEditorItems[i]
                                                          .pdfItemPosition
                                                          .dy,
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            // width: signatureSize.width,
                                                            // height: signatureSize.height,
                                                            width: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .itemSize
                                                                .width,
                                                            height: pdfeditorcontroller
                                                                .pdfEditorItems[
                                                                    i]
                                                                .itemSize
                                                                .height,
                                                            decoration: pdfeditorcontroller
                                                                        .selectedItemIndex ==
                                                                    i
                                                                ? BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                      width: 2,
                                                                    ),
                                                                  )
                                                                : BoxDecoration(
                                                                    border:
                                                                        Border
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
                                                                style:
                                                                    TextStyle(
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
                                                                EditingTool
                                                                    .TEXT),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchLeftBottom(
                                                                pdfeditorcontroller,
                                                                i,
                                                                EditingTool
                                                                    .TEXT),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchRightTop(
                                                                pdfeditorcontroller,
                                                                i,
                                                                EditingTool
                                                                    .TEXT),
                                                          if (pdfeditorcontroller
                                                                  .selectedItemIndex ==
                                                              i)
                                                            PinchRightBottom(
                                                                i,
                                                                pdfeditorcontroller,
                                                                EditingTool
                                                                    .TEXT),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            pdfeditorcontroller
                                                        .selectedItemIndex ==
                                                    i
                                                ? Positioned(
                                                    left: pdfeditorcontroller
                                                            .pdfEditorItems[i]
                                                            .pdfItemPosition
                                                            .dx +
                                                        30,
                                                    top: pdfeditorcontroller
                                                            .pdfEditorItems[i]
                                                            .pdfItemPosition
                                                            .dy -
                                                        40,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        print("hello");
                                                      },
                                                      child: Container(
                                                        // width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Row(
                                                          children: [
                                                            if (pdfeditorcontroller.currentEditingTool == EditingTool.SIGN ||
                                                                pdfeditorcontroller
                                                                        .currentEditingTool ==
                                                                    EditingTool
                                                                        .DATE ||
                                                                pdfeditorcontroller
                                                                        .currentEditingTool ==
                                                                    EditingTool
                                                                        .TEXT)
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (pdfeditorcontroller
                                                                            .currentEditingTool ==
                                                                        EditingTool
                                                                            .DATE) {
                                                                      DateTime? currentDate = pdfeditorcontroller
                                                                          .pdfEditorItems[
                                                                              pdfeditorcontroller.selectedItemIndex]
                                                                          .dateModel!
                                                                          .date;
                                                                      int selectedIndex =
                                                                          pdfeditorcontroller
                                                                              .selectedItemIndex;
                                                                      Color dateColor = pdfeditorcontroller
                                                                          .pdfEditorItems[
                                                                              selectedIndex]
                                                                          .dateModel!
                                                                          .dateColor;

                                                                      currentDate =
                                                                          await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        firstDate:
                                                                            DateTime(1970),
                                                                        lastDate:
                                                                            DateTime(2060),
                                                                        initialDate:
                                                                            currentDate,
                                                                      );
                                                                      if (currentDate !=
                                                                          null) {
                                                                        String dateFormat = pdfeditorcontroller
                                                                            .pdfEditorItems[selectedIndex]
                                                                            .dateModel!
                                                                            .dateFormat;

                                                                        String
                                                                            formatWithNewDate =
                                                                            DateFormat(dateFormat).format(currentDate);

                                                                        pdfeditorcontroller
                                                                            .editDate(
                                                                          _buildDateOption(
                                                                            formatWithNewDate,
                                                                            dateColor,
                                                                          ),
                                                                          newDate:
                                                                              currentDate,
                                                                        );
                                                                      }
                                                                    } else if (pdfeditorcontroller
                                                                            .currentEditingTool ==
                                                                        EditingTool
                                                                            .SIGN) {
                                                                      int index =
                                                                          pdfeditorcontroller
                                                                              .selectedItemIndex;
                                                                      String? userSignature = await showSignatureAddDialog(
                                                                          existedText: pdfeditorcontroller
                                                                              .pdfEditorItems[
                                                                                  index]
                                                                              .signatureModel!
                                                                              .signatureText,
                                                                          toEditText:
                                                                              true);
                                                                      if (userSignature !=
                                                                              null &&
                                                                          userSignature
                                                                              .isNotEmpty) {
                                                                        if (kDebugMode) {
                                                                          print(
                                                                              userSignature);
                                                                        }
                                                                        pdfeditorcontroller
                                                                            .editSignature(userSignature);
                                                                      } else {}
                                                                    } else {
                                                                      print(
                                                                          "UNKNOWN OPTION");
                                                                    }
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .edit)),
                                                            IconButton(
                                                                onPressed: () {
                                                                  pdfeditorcontroller
                                                                      .deleteItem();
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width +
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height -
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width +
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height -
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height +
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height +
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height -
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
              pdfeditorcontroller.pdfEditorItems[i].itemSize = Size(
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.width -
                        details.delta.dx)
                    .clamp(50.0, double.infinity),
                (pdfeditorcontroller.pdfEditorItems[i].itemSize.height -
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
              pdfEdiorController.pdfEditorItems[i].itemSize = Size(
                  (pdfEdiorController.pdfEditorItems[i].itemSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController.pdfEditorItems[i].itemSize.height +
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
              pdfEdiorController.pdfEditorItems[i].itemSize = Size(
                  (pdfEdiorController.pdfEditorItems[i].itemSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController.pdfEditorItems[i].itemSize.height +
                          details.delta.dy)
                      .clamp(50.0, double.infinity));
            });
          } else if (editingTool == EditingTool.DATE) {
            setState(() {
              pdfEdiorController.pdfEditorItems[i].itemSize = Size(
                  (pdfEdiorController.pdfEditorItems[i].itemSize.width +
                          details.delta.dx)
                      .clamp(50.0, double.infinity),
                  (pdfEdiorController.pdfEditorItems[i].itemSize.height +
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
      Colors.transparent,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (color == Colors.transparent) {
                    setState(() {
                      strokes.clear();
                    });
                  } else {
                    _selectedColor = color;
                  }
                });
              },
              child: color == Colors.transparent
                  ? Container(
                      width: 39,
                      height: 39,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Transform.rotate(
                        angle: 91.85,
                        child: Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : Container(
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
          activeTrackColor: Colors.red,
          inactiveTrackColor: Colors.grey[800],
          thumbColor: Colors.red,
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
              String? userSignature =
                  await showSignatureAddDialog(toEditText: false);
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
                    width: 80,
                    height: 30,
                    padding: EdgeInsets.all(4.0),
                    decoration:
                        // controller.currentlySelectedFontFamilyIndex == index
                        controller.pdfEditorItems[controller.selectedItemIndex]
                                    .signatureModel!.signatureFontFamilty ==
                                fontFamily
                            ? BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 3,
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
        String? userSignature = await showSignatureAddDialog(
            toAddSimpleText: toAddSimpleText, toEditText: false);
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

  Future<dynamic> showSignatureAddDialog(
      {bool? toAddSimpleText, String? existedText, required bool toEditText}) {
    String? UserSignature;
    return showDialog(
        context: context,
        builder: (context) {
          UserSignature = existedText;
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
                    initialValue: existedText,
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
                      if (UserSignature != null && UserSignature!.isNotEmpty) {
                        Navigator.of(context).pop(UserSignature);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Signature should not be empty");
                      }
                    },
                    child: Text(
                      toEditText ? "Update Signature" : "Add Signature",
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBottomBar(Pdfeditorcontroller pdfeditorcontroller,
      ProScreenController proScreenController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(Icons.draw, "Paint",
              onTap: () =>
                  pdfeditorcontroller.toggleEditingTool(EditingTool.PAINT)),
          _buildIconButton(Icons.edit, "Sign", onTap: () {
            setState(() {
              toAddNewSignature = true;
            });
            pdfeditorcontroller.toggleEditingTool(EditingTool.SIGN);
          }),
          _buildIconButton(Icons.format_paint, "Stamp", onTap: () {
            // pdfeditorcontroller.toggleEditingTool(EditingTool.STAMP);
            _openStampModalSheet(
                context, pdfeditorcontroller, proScreenController);
          }),
          _buildIconButton(Icons.text_fields, "Text", onTap: () {
            pdfeditorcontroller.toggleEditingTool(EditingTool.TEXT);
          }),
          _buildIconButton(Icons.calendar_month, "Date", onTap: () {
            _openDateModalSheet(
                context, pdfeditorcontroller, proScreenController);
          }),
        ],
      ),
    );
  }

  List<Color> generateRandomColors(int count) {
    final random = math.Random();
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      // Generate random color components within a lower range to ensure dark colors
      int r = random.nextInt(128);
      int g = random.nextInt(128);
      int b = random.nextInt(128);

      colors.add(Color.fromRGBO(r, g, b, 1.0));
    }
    return colors;
  }

  void _openDateModalSheet(BuildContext context, Pdfeditorcontroller controller,
      ProScreenController proSreenController) {
    final now = DateTime.now();
    List<String> dateFormats = [
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'MM-dd-yyyy',
      'yyyy/MM/dd',
      'EEEE, MMMM d, yyyy',
      'MMM d, yyyy',
      'd MMM yyyy',
      'dd MMMM yyyy',
      'yyyy.MM.dd',
      'yy-MM-dd',
      'MMMM d, yyyy',
      'd-MMM-yyyy',
      'd MMM yyyy',
      'MM/yyyy',
      'yyyy/MMM/dd',
      'dd.MM.yyyy'
    ];

    // Define date formats
    final dates = [
      DateFormat(dateFormats[0]).format(now),
      DateFormat(dateFormats[1]).format(now),
      DateFormat(dateFormats[2]).format(now),
      DateFormat(dateFormats[3]).format(now),
      DateFormat(dateFormats[4]).format(now),
      DateFormat(dateFormats[5]).format(now),
      DateFormat(dateFormats[6]).format(now),
      DateFormat(dateFormats[7]).format(now),
      DateFormat(dateFormats[8]).format(now),
      DateFormat(dateFormats[9]).format(now),
      DateFormat(dateFormats[10]).format(now),
      DateFormat(dateFormats[11]).format(now),
      DateFormat(dateFormats[12]).format(now),
      DateFormat(dateFormats[13]).format(now),
      DateFormat(dateFormats[14]).format(now),
      DateFormat(dateFormats[15]).format(now),
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
                          _buildDateOption(dates[index], colors[index],
                              onTapped: () {
                            context.pop();
                            if (Inappservice().isUserPro()) {
                              controller.addDate(
                                _buildDateOption(
                                  dates[
                                      index], //after formatting with the new date and passing it
                                  colors[index],
                                ),
                                colors[index],
                                dateFormats[index],
                              );
                            } else {
                              context.push(PremiumScreen());
                            }
                          }),
                          proSreenController.isUserPro
                              ? Container()
                              : GestureDetector(
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

  void _openStampModalSheet(BuildContext context,
      Pdfeditorcontroller controller, ProScreenController proScreenController) {
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
            child: StampsWidget(context, controller, proScreenController));
      },
    );
  }

  Widget _buildDateOption(String dateFormatLabel, Color color,
      {Function()? onTapped}) {
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
            dateFormatLabel,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // Erase points by proximity

  // Erase points by proximity
  void _erasePoints(Offset position) {
    setState(() {
      for (int i = 0; i < strokes.length; i++) {
        strokes[i].points.removeWhere((point) =>
            point != null && (point - position).distance < _brushSize * 2);

        // If a stroke has no points left, remove the entire stroke
        if (strokes[i].points.isEmpty) {
          strokes.removeAt(i);
          i--; // Adjust index after removal
        }
      }
    });
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double brushSize;
  final List<Stroke> strokes; // List of all strokes

  _DrawingPainter(this.strokes, this.points, this.color, this.brushSize);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = brushSize;
    // Draw all completed strokes
    for (var stroke in strokes) {
      paint.color = stroke.color;
      _drawStroke(canvas, paint, stroke.points, size);
    }
    // Draw the current stroke being drawn
    paint.color = color;
    _drawStroke(canvas, paint, points, size);
    // Draw the current stroke being drawn
  }

  void _drawStroke(
      Canvas canvas, Paint paint, List<Offset?> points, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
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

Widget StampsWidget(BuildContext context, Pdfeditorcontroller controller,
    ProScreenController proController) {
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
                    child: Image.asset(stamp),
                  ),
                  proController.isUserPro
                      ? Container()
                      : GestureDetector(
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
                          ),
                        ),
                ],
              );
            }),
      )
    ],
  );
}

class DiscardChangesDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Pdfeditorcontroller pdfeditorcontroller =
        Provider.of<Pdfeditorcontroller>(context, listen: false);
    return AlertDialog(
      backgroundColor: Color(0xFF212326),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        'All the changes will be discarded.',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel action
          },
          child: Text('Cancel'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF2B2E32),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Ok action
            pdfeditorcontroller.resetValues();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false);
          },
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2B2E32),

            //
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
