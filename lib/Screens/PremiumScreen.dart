import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/CustomWidgets/shimmer_animation.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math; // import this

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isMonthlyPlanSelected = true;
  bool isYearlyPlanSelected = false;
  Future<bool> checkInternet() async {
    bool isActive = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isActive = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isActive = false;
    }
    return isActive;
  }

  @override
  Widget build(BuildContext context) {
    ProScreenController controller = Provider.of<ProScreenController>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBgColor,
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
        actions: [
          TextButton(
            onPressed: () async {
              bool isConnectedToInternet = await checkInternet();
              if (isConnectedToInternet) {
                if (context.mounted) {
                  // Inappservice().restorePurchases(context);
                  // controller.restorePreviousPurchase(context);
                }
              } else {
                if (context.mounted) {
                  Fluttertoast.showToast(
                    msg: "No Internet Connection",
                    gravity: ToastGravity.CENTER,
                  );
                }
              }
            },
            child: const Text(
              "Restore",
              style: TextStyle(
                color: Color.fromRGBO(47, 168, 255, 1),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
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

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF65050),
                      Colors.red.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 350,
                height: 100,
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/proLeaveIcon.svg'),
                      const Expanded(
                        child: FittedBox(
                          child: Text(
                            ' Get Access to all Unlimited   \nfeatures',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: SvgPicture.asset('assets/proLeaveIcon.svg')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '🎟️  Add Stamp to PDF',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
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
                        // Icon(Icons.edit, color: Colors.lightBlue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '📝  Create & Add Signature',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
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
                        // Icon(Icons.scanner, color: Colors.yellowAccent),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '✨ Scan Unlimited Files',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
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
                        // Icon(Icons.image, color: Colors.blueGrey),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '🔄  Image to PDF Converter',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
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
                        // Icon(Icons.block, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '⛔ Remove Ads',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  color: Color.fromARGB(255, 65, 67, 71),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 92, 97, 102),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isMonthlyPlanSelected
                                        ? Color.fromRGBO(238, 76, 76, 1)
                                        : Color.fromARGB(255, 105, 110, 116),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isMonthlyPlanSelected),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Monthly',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 20,
                                              // width: 50,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.red,
                                              ),
                                              child: const Center(
                                                child: FittedBox(
                                                  child: Text(
                                                    "Basic",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'intern'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                          fontSize: 14,
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
                                constraints: const BoxConstraints(
                                  maxWidth: 500, // Prevent overflow
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 92, 97, 102),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isYearlyPlanSelected
                                        ? Color.fromRGBO(238, 76, 76, 1)
                                        : Color.fromARGB(255, 105, 110, 116),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildCheckbox(isYearlyPlanSelected),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Yearly',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              // height: 20,
                                              // width: 50,

                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),

                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: FittedBox(
                                                  child: Text(
                                                    controller.subscriptionItems
                                                            .isEmpty
                                                        ? "0.00% off"
                                                        : "${controller.calculatePercentageOff(controller.subscriptionItems[0].price, controller.subscriptionItems[1].price, 12)}% off",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'intern',
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                          fontSize: 14,
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
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              isYearlyPlanSelected
                  ? Text(
                      controller.subscriptionItems.isEmpty
                          ? "3 Days Free Trial, Then USD 0.00 per year"
                          : "3 Days Free Trial, Then ${controller.subscriptionItems[1].priceString} per year",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )
                  : Container(),
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
                          try {
                            if (isMonthlyPlanSelected) {
                              controller.buyProduct(
                                  context, controller.subscriptionItems[0]);
                            }
                            if (isYearlyPlanSelected) {
                              controller.buyProduct(
                                  context, controller.subscriptionItems[1]);
                            }
                          } catch (e) {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(238, 76, 76, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              isYearlyPlanSelected
                                  ? "Start for free"
                                  : "Continue",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: isYearlyPlanSelected ? 16 : 18,
                                color: Colors.white,
                              ),
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
                  'No commitment | Cancel Anytime',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Color.fromRGBO(147, 155, 168, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),

              // Footer section
              BottomOptions(
                size: size,
                proScreenController: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return Container(
      height: 20,
      width: 20,
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
              size: 16,
            )
          : null,
    );
  }
}

class BottomOptions extends StatelessWidget {
  BottomOptions(
      {super.key, required this.size, required this.proScreenController});

  final Size size;
  ProScreenController proScreenController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width <= 380 ? 0 : 20,
        left: 20,
        right: 20,
      ),
      padding: MediaQuery.of(context).size.width <= 380
          ? null
          : EdgeInsets.only(left: 5),
      width: size.width,
      height: MediaQuery.of(context).size.width <= 380
          ? size.height * .040
          : size.height * .045,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF616161), width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          )),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                bool isConnectedToInternet = await checkInternet();
                if (isConnectedToInternet) {
                  launchUrl(Uri.parse(AppConsts.TermsAndCondition));
                } else {
                  if (context.mounted) {
                    Fluttertoast.showToast(
                      msg: "No Internet Connection",
                      gravity: ToastGravity.CENTER,
                    );
                  }
                }
              },
              child: const AutoSizeText(
                "Terms of Use",
                textAlign: TextAlign.center,
                maxFontSize: 12,
                minFontSize: 12,
                style: TextStyle(
                  color: Color.fromARGB(255, 167, 165, 165),
                  fontFamily: 'intern',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: Color.fromARGB(255, 167, 165, 165),
            thickness: 0.5,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                context.pop();
              },
              child: const AutoSizeText(
                "Continue for free",
                textAlign: TextAlign.center,
                maxFontSize: 12,
                minFontSize: 12,
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'intern',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const VerticalDivider(
            color: Color.fromARGB(255, 167, 165, 165),
            thickness: 0.5,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                bool isConnectedToInternet = await checkInternet();
                if (isConnectedToInternet) {
                  launchUrl(Uri.parse(AppConsts.PrivacyPolicy));
                } else {
                  if (context.mounted) {
                    Fluttertoast.showToast(
                      msg: "No Internet Connection",
                      gravity: ToastGravity.CENTER,
                    );
                  }
                }
              },
              child: const AutoSizeText(
                "Privacy Policy",
                textAlign: TextAlign.center,
                maxFontSize: 12,
                minFontSize: 12,
                style: TextStyle(
                  color: Color.fromARGB(255, 167, 165, 165),
                  fontFamily: 'intern',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // InkWell(
          //   child: GestureDetector(
          //     onTap: proScreenVC.appStatus == AppStatus.LOADING
          //         ? null
          //         : () async {

          //           },
          //     child: Container(
          //       // width: size.width * .3,
          //       child: AutoSizeText(
          //         "Privacy Policy",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontFamily: SoraFont.soraSemiBold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // InkWell(
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: GestureDetector(

          //       child: Text(
          //         "Terms of Use",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontFamily: SoraFont.soraRegular,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // const VerticalDivider(
          //   color: Colors.white,
          //   thickness: 1,
          // ),
          // Container(
          //   // width: size.width * .2,
          //   child: InkWell(
          //     splashColor: Colors.transparent,

          //     child: Text(
          //       // "Restore Purchase",
          //       "",
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 12,
          //         fontFamily: SoraFont.soraRegular,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<bool> checkInternet() async {
    bool isActive = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isActive = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      isActive = false;
    }
    return isActive;
  }
}
