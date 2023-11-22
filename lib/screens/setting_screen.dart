import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/screens/home_screen.dart';
import 'package:rhythm_master/utils/images.dart';
import 'package:rhythm_master/widgets/heading.dart';
import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
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

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
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
      body: Container(
        height: height,
        width: width,
        color: AppColors.blackPrimary,
        child: Consumer<SettingProvider>(builder: (context, controller, child) {
          return Padding(
            padding: EdgeInsets.only(
              top: height * 0.07,
              left: width * 0.08,
              right: width * 0.08,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BACK ICON
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeScreen();
                    }));
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteLight,
                    size: height * 0.03,
                  ),
                ),

                // SPACER
                SizedBox(height: height * 0.05),

                // DEFAULT BPM
                AddAndSubtractButton(
                    padding: 0,
                    title: AppConstant.defaultBpm,
                    numbers: controller.bpm.toStringAsFixed(0),
                    redButtonSize: height * 0.044,
                    greyButtonSize: width * 0.20,
                    description: "",
                    onAdd: () {
                      controller.increaseBpm();
                    },
                    onSubtract: () {
                      controller.decreaseBpm();
                    }),

                // SPACER
                SizedBox(height: height * 0.01),

                // DEFAULT SOUND
                Heading(
                  padding: 0,
                  title: AppConstant.defaultSound,
                  numbers: "",
                  fontSize: 14,
                  textColor: AppColors.whiteLight,
                ),

                // SPACER
                SizedBox(height: height * 0.01),

                //Sound button with arrow down
                Container(
                    height: height * 0.065,
                    width: width * 1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.greyPrimary,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<SoundModel>(
                          menuMaxHeight: height * 0.40,
                          isExpanded: true,
                          isDense: true,
                          value: controller.soundList[controller.selectedIndex],
                          padding: EdgeInsets.zero,
                          underline: Container(),
                          borderRadius: BorderRadius.circular(20),
                          dropdownColor: AppColors.greyPrimary,
                          icon: Image.asset(Images.arrowDown,
                              width: width * 0.09,
                              height: width * 0.09,
                              color: AppColors.whiteSecondary),
                          onChanged: (values) {
                            controller.setSound(
                              name: values!.name.toString(),
                              beat1: values.beat1.toString(),
                              beat2: values.beat2.toString().toString(),
                              index: values.id!,
                            );
                          },
                          items: [
                            for (int i = 0;
                                i < controller.soundList.length;
                                i++)
                              DropdownMenuItem<SoundModel>(
                                value: controller.soundList[i],
                                child: Container(
                                  height: height * 0.065,
                                  width: double.maxFinite,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: AppColors.greyPrimary,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.greySecondary,
                                              width: 0.2))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04),
                                    child: Text(
                                      controller.soundList[i].name.toString(),
                                      style: TextStyle(
                                          color: AppColors.whitePrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppConstant.sansFont),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),

                // SPACER
                SizedBox(
                  height: height * 0.035,
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
                  height: height * 0.020,
                ),

                // Button selection 3/3 ....
                SizedBox(
                  height: height * 0.085,
                  width: width * 0.85,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      itemCount: controller.tapButtonList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            controller.setBeats(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: width * 0.15),
                            child: Container(
                              height: height * 0.085,
                              width: height * 0.085,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: controller.selectedButton == index
                                    ? AppColors.greySecondary
                                    : AppColors.greyPrimary,
                              ),
                              child: Center(
                                child: Text(
                                  controller.tapButtonList[index],
                                  style: TextStyle(
                                    fontFamily: AppConstant.sansFont,
                                    color: AppColors.whitePrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),

                // SPACER
                SizedBox(
                  height: height * 0.24,
                ),

                // SAVE BUTTON

                InkWell(
                  onTap: () {
                    controller.onSave();
                    showToast(
                        context: context,
                        message: "Setting Saved Successfully",
                        isError: false);
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
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // SPACER
                SizedBox(
                  height: height * 0.02,
                ),

                Center(
                  child: TextButton(
                    onPressed: () async {
                      await LocalDB.clearLocalDB();
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Welcome(
                          yearlySubscriptionId:
                              AppConstant.yearlySubscriptionId,
                          monthlySubscriptionId:
                              AppConstant.monthlySubscriptionId,
                          appName: AppConstant.appName,
                          appVersion: packageInfo.version,
                          nextPage: () => const HomeScreen(),
                        );
                      }), (route) => false);
                    },
                    child: Text(
                      AppConstant.logout,
                      style: TextStyle(
                        fontFamily: AppConstant.sansFont,
                        color: AppColors.redPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
