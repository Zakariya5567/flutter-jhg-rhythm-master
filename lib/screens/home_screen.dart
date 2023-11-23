import 'package:flutter/material.dart';
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
                body: Stack(
              children: [
                Container(
                  height: height,
                  width: width,
                  color: AppColors.blackPrimary,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.06,
                      bottom: 0,
                      left: width * 0.06,
                      right: width * 0.06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SETTING ICON
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return const SettingScreen();
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.01, right: width * 0.01),
                              child: Icon(
                                Icons.settings,
                                color: AppColors.whiteLight,
                                size: width * 0.07,
                              ),
                            ),
                          ),
                        ),
                        // SPACER
                        SizedBox(
                          height: height * 0.03,
                        ),

                        //BUTTON SELECTION SECTION
                        SizedBox(
                          height: height * 0.05,
                          child: ListView.builder(
                              itemCount: buttonList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    controller.changeTab(index);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02),
                                    child: Container(
                                      height: height * 0.05,
                                      width: width * 0.25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              controller.selectedButton == index
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
                                  ),
                                );
                              }),
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
                                "Quick Tip",
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
                            "You can make quick changes to BPM using the slider, just like a mechanical metronome!",
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
            ));
          });
        });
  }
}
