import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_subscription.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/views/screens/home_screen.dart';
import 'package:rhythm_master/views/widgets/heading.dart';
import 'package:rhythm_master/views/widgets/setting_custom_bottomsheet.dart';

import '../widgets/add_add_subtract_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  PackageInfo packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
    installerStore: '',
  );

  String deviceName = 'Unknown';
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<void> getDeviceInfo() async {
    if (Platform.isAndroid) {
      final device = await deviceInfoPlugin.androidInfo;
      deviceName = "${device.manufacturer} ${device.model}";
    } else if (Platform.isIOS) {
      final device = await deviceInfoPlugin.iosInfo;
      deviceName = device.name;
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
    await getDeviceInfo();
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    settingProvider.initializeAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: JHGBody(
        bodyAppBar: JHGAppBar(
          trailingWidget: JHGReportAnIssueBtn(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BugReportPage(
                  device: deviceName,
                  appName: AppStrings.appName,
                ),
              ),
            );
          }),
        ),
        body: Consumer<SettingProvider>(builder: (context, controller, child) {
          return Container(
            height: height,
            width: width,
            color: AppColors.blackPrimary,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                    ),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 345),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Heading(
                              padding: 0,
                              title: AppStrings.soundS,
                              numbers: "",
                              fontSize: 14,
                              textColor: JHGColors.white,
                            ),
                            const SizedBox(height: 5),
                            Consumer<MetroProvider>(
                                builder: (context, controller, child) {
                              return JHGDropDown<SoundModel>(
                                value: controller
                                    .soundList[controller.selectedIndex],
                                items: controller.soundList,
                                expandedColor: AppColors.liteWhite,
                                onChanged: (values) async {
                                  controller.setSound(
                                    ticker: null,
                                    name: values!.name.toString(),
                                    beat1: values.beat1.toString(),
                                    beat2: values.beat2.toString().toString(),
                                    index: values.id!,
                                  );
                                },
                              );
                            }),

                            const SizedBox(height: 20),
                            // BACK ICON  WITH REPORT AN ISSUE TEXT BUTTON

                            // DEFAULT BPM
                            AddAndSubtractButton(
                                padding: 0,
                                title: AppStrings.defaultBpm,
                                numbers: controller.bpm.toStringAsFixed(0),
                                redButtonSize: height * 0.044,
                                greyButtonSize: 120,
                                description: null,
                                onAdd: () {
                                  controller.increaseBpm();
                                },
                                onSubtract: () {
                                  controller.decreaseBpm();
                                }),

                            // SPACER
                            // SizedBox(height: 20),

                            // DEFAULT SOUND
                            Heading(
                              padding: 0,
                              title: AppStrings.defaultSound,
                              numbers: "",
                              fontSize: 14,
                              textColor: JHGColors.white,
                            ),

                            // SPACER
                            SizedBox(height: height * 0.01),

                            //Sound button with arrow down
                            Container(
                              width: width * 1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.greyPrimary,
                              ),
                              child: JHGDropDown(
                                value: controller
                                    .soundList[controller.selectedIndex],
                                items: controller.soundList,
                                onChanged: (values) async {
                                  controller.setSound(
                                    name: values!.name.toString(),
                                    beat1: values.beat1.toString(),
                                    beat2: values.beat2.toString().toString(),
                                    index: values.id!,
                                  );
                                },
                              ),
                            ),

                            // SPACER
                            SizedBox(
                              height: height * 0.020,
                            ),

                            // DEFAULT SOUND
                            Heading(
                              padding: 0,
                              title: AppStrings.defaultTiming,
                              numbers: "",
                              fontSize: 14,
                              textColor: AppColors.whiteLight,
                            ),

                            // SPACER
                            SizedBox(
                              height: height * 0.01,
                            ),

                            // Button selection 3/3 ....
                            SizedBox(
                                height: height * 0.085,
                                width: width * 0.85,
                                child: ListView.builder(
                                    itemCount:
                                        controller.tapButtonList.length + 1,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          if (index ==
                                              controller.tapButtonList.length) {
                                            controller.clearBottomSheetBeats();
                                            settingCustomBottomSheet(
                                                context, true);
                                            controller.setMetronomeBeats(
                                                index,
                                                controller
                                                    .tapButtonList[index]);
                                          } else {
                                            controller.setMetronomeBeats(
                                                index,
                                                controller
                                                    .tapButtonList[index]);
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.025),
                                          child: Container(
                                            height: height * 0.085,
                                            width: height * 0.085,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: controller
                                                          .selectedMetronomeButton ==
                                                      index
                                                  ? AppColors.greySecondary
                                                  : AppColors.greyPrimary,
                                            ),
                                            child: Center(
                                              child: Text(
                                                index ==
                                                        controller.tapButtonList
                                                            .length
                                                    ? "Custom"
                                                    : controller
                                                        .tapButtonList[index],
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppStrings.sansFont,
                                                  color: AppColors.whitePrimary,
                                                  fontSize: index ==
                                                          controller
                                                              .tapButtonList
                                                              .length
                                                      ? 12
                                                      : 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                            // SPACER
                            SizedBox(
                              height: height * 0.02,
                            ),
                            // SPEED TRAINER HEADING
                            Heading(
                              padding: 0,
                              title: AppStrings.speedTrainerSound,
                              numbers: "",
                              fontSize: 14,
                              textColor: AppColors.whiteLight,
                            ),
                            // SPACER
                            SizedBox(height: height * 0.01),
                            // SPEED TRAINER DROPDOWN
                            Container(
                                width: width * 1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColors.greyPrimary,
                                ),
                                child: JHGDropDown(
                                  value: controller.soundList[
                                      controller.speedTrainerSelectedIndex],
                                  items: controller.soundList,
                                  onChanged: (values) async {
                                    controller.setSpeedTrainerSound(
                                      name: values!.name.toString(),
                                      beat1: values.beat1.toString(),
                                      beat2: values.beat2.toString().toString(),
                                      index: values.id!,
                                    );
                                  },
                                )),

                            SizedBox(
                              height: height * 0.02,
                            ),

                            // DEFAULT SOUND
                            Heading(
                              padding: 0,
                              title: AppStrings.defaultSpeedTrainerTiming,
                              numbers: "",
                              fontSize: 14,
                              textColor: AppColors.whiteLight,
                            ),

                            SizedBox(
                              height: height * 0.01,
                            ),
                            // Button selection 3/3 ....
                            SizedBox(
                              height: height * 0.085,
                              width: width * 0.85,
                              child: ListView.builder(
                                  itemCount: controller
                                          .tapSpeedTrainerButtonList.length +
                                      1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (index ==
                                            controller.tapSpeedTrainerButtonList
                                                .length) {
                                          controller.clearBottomSheetBeats();
                                          settingCustomBottomSheet(
                                              context, false);
                                        } else {
                                          controller.setSpeedTrainerBeats(
                                              index,
                                              controller
                                                      .tapSpeedTrainerButtonList[
                                                  index]);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: width * 0.025),
                                        child: Container(
                                          height: height * 0.085,
                                          width: height * 0.085,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: controller
                                                        .selectedSpeedTrainerButton ==
                                                    index
                                                ? AppColors.greySecondary
                                                : AppColors.greyPrimary,
                                          ),
                                          child: Center(
                                            child: Text(
                                              index ==
                                                      controller
                                                          .tapSpeedTrainerButtonList
                                                          .length
                                                  ? "Custom"
                                                  : controller
                                                          .tapSpeedTrainerButtonList[
                                                      index],
                                              style: TextStyle(
                                                fontFamily: AppStrings.sansFont,
                                                color: AppColors.whitePrimary,
                                                fontSize: index ==
                                                        controller
                                                            .tapSpeedTrainerButtonList
                                                            .length
                                                    ? 12
                                                    : 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            // SAVE BUTTON
                            // const Spacer(),
                            SizedBox(
                              height: height * 0.23,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 347),
                        padding: EdgeInsets.only(top: 10),
                        color: AppColors.blackPrimary,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await controller.onSave(context);
                                showToast(
                                    context: context,
                                    message: "Setting Saved Successfully",
                                    isError: false);
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Container(
                                  height: height * 0.07,
                                  width: width * 1,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.redPrimary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    AppStrings.save,
                                    style: TextStyle(
                                      fontFamily: AppStrings.sansFont,
                                      color: AppColors.whitePrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            JHGSecondaryBtn(
                              label: AppStrings.logout,
                              onPressed: () async {
                                await LocalDB.clearLocalDB();
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Welcome(
                                    yearlySubscriptionId: yearlySubscription(),
                                    monthlySubscriptionId:
                                        monthlySubscription(),
                                    appName: AppStrings.appName,
                                    appVersion: packageInfo.version,
                                    nextPage: () => const HomeScreen(),
                                    featuresList: [],
                                  );
                                }), (route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
