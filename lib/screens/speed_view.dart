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
          mainAxisAlignment: MainAxisAlignment.center,
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
            // BARS
            AddAndSubtractButton(
                title: AppConstant.bars,
                numbers: controller.bar.toString(),
                description: AppConstant.howManyBars,
                onAdd: () {
                  controller.increaseBar();
                },
                onSubtract: () {
                  controller.decreaseBar();
                }),
            // SPACER
            SizedBox(
              height: height * 0.035,
            ),
            // INTERVAL BUTTONS
            AddAndSubtractButton(
                title: AppConstant.interval,
                numbers: controller.interval.toString(),
                description:
                    "${AppConstant.howMuchItShouldIncrease} ${controller.bar} Bars",
                onAdd: () {
                  controller.increaseInterval();
                },
                onSubtract: () {
                  controller.decreaseInterval();
                }),
            // SPACER
            SizedBox(height: height * 0.035),
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
          ],
        ),
      );
    });
  }
}
