import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_info.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_subscription.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/extension/string_extension.dart';
import 'package:rhythm_master/views/extension/widget_extension.dart';
import 'package:rhythm_master/views/screens/home_screen.dart';
import 'package:rhythm_master/views/widgets/heading.dart';
import 'package:rhythm_master/views/widgets/setting_custom_bottomsheet.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  PackageInfo? packageInfo;
  String deviceName = 'Unknown';
  SpeedProvider? speedController;

  Future<void> initPackageInfo() async {
    packageInfo = await getDeviceInfo();
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: JHGBody(
        bodyAppBar: JHGAppBar(
          title:
              AppStrings.setting.toText(textStyle: JHGTextStyles.smlabelStyle),
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
        body: Consumer2<SettingProvider, HomeProvider>(
            builder: (context, controller, homeProvider, child) {
          return Container(
            width: kIsWeb ? 345 : width,
            color: AppColors.blackPrimary,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 345),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        homeProvider.selectedButton == 0
                            ? MetronomeSetting(controller: controller)
                            : homeProvider.selectedButton == 1
                                ? TapTempoSetting(controller: controller)
                                : SpeedTrainerSetting(
                                    controller: controller,
                                    speedController: speedController!),
                      ],
                    ),
                  ).center.paddingOnly(top: height * 0.02),
                )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 347),
                        padding: EdgeInsets.only(top: 10),
                        color: AppColors.blackPrimary,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: JHGNativeBanner(
                                adID: nativeBannerAdId,
                              ),
                            ),
                            homeProvider.selectedButton == 1
                                ? SizedBox()
                                : JHGPrimaryBtn(
                                    label: AppStrings.save,
                                    onPressed: () async {
                                      await controller.onSave(context);
                                      showToast(
                                          context: context,
                                          message: AppStrings.ableton,
                                          isError: false);
                                      Navigator.pop(context);
                                    }),
                            // InkWell(
                            //     onTap: () async {
                            //       await controller.onSave(context);
                            //       showToast(
                            //           context: context,
                            //           message: AppStrings.ableton,
                            //           isError: false);
                            //       Navigator.pop(context);
                            //     },
                            //     child: Center(
                            //       child: Container(
                            //         height: height * 0.07,
                            //         width: width * 1,
                            //         alignment: Alignment.center,
                            //         decoration: BoxDecoration(
                            //             color: AppColors.redPrimary,
                            //             borderRadius:
                            //                 BorderRadius.circular(10)),
                            //         child: Text(
                            //           AppStrings.save,
                            //           style: JHGTextStyles.labelStyle
                            //               .copyWith(
                            //                   color: AppColors.whitePrimary,
                            //                   fontSize: 17),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
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
                                    appVersion: packageInfo!.version,
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

class MetronomeSetting extends StatelessWidget {
  const MetronomeSetting({super.key, required this.controller});

  final SettingProvider controller;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Heading(
          padding: 0,
          title: AppStrings.metronome,
          numbers: "",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          textColor: AppColors.headingColor,
        ),
        10.0.height,
        Heading(
          padding: 0,
          title: AppStrings.soundS,
          numbers: "",
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        8.0.height,
        Consumer<MetroProvider>(builder: (context, controller, child) {
          return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: JHGDropDown<SoundModel>(
                value: controller.soundList[controller.selectedIndex],
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
              ));
        }),
        10.0.height,
        // DEFAULT BPM
        JHGHeadAndSubHWidget(
          AppStrings.defaultBpm,
          lableStyle: JHGTextStyles.labelStyle,
          // JHGTextStyles.lrlabelStyle
          //     .copyWith(fontSize: 14, color: AppColors.headingColor),
          actions: [
            JHGValueIncDec(
              initialValue: controller.bpm.toInt(),
              onChanged: (newValue) => controller.onBpmChanged(newValue),
              maxValue: controller.bpmMax,
            ),
          ],
        ),
        // // DEFAULT SOUND
        Heading(
          padding: 0,
          title: AppStrings.defaultSound,
          numbers: "",
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        8.0.height,
        //Sound button with arrow down
        Container(
          width: width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.greyPrimary,
          ),
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: JHGDropDown(
                value: controller.soundList[controller.selectedIndex],
                items: controller.soundList,
                onChanged: (values) async {
                  controller.setSound(
                    name: values!.name.toString(),
                    beat1: values.beat1.toString(),
                    beat2: values.beat2.toString().toString(),
                    index: values.id!,
                  );
                },
              )),
        ),
        10.0.height,
        // DEFAULT SOUND
        Heading(
          padding: 0,
          title: AppStrings.defaultTiming,
          numbers: "",
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        8.0.height,
        // Button selection 3/3 ....
        SizedBox(
            height: height * 0.085,
            width: width * 0.85,
            child: ListView.builder(
                itemCount: controller.tapButtonList.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          if (index == controller.tapButtonList.length) {
                            controller.clearBottomSheetBeats();
                            settingCustomBottomSheet(context, true);
                            controller.setMetronomeBeats(
                                index, controller.tapButtonList[index]);
                          } else {
                            controller.setMetronomeBeats(
                                index, controller.tapButtonList[index]);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.025),
                          child: Container(
                            height: height * 0.085,
                            width: height * 0.085,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: controller.selectedMetronomeButton == index
                                  ? AppColors.greySecondary
                                  : AppColors.greyPrimary,
                            ),
                            child: Center(
                              child: Text(
                                index == controller.tapButtonList.length
                                    ? "Custom"
                                    : controller.tapButtonList[index],
                                style: JHGTextStyles.subLabelStyle.copyWith(
                                    color: AppColors.whitePrimary,
                                    fontSize:
                                        index == controller.tapButtonList.length
                                            ? 12
                                            : 18),
                              ),
                            ),
                          ),
                        ),
                      ));
                })),
        15.0.height,
        Row(
          children: [
            Heading(
              padding: 0,
              title: AppStrings.sliderInterval,
              numbers: '',
              // numbers: controller.speedDefaultInterval.toStringAsFixed(0),
              fontSize: 14,
              textColor: AppColors.headingColor,
            ),
            Spacer(),
            //8.0.height,
            JHGValueIncDec(
                initialValue: controller.metronomeDefaultInterval.toInt(),
                onChanged: (value) {
                  controller.setMetronomeDefaultInterval(value.toDouble());
                },
                maxValue: 99),
          ],
        ),
        // 20.0.height,
        // Heading(
        //   padding: 0,
        //   title: AppStrings.sliderInterval,
        //   numbers: controller.metronomeDefaultInterval.toStringAsFixed(0),
        //   fontSize: 14,
        //   textColor: AppColors.headingColor,
        // ),
        // 8.0.height,
        // SliderWidget(
        //     height: height,
        //     min: 1,
        //     max: 99,
        //     value: controller.metronomeDefaultInterval,
        //     onChanged: (value) {
        //       controller.setMetronomeDefaultInterval(value);
        //     }),
        30.0.height,
      ],
    );
  }
}

class SpeedTrainerSetting extends StatelessWidget {
  const SpeedTrainerSetting(
      {super.key, required this.controller, required this.speedController});

  final SettingProvider controller;
  final SpeedProvider speedController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SPEED TRAINER HEADING
        Heading(
          padding: 0,
          title: AppStrings.speedTrainer,
          numbers: "",
          fontSize: 22,
          fontWeight: FontWeight.bold,
          textColor: AppColors.headingColor,
        ),
        10.0.height,
        Heading(
          padding: 0,
          title: AppStrings.defaultSound,
          numbers: "",
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        // SPACER
        8.0.height,
        Container(
          width: width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.greyPrimary,
          ),
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: JHGDropDown(
                value:
                    controller.soundList[controller.speedTrainerSelectedIndex],
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
        ),
        10.0.height,
        // DEFAULT SOUND
        Heading(
          padding: 0,
          title: AppStrings.defaultTiming,
          numbers: "",
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        8.0.height,
        // Button selection 3/3 ....
        SizedBox(
          height: height * 0.085,
          width: width * 0.85,
          child: ListView.builder(
              itemCount: controller.tapSpeedTrainerButtonList.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (index ==
                          controller.tapSpeedTrainerButtonList.length) {
                        controller.clearBottomSheetBeats();
                        settingCustomBottomSheet(context, false);
                      } else {
                        controller.setSpeedTrainerBeats(
                            index, controller.tapSpeedTrainerButtonList[index]);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: width * 0.025),
                      child: Container(
                        height: height * 0.085,
                        width: height * 0.085,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.selectedSpeedTrainerButton == index
                              ? AppColors.greySecondary
                              : AppColors.greyPrimary,
                        ),
                        child: Center(
                          child: Text(
                            index == controller.tapSpeedTrainerButtonList.length
                                ? "Custom"
                                : controller.tapSpeedTrainerButtonList[index],
                            style: JHGTextStyles.subLabelStyle.copyWith(
                              color: AppColors.whitePrimary,
                              fontSize: index ==
                                      controller
                                          .tapSpeedTrainerButtonList.length
                                  ? 12
                                  : 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),

        20.0.height,
        defaultWid(
          AppStrings.defaultBars,
          speedController.defaultBar,
          onChanged: (value) {
            speedController.onChangedDefaultBar(value);
          },
        ),
        20.0.height,
        defaultWid(
          AppStrings.defaultInterval,
          speedController.defaultInterval,
          onChanged: (value) {
            speedController.onChangedDefaultInterval(value);
          },
        ),
        20.0.height,
        defaultWid(
          AppStrings.sliderInterval,
          speedController.sliderInterval.toInt(),
          onChanged: (value) {
            speedController.onChangedSliderInterval(value);
          },
        ),

        //  Heading(
        //               title: AppStrings.startingTempo,
        //               numbers: controller.startTempo.toStringAsFixed(0),
        //               showButtons: true,
        //               addButton: () {
        //                 controller.incrementTempo(
        //                     settingProvider!.speedDefaultInterval.toInt());
        //               },
        //               minusButton: () {
        //                 controller.decrementTempo(
        //                     settingProvider!.speedDefaultInterval.toInt());
        //               },
        //             ),
        180.0.height
      ],
    );
  }

  Row defaultWid(String title, int initialValue,
      {required dynamic Function(int) onChanged}) {
    return Row(
      children: [
        Heading(
          padding: 0,
          title: title,
          numbers: '',
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        Spacer(),
        JHGValueIncDec(
            initialValue: initialValue, onChanged: onChanged, maxValue: 99),
      ],
    );
  }
}

class TapTempoSetting extends StatelessWidget {
  const TapTempoSetting({super.key, required this.controller});

  final SettingProvider controller;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      AppStrings.tapTempoSettingText,
      style: JHGTextStyles.labelStyle
          .copyWith(color: AppColors.whitePrimary, fontSize: 17),
    ).paddingOnly(top: 290.0.h);
  }
}
