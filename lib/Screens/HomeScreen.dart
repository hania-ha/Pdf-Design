import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/utils/AppStyles.dart';
import 'package:pdf_editor/utils/enums.dart';
import 'package:provider/provider.dart';
import 'PdfEditorScreen.dart';
import 'PremiumScreen.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  proScreenController.isUserPro
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade800,
                                Colors.red.shade400
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: SvgPicture.asset(
                                      'assets/proBannerStars.svg',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upgrade to Premium',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Unlimited access to all the premium\nfeatures',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'intern',
                                    ),
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withOpacity(.22),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                                homeScreenController.pickImage(
                                    context, PdfTool.AddStamp);
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
                                homeScreenController.pickImage(
                                    context, PdfTool.ImageToPDF);
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
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      color: Color.fromRGBO(33, 35, 38, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
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
                            _buildRecentFilesSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(43, 46, 50, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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

  Widget _buildToolBox(BuildContext context, String assetPath, String label,
      {required Function() onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(33, 35, 38, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
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
