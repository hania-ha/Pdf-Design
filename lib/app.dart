import 'package:flutter/material.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PdfEditorController.dart';
import 'package:pdf_editor/Screens/SplashScreen.dart';
import 'package:pdf_editor/utils/AppStyles.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return HomeScreenController();
        }),
        ChangeNotifierProvider(create: (_) {
          return Pdfeditorcontroller();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: Fonts.intern,
            textTheme: TextTheme()),
        home: SplashScreen(),
      ),
    );
  }
}
