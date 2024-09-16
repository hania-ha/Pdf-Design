import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Inappservice {
  Future<void> initializePurchase() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;

    configuration = PurchasesConfiguration('appl_VIybvsAFYOKXRnAWGvyPpYSJueI');

    await Purchases.configure(configuration);
  }

  bool isUserPro() {
    return SharedPreferencesHelper.getBool(AppConsts.subscriptionStatuskey);
  }

  void buyProduct(PurchaseCallback purchaseCallback, BuildContext context) {
    purchaseCallback.onPurchaseSuccessCallBack(context);
  }
}
