import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void buyProduct(PurchaseCallback purchaseCallback, BuildContext context,
      StoreProduct product) async {
    //
    try {
      CustomerInfo purchaserInfo =
          await Purchases.purchaseStoreProduct(product);
      if (purchaserInfo.entitlements.all["Pro"]!.isActive) {
        if (context.mounted) {
          purchaseCallback.onPurchaseSuccessCallBack(context);
        }
      } else {}
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        purchaseCallback.onSheetClosed(context);
        // showError(e);
      }
    }
  }

  Future<List<Package>> getProducts() async {
    final customerInfo = await Purchases.getCustomerInfo();
    Offerings offerings = await Purchases.getOfferings();

    return offerings.current!.availablePackages;
    // return products;
  }

  void restorePurchases(
      BuildContext context, PurchaseCallback inAppPaymentCallback) async {
    try {
      CustomerInfo restoredCustomerInfo = await Purchases.restorePurchases();

      if (restoredCustomerInfo.entitlements.all["Pro"]!.isActive) {
        if (context.mounted) {
          inAppPaymentCallback.onPurchaseRestored(context);
        }
      } else {
        if (context.mounted) {
          inAppPaymentCallback.onSubscriptionExpired(context);
        }
      }
    } catch (e) {
      if (e is PlatformException) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode == PurchasesErrorCode.missingReceiptFileError) {
          if (context.mounted) {
            inAppPaymentCallback.onSubscriptionExpired(context);
          }
        }
      }
    }
  }
}
