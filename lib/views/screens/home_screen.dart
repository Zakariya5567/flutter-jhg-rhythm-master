import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_subscription.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/screens/bpm_view.dart';
import 'package:rhythm_master/views/screens/setting_screen.dart';
import 'package:rhythm_master/views/screens/speed_view.dart';

import 'metro_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeProvider homeProvider = HomeProvider();
  JHGInterstitialAd? interstitialAd;
  DateTime? currentBackPressTime;

  // List on buttons, Metronome | Tap Tempo | Speed Trainer
  List<String> buttonList = [
    AppStrings.metronome,
    AppStrings.tapTempo,
    AppStrings.speedTrainer
  ];
  List<String> buttonsDesc = [
    AppStrings.metronomeDesc,
    AppStrings.tapTempoDesc,
    AppStrings.speedTrainerDesc
  ];

  // Set expiry date when user login to the app
  // we will expire user login after 14 days
  setExpiryDate() async {
    DateTime currentDate = DateTime.now();
    DateTime endDate = currentDate.add(const Duration(days: 14));
    await LocalDB.storeEndDate(endDate.toString());
  }

  @override
  void initState() {
    setExpiryDate();
    super.initState();
    if (!kIsWeb) {
      JHGAdsHelper().initializeConsentManager();
      StringsDownloadService()
          .isStringsDownloaded(context, AppStrings.nameOfApp);
      interstitialAd = JHGInterstitialAd(
        interstitialAdId,
        onAdClosed: (ad) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const SettingScreen();
            },
          ));
        },
      );
      interstitialAd?.loadAd();
    }
    if (kIsWeb) {
      homeProvider.getUserNameFromRL();
    }
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.redPrimary,
        content: Text(
          "Tap back again to exit app",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.whitePrimary,
          ),
        ),
      ));
      return Future.value(false);
    }
    SystemNavigator.pop();
    Future.delayed(const Duration(milliseconds: 300), () {
      exit(0);
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: Provider.of<HomeProvider>(context).initialize(),
        builder: (context, snapshot) {
          return Consumer<HomeProvider>(builder: (context, controller, child) {
            return GestureDetector(
              child: AbsorbPointer(
                absorbing: kIsWeb
                    ? homeProvider.isActive == true
                        ? false
                        : true
                    : false,
                // ignore: deprecated_member_use
                child: WillPopScope(
                  onWillPop: onWillPop,
                  child: Scaffold(
                      backgroundColor: controller.isFirstTimeOpen == true
                          ? Colors.black.withOpacity(.7)
                          : null,
                      body: Stack(
                        children: [
                          JHGBody(
                            bodyAppBar: JHGAppBar(
                              isResponsive: true,
                              autoImplyLeading: false,
                              trailingWidget: JHGSettingsButton(
                                  enabled: true,
                                  onTap: () {
                                    interstitialAd?.showInterstitial(
                                        showAlways: true);
                                  }),
                            ),
                            body: Container(
                              //color: Colors.red,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  kIsWeb ? 0.0.height : 10.0.height,
                                  //  SizedBox(height: 10),
                                  //BUTTON SELECTION SECTION
                                  Container(
                                    //color: Colors.red,
                                    constraints: BoxConstraints(
                                        maxWidth: kIsWeb ? 380.0.w : 375.0.w),
                                    height: height * 0.057,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // itemCount: buttonList.length,
                                        // shrinkWrap: true,
                                        // scrollDirection: Axis.horizontal,
                                        // itemBuilder: (context, index) {
                                        children: List.generate(
                                            buttonList.length, (index) {
                                          return MouseRegion(
                                            child: GestureDetector(
                                              onTap: () async {
                                                controller.changeTab(index);
                                              },
                                              child: Container(
                                                height: height * 0.057,
                                                width:
                                                    kIsWeb ? 120 : width / 3.5,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: controller
                                                                .selectedButton ==
                                                            index
                                                        ? AppColors
                                                            .greySecondary
                                                        : AppColors.greyPrimary,
                                                    border: Border.all(
                                                        color: AppColors
                                                            .greySecondary)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      buttonList[index],
                                                      style: JHGTextStyles
                                                          .labelStyle
                                                          .copyWith(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          // index!=0?
                                                          //     AppUtils.showPopup(
                                                          //         context,
                                                          //         buttonList[index],
                                                          //         buttonsDesc[
                                                          //             index]):

                                                          jHGInfoDialog(
                                                              context: context,
                                                              title: buttonList[
                                                                  index],
                                                              description:
                                                                  buttonsDesc[
                                                                      index]),
                                                      child: Icon(
                                                        Icons
                                                            .info_outline_rounded,
                                                        size: 15.0.w,
                                                        color: JHGColors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            cursor: SystemMouseCursors.click,
                                          );
                                        })),
                                  ),

                                  // ScreenView base on button selection
                                  Expanded(
                                    child: controller.selectedButton == 0
                                        ? const MetroView()
                                        : // Now Metronome is first
                                        controller.selectedButton == 1
                                            ? const BpmView()
                                            : // Now Tap Tempo is second
                                            const SpeedView(),
                                  ) // Speed Trainer remains third
                                ],
                              ),
                            ),
                          ),
                          if (controller.isFirstTimeOpen == true)
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: Colors.black.withOpacity(.4),
                            ),
                          // TOOLTIPS
                          if (controller.isFirstTimeOpen == true)
                            Positioned(
                              top: height * .22,
                              right: width * .06,
                              child: Container(
                                padding: EdgeInsets.all(width * .035),
                                width: width * .7,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: AppColors.whitePrimary,
                                          size: 30,
                                        ),
                                        Text(
                                          AppStrings.tooltipsTitle,
                                          style: JHGTextStyles.lrlabelStyle
                                              .copyWith(
                                                  fontStyle: FontStyle.italic),
                                        ),
                                        InkWell(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            onTap: () {
                                              controller
                                                  .setToNotFirstTimeOpenApp();
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.whitePrimary,
                                              size: 30,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: width * .01,
                                    ),
                                    Text(
                                      AppStrings.tooltipsContent,
                                      style: JHGTextStyles.bodyStyle,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )),
                ),
              ),
              onTap: () {
                if (!homeProvider.isActive) {
                  showToast(
                      context: context,
                      message:
                          "Sorry but you do not have an active subscription",
                      isError: true);
                }
              },
            );
          });
        });
  }
}
