import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/screens/bpm_view.dart';
import 'package:rhythm_master/screens/setting_screen.dart';
import 'package:rhythm_master/screens/speed_view.dart';

import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import 'metro_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  HomeProvider homeProvider = HomeProvider();

  // List on buttons, Metronome | Tap Tempo | Speed Trainer
  List<String> buttonList = [
    AppConstant.metronome,
    AppConstant.tapTempo,
    AppConstant.speedTrainer
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
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: Provider.of<HomeProvider>(context).initialize(),
        builder: (context, snapshot) {
          return Consumer<HomeProvider>(builder: (context, controller, child) {
            return Scaffold(
                body: JHGBody(
              bodyAppBar: JHGAppBar(
                autoImplyLeading: false,
                trailingWidget: JHGSettingsButton(
                  enabled: true,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const SettingScreen();
                      },
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SETTING ICON
                      // Align(
                      //     alignment: Alignment.topRight,
                      //     child: GestureDetector(
                      //       onTap: () async {
                      //         Navigator.of(context)
                      //             .push(MaterialPageRoute(builder: (context) {
                      //           return const SettingScreen();
                      //         }));
                      //       },
                      //       child: Container(
                      //         padding: EdgeInsets.only(
                      //             top: height * 0.01, right: width * 0.01),
                      //         child: Container(
                      //           padding: EdgeInsets.all(width * 0.01),
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               color: AppColors.greyPrimary),
                      //           child: Icon(
                      //             Icons.settings,
                      //             color: AppColors.whiteLight,
                      //             size: width * 0.07,
                      //           ),
                      //         ),
                      //       ),
                      //     )),
                      // // SPACER
                      // SizedBox(
                      //   height: height * 0.03,
                      // ),

                      //BUTTON SELECTION SECTION
                      SizedBox(
                        height: height * 0.05,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // itemCount: buttonList.length,
                            // shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            // itemBuilder: (context, index) {
                            children: List.generate(buttonList.length, (index) {
                              return GestureDetector(
                                onTap: () async {
                                  controller.changeTab(index);
                                },
                                child: Container(
                                  height: height * 0.05,
                                  width: width * 0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: controller.selectedButton == index
                                          ? AppColors.greySecondary
                                          : AppColors.greyPrimary,
                                      border: Border.all(
                                          color: AppColors.greySecondary)),
                                  child: Center(
                                    child: Text(
                                      buttonList[index],
                                      style: TextStyle(
                                        fontFamily: AppConstant.sansFont,
                                        color: AppColors.whitePrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),

                      // ScreenView base on button selection
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: JHGResponsive.isMobile(context)
                                  ? 0
                                  : JHGResponsive.isTablet(context)
                                      ? width * 0.2
                                      : width * 0.26),
                          child: controller.selectedButton == 0
                              ? const MetroView()
                              : // Now Metronome is first
                              controller.selectedButton == 1
                                  ? const BpmView()
                                  : // Now Tap Tempo is second
                                  const SpeedView(),
                        ),
                      ) // Speed Trainer remains third
                    ],
                  ),
                  // DIM BACKGROUND
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
                        width: width * .6,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.whitePrimary,
                                  size: width * .05,
                                ),
                                Text(
                                  AppConstant.tooltipsTitle,
                                  style: TextStyle(
                                      fontFamily: AppConstant.sansFont,
                                      color: AppColors.whitePrimary,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                                InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      controller.setToNotFirstTimeOpenApp();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.whitePrimary,
                                      size: width * .05,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: width * .01,
                            ),
                            Text(
                              AppConstant.tooltipsContent,
                              style: TextStyle(
                                  fontFamily: AppConstant.sansFont,
                                  color: AppColors.whitePrimary),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ));
          });
        });
  }
}
