import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Screen1.dart';
import 'Screen2.dart';
import 'SplashScreen.dart';
import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:pdf_editor/app.dart';
import 'PremiumScreen.dart';
import 'SaveScreen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) {
        return const MyApp();
      },
    ),
  );
}
