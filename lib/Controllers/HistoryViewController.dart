import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HistoryViewController with ChangeNotifier {
  Future<List<FileSystemEntity>> getFilesInDirectory() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    Directory pdfDir = Directory("${appDir.path}/PDFFiles");

    return pdfDir
        .listSync(); // Returns a list of FileSystemEntity (files & directories)
  }
}
