import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Screen2.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int _selectedIndex = 0;
  List<File> _recentFiles = [];

  void _onFabClicked() {
    _pickImage();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _recentFiles.add(File(image.path));
      });
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Screen2(imageFile: File(image.path)),
        ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PDF Stamp & Sign',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 33),
                      Image.asset(
                        'assets/crown.png',
                        height: 40,
                        width: 40,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red.shade800, Colors.red.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    height: 120,
                    child: Column(
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
                          'Unlimited access to all features',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child:
                              _buildToolBox(context, Icons.edit, 'Add signature')),
                      SizedBox(width: 16),
                      Expanded(
                          child:
                              _buildToolBox(context, Icons.sign_language_outlined, 'Add stamp')),
                      SizedBox(width: 16),
                      Expanded(
                          child: _buildToolBox(
                              context, Icons.picture_as_pdf, 'Image to PDF')),
                    ],
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Color.fromRGBO(33, 35, 8, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Files',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildRecentFilesSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
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
        onPressed: _onFabClicked,
        backgroundColor: Color.fromRGBO(238, 76, 76, 1),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildToolBox(BuildContext context, IconData icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 35, 8, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
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
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 40,
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
        itemCount: _recentFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image.file(
            _recentFiles[index],
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
