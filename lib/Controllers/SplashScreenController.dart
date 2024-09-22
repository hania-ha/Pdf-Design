import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SplashScreenController {
  void checkingPreviousPurchase(BuildContext context) async {
    ProScreenController proScreenController =
        Provider.of<ProScreenController>(context, listen: false);
    bool isConnected = await checkInternet();

    if (isConnected) {
      try {
        if (Platform.isAndroid) {
          SharedPreferencesHelper.setBool(
              AppConsts.subscriptionStatuskey, true);

          proScreenController.isUserPro = true;
        } else if (Platform.isIOS) {
          CustomerInfo customerInfo = await Purchases.getCustomerInfo();
          if (customerInfo.activeSubscriptions.isEmpty) {
            SharedPreferencesHelper.setBool(
                AppConsts.subscriptionStatuskey, true);

            proScreenController.isUserPro = true;
          } else {
            if (customerInfo.entitlements.all['premium']!.isActive) {
              proScreenController.isUserPro = true;

              SharedPreferencesHelper.setBool(
                  AppConsts.subscriptionStatuskey, true);
            }
          }
        }
      } catch (err) {
        print(err);
      }
    } else {
      proScreenController.isUserPro =
          SharedPreferencesHelper.getBool(AppConsts.subscriptionStatuskey);
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        gravity: ToastGravity.CENTER,
      );
    }
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
