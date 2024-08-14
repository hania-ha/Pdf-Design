import 'package:flutter/material.dart';

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isMonthlyPlanSelected = false;
  bool isYearlyPlanSelected = false;
  String selectedLink = ''; // Track selected link

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 46, 50, 1),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              TextSpan(text: 'Upgrade to '),
              TextSpan(
                text: 'PRO',
                style: TextStyle(
                  color: Colors.red.shade900, // Dark Red color
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20), // Space between the app bar and the container

              // Center the Gradient Container
              Center(
                child: Container(
                  padding: EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade900, Colors.red.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 350, // Width specified
                  height: 120, // Height specified
                  child: Center(
                    child: Text(
                      'Get Access to all Unlimited features',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30), // Space between the gradient container and the text lines

              // List of Features with Icons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0), // Add padding on left and right
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns items to the start (left)
                  children: [
                    // First Feature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Add Stamp to PDF',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),

                    // Second Feature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.edit, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Create & Add Signature',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),

                    // Third Feature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.scanner, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Scan Unlimited Files',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),

                    // Fourth Feature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.image, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Image to PDF converter',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),

                    // Fifth Feature
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.block, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Remove ads',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5), // Space before the card

              // The card with plan options
              Padding(
                padding: EdgeInsets.all(20.0), // Add padding around the card
                child: Card(
                  color: Color.fromRGBO(33, 35, 38, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(24.0), // Increased padding for more height
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Choose Plan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20, // Increased font size for better visibility
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20), // Increased space for better layout
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMonthlyPlanSelected = true;
                                  isYearlyPlanSelected = false;
                                });
                              },
                              child: Container(
                                width: 350, // Increased width
                                padding: EdgeInsets.all(25), // Increased padding for larger box
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(66, 69, 73, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at both ends
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isMonthlyPlanSelected),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Monthly plan',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 20, // Increased font size for better visibility
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$8.99/mo',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20, // Increased font size for better visibility
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMonthlyPlanSelected = false;
                                  isYearlyPlanSelected = true;
                                });
                              },
                              child: Container(
                                width: 300, // Increased width
                                padding: EdgeInsets.all(30), // Increased padding for larger box
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(66, 69, 73, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at both ends
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isYearlyPlanSelected),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'Yearly plan',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 20, // Increased font size for better visibility
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '\$26.99/mo',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 20, // Increased font size for better visibility
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between the card and the button

              // The continue button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                child: ElevatedButton(
                  onPressed: () {
                    // Add action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(238, 76, 76, 1), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15), // Space before the info text

              // Information Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
                child: Text(
                  'You can cancel your subscription anytime. It stays active until the current billing period remains active.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color.fromRGBO(147, 155, 168, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30), // Space at the bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: isSelected ? Colors.red.shade900 : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? Colors.red.shade900 : Colors.white,
        ),
      ),
    );
  }
}
