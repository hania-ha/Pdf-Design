import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';
import 'package:pdf_editor/utils/AppConsts.dart';

abstract class PurchaseCallback {
  void onPurchaseSuccessCallBack(BuildContext context);
}

class ProScreenController with ChangeNotifier implements PurchaseCallback {
  bool _isUserPro = false;

  bool get isUserPro => _isUserPro;

  set isUserPro(bool value) {
    _isUserPro = value;
    notifyListeners();
  }

  void buyProduct(BuildContext ctx) {
    Inappservice().buyProduct(this, ctx);

    // Inappservice()
  }

  @override
  void onPurchaseSuccessCallBack(BuildContext context) {
    // TODO: implement onPurchaseSuccessCallBack
    isUserPro = true;
    SharedPreferencesHelper.setBool(AppConsts.subscriptionStatuskey, true);
    context.pop();
  }
}
