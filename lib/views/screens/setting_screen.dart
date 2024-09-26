import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_info.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_subscription.dart';
import 'package:rhythm_master/main.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/views/extension/string_extension.dart';
import 'package:rhythm_master/views/extension/widget_extension.dart';
import 'package:rhythm_master/views/screens/settings_tab/metronome_setting.dart';
import 'package:rhythm_master/views/screens/settings_tab/speed_trainer_setting.dart';
import 'package:rhythm_master/views/screens/settings_tab/tap_tempo_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String deviceName = 'Unknown';
  SpeedProvider? speedController;

  Future<void> initPackageInfo() async {
    deviceName = await getDeviceName();
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    speedController = Provider.of<SpeedProvider>(context, listen: false);

    settingProvider.initializeAnimationController();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return JHGSettings(
      androidAppIdentifier: "",
      iosAppIdentifier: "",
      bodyAppBar: JHGAppBar(
        isResponsive: true,
        title: AppStrings.setting.toText(textStyle: JHGTextStyles.smlabelStyle),
        trailingWidget: kIsWeb
            ? null
            : JHGReportAnIssueBtn(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BugReportScreen(),
                  ),
                );
              }),
      ),
      body: Consumer2<SettingProvider, HomeProvider>(
          builder: (context, controller, homeProvider, child) {
        return Container(
          height: MediaQuery.sizeOf(context).height / 1.4,
          color: AppColors.blackPrimary,
          child:
              Expanded(
                  child: Container(
                    // constraints: BoxConstraints(maxWidth: 345),
                    child:
                        homeProvider.selectedButton == 0
                            ? MetronomeSetting(controller: controller)
                            : homeProvider.selectedButton == 1
                                ? TapTempoSetting(controller: controller)
                                : SpeedTrainerSetting(
                                    controller: controller,
                                    speedController: speedController!),

                  ).center.paddingOnly(top: height * 0.02)),


        );
      }),
      trailing: isFreePlan
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: JHGNativeBanner(
                adID: nativeBannerAdId,
              ),
            )
          : const SizedBox(),
      onTapSave: () async {
        await Provider.of<SettingProvider>(context, listen: false)
            .onSave(context);

        showToast(
            context: context, message: AppStrings.ableton, isError: false);
        Navigator.pop(context);
      },
      onTapLogout: () async {
        await LocalDB.clearLocalDB();
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return WelcomeScreen();
        }), (route) => false);
      },
    );
  }
}
