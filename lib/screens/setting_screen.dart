import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/screens/home_screen.dart';
import 'package:rhythm_master/widgets/heading.dart';

import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import '../utils/app_subscription.dart';
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
                  appName: AppConstant.appName,
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
                      left: JHGResponsive.isMobile(context) ? 0 : width * 0.36,
                      right: JHGResponsive.isMobile(context) ? 0 : width * 0.36,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Heading(
                          padding: 0,
                          title: AppConstant.soundS,
                          numbers: "",
                          fontSize: 14,
                          textColor: JHGColors.white,
                        ),
                        const SizedBox(height: 5),
                        Consumer<MetroProvider>(
                            builder: (context, controller, child) {
                          return JHGDropDown<SoundModel>(
                            value:
                                controller.soundList[controller.selectedIndex],
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
                            title: AppConstant.defaultBpm,
                            numbers: controller.bpm.toStringAsFixed(0),
                            redButtonSize: height * 0.044,
                            greyButtonSize: width * 0.24,
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
                          title: AppConstant.defaultSound,
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
                            value:
                                controller.soundList[controller.selectedIndex],
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
                          title: AppConstant.defaultTiming,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: controller.tapButtonList.map((button) {
                              return GestureDetector(
                                onTap: () async {
                                  controller.setBeats(
                                      controller.tapButtonList.indexOf(button));
                                },
                                child: Container(
                                  height: height * 0.085,
                                  width: height * 0.085,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller.selectedButton ==
                                            controller.tapButtonList
                                                .indexOf(button)
                                        ? AppColors.greySecondary
                                        : AppColors.greyPrimary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.tapButtonList[controller
                                          .tapButtonList
                                          .indexOf(button)],
                                      style: TextStyle(
                                        fontFamily: AppConstant.sansFont,
                                        color: AppColors.whitePrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // SPACER
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // SPEED TRAINER HEADING
                        Heading(
                          padding: 0,
                          title: AppConstant.speedTrainerSound,
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
                          title: AppConstant.defaultSpeedTrainerTiming,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: controller.tapSpeedTrainerButtonList
                                .map((button) {
                              return GestureDetector(
                                onTap: () async {
                                  controller.setSpeedTrainerBeats(controller
                                      .tapSpeedTrainerButtonList
                                      .indexOf(button));
                                },
                                child: Container(
                                  height: height * 0.085,
                                  width: height * 0.085,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: controller
                                                .selectedSpeedTrainerButton ==
                                            controller.tapSpeedTrainerButtonList
                                                .indexOf(button)
                                        ? AppColors.greySecondary
                                        : AppColors.greyPrimary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      controller.tapSpeedTrainerButtonList[
                                          controller.tapSpeedTrainerButtonList
                                              .indexOf(button)],
                                      style: TextStyle(
                                        fontFamily: AppConstant.sansFont,
                                        color: AppColors.whitePrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
                Column(
                  children: [
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      color: AppColors.blackPrimary,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.onSave();
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
                                  AppConstant.save,
                                  style: TextStyle(
                                    fontFamily: AppConstant.sansFont,
                                    color: AppColors.whitePrimary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // SPACER
                          // SizedBox(
                          //   height: height * 0.02,
                          // ),
                          JHGSecondaryBtn(
                            label: AppConstant.logout,
                            onPressed: () async {
                              await LocalDB.clearLocalDB();
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return Welcome(
                                  yearlySubscriptionId: yearlySubscription(),
                                  monthlySubscriptionId: monthlySubscription(),
                                  appName: AppConstant.appName,
                                  appVersion: packageInfo.version,
                                  nextPage: () => const HomeScreen(),
                                );
                              }), (route) => false);
                            },
                          ),
                        ],
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
