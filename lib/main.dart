import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:pdf_editor/app.dart';
import 'package:pdf_editor/services/InAppService.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesHelper.init();
  Inappservice().initializePurchase();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}
