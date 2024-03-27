import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/views/widgets/custom_slider_widget.dart';
import '../widgets/add_add_subtract_button.dart';
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
    speedProvider.initializeAnimationController();
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
    return Consumer<SpeedProvider>(builder: (context, controller, child) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 345),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SPACER
                    SizedBox(height: height * 0.025),
                    // STARTING TEMPO
                    Heading(
                        title: AppStrings.startingTempo,
                        numbers: controller.startTempo.toStringAsFixed(0)),
                    // SPACER
                    SizedBox(height: height * 0.015),
                    // STARTING SLIDER
                    SliderWidget(
                        height: height,
                        min: controller.startTempoMin,
                        max: controller.startTempoMax,
                        value: controller.startTempo,
                        onChanged: (values) {
                          controller.setStartTempo(values);
                        }),
                    // SPACER
                    SizedBox(height: height * 0.025),
                    // TARGET TEMPO
                    Heading(
                        title: AppStrings.targetTempo,
                        numbers: controller.targetTempo.toStringAsFixed(0)),
                    // SPACER
                    SizedBox(height: height * 0.020),
                    // TARGET SLIDER
                    SliderWidget(
                      height: height,
                      min: controller.targetTempoMin,
                      max: controller.targetTempoMax,
                      value: controller.targetTempo,
                      onChanged: (values) {
                        controller.setTargetTempo(values);
                      },
                    ),

                    // SPACER
                    SizedBox(height: height * 0.045),
                    // BARS
                    AddAndSubtractButton(
                        redButtonSize: 30,
                        title: AppStrings.bars,
                        //greyButtonSize: width * 0.24,
                        greyButtonSize: 95,
                        numbers: controller.bar.toString(),
                        description: AppStrings.howManyBars,
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
                        redButtonSize: 30,
                        title: AppStrings.interval,
                        greyButtonSize: 95,
                        numbers: controller.interval.toString(),
                        description:
                            "${AppStrings.howMuchItShouldIncrease} ${controller.bar} Bars",
                        onAdd: () {
                          controller.increaseInterval();
                        },
                        onSubtract: () {
                          controller.decreaseInterval();
                        }),
                    // SPACER
                    SizedBox(height: height * 0.030),
                    // BPM VALUE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${AppStrings.bpm}: ',
                          style: TextStyle(
                            fontFamily: AppStrings.sansFont,
                            color: AppColors.whiteSecondary,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          controller.bpm == null
                              ? AppStrings.bpmNull
                              : controller.bpm.toStringAsFixed(0),
                          style: TextStyle(
                            fontFamily: AppStrings.sansFont,
                            color: AppColors.whiteSecondary,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // SPACER
                    SizedBox(height: height * 0.020),
                    // Reset and play pause BUTTON
                  ],
                ),
              ),
            ),
          ),
          JHGAppBar(
            crossAxisAlignment: CrossAxisAlignment.center,
            leadingWidget: JHGResetBtn(
                enabled: true,
                onTap: () {
                  controller.clearSpeedTrainer();
                }),
            centerWidget: JHGPlayPauseBtn(
                isPlaying: controller.isPlaying,
                onChanged: (val) {
                  controller.startStop();
                }),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }
}
