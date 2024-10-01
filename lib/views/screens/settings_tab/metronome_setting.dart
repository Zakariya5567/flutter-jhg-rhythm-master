import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';

import '../../../app_utils/app_ colors.dart';
import '../../../app_utils/app_strings.dart';
import '../../../models/sound_model.dart';
import '../../../providers/metro_provider.dart';
import '../../../providers/setting_provider.dart';
import '../../widgets/heading.dart';
import '../../widgets/setting_custom_bottomsheet.dart';

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
                value: soundList[controller.selectedIndex],
                items: soundList,
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
                value: soundList[controller.selectedIndex],
                items: soundList,
                expandedColor: AppColors.liteWhite,
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
                           // controller.setMetronomeBeats(index, controller.tapButtonList[index]);
                          } else {
                            controller.setMetronomeBeats(index, controller.tapButtonList[index]);
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
                                index == controller.tapButtonList.length ? "Custom" : controller.tapButtonList[index],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Heading(
              padding: 0,
              title: AppStrings.sliderInterval,
              numbers: '',
              // numbers: controller.speedDefaultInterval.toStringAsFixed(0),
              fontSize: 14,
              textColor: AppColors.headingColor,
            ),

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