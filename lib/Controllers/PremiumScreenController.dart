import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class PurchaseCallback {
  void onPurchaseSuccessCallBack(BuildContext context);
  void onPurchaseRestored(BuildContext context);

  void onSubscriptionExpired(BuildContext context);
  void onSheetClosed(BuildContext context);
}

class ProScreenController with ChangeNotifier implements PurchaseCallback {
  final List<String> _ksubscriptionIdentifiers = <String>[
    'com.edit.pdf.send.documents.monthly',
    'com.edit.pdf.send.documents.yearly',
  ];
  double percentageOff = 0.0;
  bool _isUserPro = false;

  bool get isUserPro => _isUserPro;

  set isUserPro(bool value) {
    _isUserPro = value;
    notifyListeners();
  }

  List<StoreProduct> _subscriptionItems = [];

  List<StoreProduct> get subscriptionItems => _subscriptionItems;

  set subscriptionItems(List<StoreProduct> subscriptionItems) {
    _subscriptionItems = subscriptionItems;
    notifyListeners();
  }

  void buyProduct(BuildContext ctx, StoreProduct product) {
    showDialog(
      context: ctx,
      builder: (contex) {
        return const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 10,
        );
      },
    );
    Inappservice().buyProduct(this, ctx, product);
  }

  void getProducts() async {
    subscriptionItems = await Purchases.getProducts(_ksubscriptionIdentifiers);

    subscriptionItems.sort((a, b) {
      int indexA = _ksubscriptionIdentifiers.indexOf(a.identifier);
      int indexB = _ksubscriptionIdentifiers.indexOf(b.identifier);
      return indexA.compareTo(indexB);
    });
  }

  String calculatePercentageOff(
      double defaultMonthPrice, double packagePrice, double multiplier) {
    // Calculate the expected price based on the multiplier (e.g., yearly price)
    double expectedPrice = defaultMonthPrice * multiplier;

    // Calculate the percentage off
    double percentOfExpectedPrice = (packagePrice / expectedPrice) * 100;
    double percentageOff = 100 - percentOfExpectedPrice;

    return percentageOff.toStringAsFixed(0);
  }

  void restorePurchase(BuildContext context) {
    showDialog(
      context: context,
      builder: (contex) {
        return const CupertinoActivityIndicator(
          color: Colors.white,
          radius: 10,
        );
      },
    );

    Inappservice().restorePurchases(context, this);
  }

  @override
  void onPurchaseSuccessCallBack(BuildContext context) {
    // TODO: implement onPurchaseSuccessCallBack
    context.pop();
    isUserPro = true;
    SharedPreferencesHelper.setBool(AppConsts.subscriptionStatuskey, true);
    context.pop();
  }

  @override
  void onPurchaseRestored(BuildContext context) {
    context.pop();
    isUserPro = true;
    SharedPreferencesHelper.setBool(AppConsts.subscriptionStatuskey, true);
    context.pop();
  }

  @override
  void onSubscriptionExpired(BuildContext context) {
    context.pop();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RestoreDialog(context, "Nothing to Restore!");
        });
  }

  @override
  void onSheetClosed(BuildContext context) {
    context.pop();
    // TODO: implement onSheetClosed
  }

  Widget RestoreDialog(
    BuildContext context,
    String text,
  ) {
    return AlertDialog(
      backgroundColor: Color(0xFF212326),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2B2E32),

            //
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
