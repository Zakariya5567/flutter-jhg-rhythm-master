import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/providers/setting_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/widgets/heading.dart';
import 'package:rhythm_master/views/widgets/setting_custom_bottomsheet.dart';

class SpeedTrainerSetting extends StatelessWidget {
  const SpeedTrainerSetting(
      {super.key, required this.controller, required this.speedController});

  final SettingProvider controller;
  final SpeedProvider speedController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView(
      physics: NeverScrollableScrollPhysics(),
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
                value: soundList[controller.speedTrainerSelectedIndex],
                items: soundList,
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
          context,
          AppStrings.defaultBars,
          speedController.defaultBar,
          onChanged: (value) {
            speedController.onChangedDefaultBar(value);
          },
        ),
        10.0.height,
        defaultWid(
          context,
          AppStrings.defaultInterval,
          speedController.defaultInterval,
          onChanged: (value) {
            speedController.onChangedDefaultInterval(value);
          },
        ),
        10.0.height,
        defaultWid(
          context,
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
        10.0.height
      ],
    );
  }

  Row defaultWid(context, String title, int initialValue,
      {required dynamic Function(int) onChanged}) {
    double width = MediaQuery.of(context).size.width * 0.18;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Heading(
          padding: 0,
          title: title,
          numbers: '',
          fontSize: 14,
          textColor: AppColors.headingColor,
        ),
        JHGValueIncDec(
            txtContainerWidth: width,
            initialValue: initialValue,
            onChanged: onChanged,
            maxValue: 99),
      ],
    );
  }
}
