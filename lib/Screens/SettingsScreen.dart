import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_editor/Controllers/HomeScreenController.dart';
import 'package:pdf_editor/Controllers/PremiumScreenController.dart';
import 'package:pdf_editor/Screens/PremiumScreen.dart';
import 'package:pdf_editor/extensions.dart/navigatorExtension.dart';
import 'package:pdf_editor/services/sharedPreferenceManager.dart';
import 'package:pdf_editor/utils/AppColors.dart';
import 'package:pdf_editor/utils/AppConsts.dart';
import 'package:pdf_editor/utils/AppStyles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProScreenController controller = Provider.of<ProScreenController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: CustomTextStyles.primaryText20,
        ),
        actions: [],
      ),
      body: ListView(
        children: [
          SettingWidget(
            logoPath: 'assets/privacy.png',
            label: 'Privacy Policy',
            onTapped: () {
              launchUrl(Uri.parse(AppConsts.PrivacyPolicy));
            },
          ),
          SettingWidget(
            logoPath: 'assets/terms.png',
            label: 'Terms of use',
            onTapped: () {
              launchUrl(Uri.parse(AppConsts.TermsAndCondition));
            },
          ),
          SettingWidget(
            logoPath: 'assets/rate.png',
            label: 'Rate us',
            onTapped: () {},
          ),
          controller.isUserPro
              ? Container()
              : SettingWidget(
                  logoPath: 'assets/crown.png',
                  label: 'Upgrade to pro',
                  onTapped: () {
                    context.push(PremiumScreen());
                  },
                ),
        ],
      ),
    );
  }
}

class SettingWidget extends StatelessWidget {
  SettingWidget({
    super.key,
    required this.logoPath,
    required this.label,
    required this.onTapped,
  });
  String logoPath;
  String label;
  Function() onTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarybgColor,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        onTap: onTapped,
        leading: Container(
            margin: EdgeInsets.all(12),
            child: Image.asset(
              logoPath,
            )),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: CustomTextStyles.primaryText16,
          ),
        ),
      ),
    );
  }
}
