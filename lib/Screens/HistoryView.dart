import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/Controllers/HistoryViewController.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppStyles.dart';
import 'package:provider/provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late Future<List<FileSystemEntity>> files;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    files = HistoryViewController().getFilesInDirectory();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'History',
          style: CustomTextStyles.primaryText20,
        ),
        actions: [],
      ),
      body:
          Consumer(builder: (context, HistoryViewController controller, child) {
        return FutureBuilder(
            future: files,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  'No files found',
                  style: CustomTextStyles.primaryText20,
                ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  'No files found',
                  style: CustomTextStyles.primaryText20,
                ));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final file = snapshot.data![index] as FileSystemEntity;
                    final stat = FileStat.statSync(file.path);
                    // DateTime creationDate = stat.
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primarybgColor,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          leading: Icon(Icons.file_copy),
                          title: Text(
                            file.path.split('/').last,
                            style: CustomTextStyles.primaryText16,
                          ),
                          subtitle: Text(
                            "23 Sep 2024 - 24 KB",
                            // file

                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: 'intern',
                            ),
                          ),
                        ),
                      ),
                      // child: Center(
                      //   child: Text(file.toString()),
                      // ),
                    );
                    // return ListTile(
                    //   title:
                    //       Text(file.path.split('/').last), // Display file name
                    // );
                  },
                );
              }
            });
      }),
      // body: ListView.builder(itemBuilder: (context, index) {

      // }),
    );
  }
}
