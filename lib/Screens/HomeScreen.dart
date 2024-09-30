import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf_editor/Controllers/HistoryViewController.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/Screens/HistoryView.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppStyles.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:provider/provider.dart';
import 'PdfEditorScreen.dart';
import 'PremiumScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<File> _recentFiles = [];
  bool _isPickingImage = false; // Flag to track image picker activity

  void _navigateToPremiumScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PremiumScreen(),
      ),
    );
  }

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true); // Zoom in and out continuously
    files = HistoryViewController().getFilesInDirectory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late Future<List<FileSystemEntity>> files;
  @override
  Widget build(BuildContext context) {
    HomeScreenController homeScreenController =
        Provider.of<HomeScreenController>(context, listen: false);
    ProScreenController proScreenController =
        Provider.of<ProScreenController>(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(43, 46, 50, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(43, 46, 50, 1),
          elevation: 0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'PDF Stamp & Sign',
                  style: CustomTextStyles.primaryText20,
                ),
                const SizedBox(width: 10),
                proScreenController.isUserPro
                    ? Container()
                    : GestureDetector(
                        onTap: _navigateToPremiumScreen,
                        child: ScaleTransition(
                          scale: _animation,
                          child: Image.asset(
                            'assets/crown.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    proScreenController.isUserPro
                        ? Container()
                        : ProBanner(context),
                    const SizedBox(height: 10),
                    const Text(
                      'Tools',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildToolBox(
                            context,
                            'assets/signicon.png', // Custom asset icon
                            'Add signature',
                            onPressed: () {
                              homeScreenController.pickImage(
                                  context, PdfTool.AddSignature);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _buildToolBox(
                                context,
                                'assets/stampicon.png', // Custom asset icon
                                'Add stamp',
                                onPressed: () {
                                  if (Inappservice().isUserPro()) {
                                    homeScreenController.pickImage(
                                        context, PdfTool.AddStamp);
                                  } else {
                                    context.push(PremiumScreen());
                                  }
                                },
                              ),
                              proScreenController.isUserPro
                                  ? Container()
                                  : GestureDetector(
                                      onTap: _navigateToPremiumScreen,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset(
                                          'assets/crown.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              _buildToolBox(
                                context,
                                'assets/pdficon.png', // Custom asset icon
                                'Image to PDF',
                                onPressed: () {
                                  if (Inappservice().isUserPro()) {
                                    homeScreenController.pickImage(
                                        context, PdfTool.ImageToPDF);
                                  } else {
                                    context.push(PremiumScreen());
                                  }
                                },
                              ),
                              proScreenController.isUserPro
                                  ? Container()
                                  : GestureDetector(
                                      onTap: _navigateToPremiumScreen,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset(
                                          'assets/crown.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: AppColors.primarybgColor,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * .30,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Files',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Expanded(
                            child: FutureBuilder<Object>(
                                future: files,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/noFiles.png',
                                              width: 140,
                                              height: 140,
                                            ),
                                            const Text(
                                              'No File Found',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/noFiles.png',
                                              width: 140,
                                              height: 140,
                                            ),
                                            const Text(
                                              'No File Found',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return GridView.builder(
                                        itemCount: snapshot.data!.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1 / 1,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                        itemBuilder: (context, index) {
                                          final file = snapshot.data![index]
                                              as FileSystemEntity;
                                          final stat =
                                              FileStat.statSync(file.path);
                                          String time =
                                              DateFormat('dd MMMM yyyy')
                                                  .format(stat.modified);
                                          File _file = File(file.path);
                                          String fileSize =
                                              (_file.lengthSync() / 1000)
                                                  .toStringAsFixed(0);

                                          String fileExt =
                                              file.path.split('.').last;
                                          return GestureDetector(
                                            onTap: () async {
                                              try {
                                                if (fileExt == 'pdf' ||
                                                    fileExt == 'PDF') {
                                                  OpenResult openResult =
                                                      await OpenFilex.open(
                                                    file.path,
                                                    type: 'application/pdf',
                                                  );
                                                }
                                                if (fileExt == 'png' ||
                                                    fileExt == 'PNG') {
                                                  OpenResult openResult =
                                                      await OpenFilex.open(
                                                    file.path,
                                                    type: 'image/png',
                                                  );
                                                  print(openResult.message);
                                                }
                                              } catch (e) {
                                                print(e);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    AppColors.secondaryBgColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  fileExt == 'PDF' ||
                                                          fileExt == 'pdf'
                                                      ? Image.asset(
                                                          'assets/pdficon1.png',
                                                          width: 60,
                                                          height: 60,
                                                        )
                                                      : Image.asset(
                                                          'assets/pngsaveicon.png',
                                                          width: 60,
                                                          height: 60,
                                                        ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    file.path.split('/').last,
                                                    style: CustomTextStyles
                                                        .primaryText16
                                                        .copyWith(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                }),
                          )

                          // _buildRecentFilesSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            homeScreenController.pickImage(context, PdfTool.General);
          },
          backgroundColor: const Color.fromRGBO(238, 76, 76, 1),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  GestureDetector ProBanner(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _navigateToPremiumScreen,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF65050),
              Colors.red.shade800,
              // Color.fromARGB(255, 255, 163, 109),
            ],
            // stops: [2, 1, 3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: size.width * .10,
              margin: EdgeInsets.only(top: 10),
              child: SvgPicture.asset(
                'assets/proBannerStars.svg',
                width: 25,
                height: 25,
              ),
            ),
            SizedBox(
              width: size.width * .60,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      'Upgrade to Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Unlimited access to all the premium features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'intern',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width * .10,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(.22),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBox(BuildContext context, String assetPath, String label,
      {required Function() onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            // width: 100,
            // height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(33, 35, 38, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                margin: EdgeInsets.all(30),
                child: Image.asset(
                  assetPath,
                  // width: 50,
                  // height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentFilesSection() {
    if (_recentFiles.isEmpty) {
      return Column(
        children: [
          Center(
            child: Image.asset(
              'assets/searchicon.png',
              width: 80,
              height: 80,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No recent files',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // Prevent scrolling inside GridView
        itemCount: _recentFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Show the image in a dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      child: Image.file(
                        _recentFiles[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              );
            },
            child: Image.file(
              _recentFiles[index],
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }
}
