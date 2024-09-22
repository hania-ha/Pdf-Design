import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/CustomWidgets/shimmer_animation.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isMonthlyPlanSelected = true;
  bool isYearlyPlanSelected = false;

  @override
  Widget build(BuildContext context) {
    ProScreenController controller = Provider.of<ProScreenController>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(43, 46, 50, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 46, 50, 1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: 'Upgrade to '),
              TextSpan(
                text: 'PRO',
                style: TextStyle(
                  color: Colors.red.shade900,
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
              SizedBox(height: 20),

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
                  width: 350,
                  height: 120,
                  child: const Center(
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

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.redAccent),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.edit, color: Colors.lightBlue),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.scanner, color: Colors.yellowAccent),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.image, color: Colors.blueGrey),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.block, color: Colors.red),
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

              const SizedBox(height: 5),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  color: Color.fromRGBO(33, 35, 38, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Choose Plan',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
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
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: 500, // Prevent overflow
                                ),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(66, 69, 73, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isMonthlyPlanSelected),
                                        SizedBox(width: 10),
                                        Text(
                                          'Monthly plan',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Adjust space to prevent overflow
                                    Flexible(
                                      child: Text(
                                        controller.subscriptionItems.isEmpty
                                            ? '0.00/mo'
                                            : '${controller.subscriptionItems[0].priceString}}/mo',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Prevent text overflow
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
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxWidth: 500, // Prevent overflow
                                ),
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(66, 69, 73, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isYearlyPlanSelected),
                                        SizedBox(width: 10),
                                        Text(
                                          'Yearly plan',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Adjust space to prevent overflow
                                    Flexible(
                                      child: Text(
                                        controller.subscriptionItems.isEmpty
                                            ? '0.00/yr'
                                            : '\$ ${controller.subscriptionItems[1].priceString}/yr',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Prevent text overflow
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

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Shimmer(
                    duration: const Duration(milliseconds: 3500),
                    interval: const Duration(milliseconds: 100),
                    color: Colors.white,
                    colorOpacity: 0.8,
                    enabled: true,
                    direction: const ShimmerDirection.fromLTRB(),
                    child: SizedBox(
                      width: size.width * .50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isMonthlyPlanSelected) {
                            controller.buyProduct(
                                context, controller.subscriptionItems[0]);
                          }
                          if (isYearlyPlanSelected) {
                            controller.buyProduct(
                                context, controller.subscriptionItems[1]);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(238, 76, 76, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Center(
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
                  ),
                ),
              ),
              SizedBox(height: 17),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
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
              SizedBox(height: 30),

              // Footer section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Restore Purchase',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
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
      child: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 20,
            )
          : null,
    );
  }
}
