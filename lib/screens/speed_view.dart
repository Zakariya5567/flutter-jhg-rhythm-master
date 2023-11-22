import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import '../utils/images.dart';
import '../widgets/add_add_subtract_button.dart';
import '../widgets/custom_slider_track_shape.dart';
import '../widgets/heading.dart';

class SpeedView extends StatefulWidget {
  const SpeedView({super.key});

  @override
  State<SpeedView> createState() => _SpeedViewState();
}

class _SpeedViewState extends State<SpeedView> with TickerProviderStateMixin {
  @override
  void initState() {
    final speedProvider = Provider.of<SpeedProvider>(context, listen: false);
    super.initState();
  }

  SpeedProvider? speedProvider;

  @override
  void didChangeDependencies() {
    speedProvider = Provider.of<SpeedProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    speedProvider!.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer<SpeedProvider>(builder: (context, controller, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SPACER
            SizedBox(height: height * 0.05),
            // STARTING TEMPO
            Heading(
                title: AppConstant.startingTempo,
                numbers: controller.startTempo.toStringAsFixed(0)),
            // SPACER
            SizedBox(height: height * 0.015),
            // STARTING SLIDER
            SliderTheme(
              data: SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: height * 0.016,
                ),
                overlayShape: SliderComponentShape.noOverlay,
                trackHeight: height * 0.008,
                trackShape: const CustomSliderTrackShape(),
              ),
              child: Slider(
                  activeColor: AppColors.whitePrimary,
                  inactiveColor: AppColors.whitePrimary,
                  thumbColor: AppColors.whitePrimary,
                  min: controller.startTempoMin,
                  max: controller.startTempoMax,
                  value: controller.startTempo,
                  onChanged: (values) {
                    controller.setStartTempo(values);
                  }),
            ),
            // SPACER
            SizedBox(height: height * 0.025),
            // TARGET TEMPO
            Heading(
                title: AppConstant.targetTempo,
                numbers: controller.targetTempo.toStringAsFixed(0)),
            // SPACER
            SizedBox(height: height * 0.020),
            // TARGET SLIDER
            SliderTheme(
              data: SliderThemeData(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: height * 0.016,
                ),
                overlayShape: SliderComponentShape.noOverlay,
                trackHeight: height * 0.008,
                trackShape: const CustomSliderTrackShape(),
              ),
              child: Slider(
                  activeColor: AppColors.whitePrimary,
                  thumbColor: AppColors.whitePrimary,
                  min: controller.targetTempoMin,
                  max: controller.targetTempoMax,
                  value: controller.targetTempo,
                  onChanged: (values) {
                    controller.setTargetTempo(values);
                  }),
            ),
            // SPACER
            SizedBox(height: height * 0.045),
            // BARS AND INTERVAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BARS DROPDOWN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppConstant.bars,style: TextStyle(
                        fontFamily: AppConstant.sansFont,
                        color: AppColors.whiteLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),),
                      SizedBox(height: height * 0.015),
                      Container(
                        height: height * 0.065,
                        width: width * .34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.greyPrimary,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<int>(
                              menuMaxHeight: height * 0.40,
                              isExpanded: true,
                              isDense: true,
                              value: controller.bar,
                              padding: EdgeInsets.zero,
                              underline: Container(),
                              borderRadius: BorderRadius.circular(20),
                              dropdownColor: AppColors.greyPrimary,
                              icon: Image.asset(Images.arrowDown,
                                  width: width * 0.09,
                                  height: width * 0.09,
                                  color: AppColors.whiteSecondary),
                              onChanged: (value) {
                                controller.setBar(value!);
                              },
                              items: [
                                for (int i = controller.minBar; i <= controller.maxBar ; i++)
                                  DropdownMenuItem<int>(
                                    value: i,
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
                                          i.toString(),
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
                        ),
                      ),
                    ],
                  ),
                  // INTERVAL DROPDOWN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppConstant.interval,style: TextStyle(
                        fontFamily: AppConstant.sansFont,
                        color: AppColors.whiteLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),),
                      SizedBox(height: height * 0.015),
                      Container(
                        height: height * 0.065,
                        width: width * .34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.greyPrimary,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<int>(
                              menuMaxHeight: height * 0.40,
                              isExpanded: true,
                              isDense: true,
                              value: controller.interval,
                              padding: EdgeInsets.zero,
                              underline: Container(),
                              borderRadius: BorderRadius.circular(20),
                              dropdownColor: AppColors.greyPrimary,
                              icon: Image.asset(Images.arrowDown,
                                  width: width * 0.09,
                                  height: width * 0.09,
                                  color: AppColors.whiteSecondary),
                              onChanged: (value) {
                                controller.setInterval(value!);
                              },
                              items: [
                                for (int i = controller.minInterval; i <= controller.maxInterval ; i++)
                                  DropdownMenuItem<int>(
                                    value: i,
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
                                          i.toString(),
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // BPM VALUE SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstant.bpm,
                  style: TextStyle(
                    fontFamily: AppConstant.sansFont,
                    color: AppColors.whiteSecondary,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller.bpm == null
                      ? AppConstant.bpmNull
                      : controller.bpm.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: AppConstant.sansFont,
                    color: AppColors.whiteSecondary,
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // SPACER
            SizedBox(height: height * 0.020),
            // Reset and play pause BUTTON
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.050,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reset
                  GestureDetector(
                    onTap: () {
                      controller.clearSpeedTrainer();
                    },
                    child: Container(
                      height: height * 0.045,
                      width: height * 0.045,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        Images.iconReset,
                        color: AppColors.whitePrimary,
                      ),
                    ),
                  ),

                  // Play pause
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        controller.startStop();
                      },
                      child: Container(
                        height: height * 0.10,
                        width: height * 0.10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.redPrimary,
                        ),
                        child: Center(
                          child: Container(
                            height: height * 0.10,
                            width: height * 0.10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.redPrimary,
                            ),
                            child: Center(
                                child: controller.isPlaying == true
                                    ? Icon(
                                        Icons.pause,
                                        color: AppColors.whitePrimary,
                                        size: height * 0.066,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        color: AppColors.whitePrimary,
                                        size: height * 0.083,
                                      )),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Spacer
                  SizedBox(
                    height: height * 0.02,
                    width: height * 0.02,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      );
    });
  }
}
