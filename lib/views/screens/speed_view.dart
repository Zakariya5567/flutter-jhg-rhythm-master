import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/extension/widget_extension.dart';
import 'package:rhythm_master/views/widgets/custom_slider_widget.dart';
import '../widgets/add_add_subtract_button.dart';
import '../widgets/bpm_value_widget.dart';
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
    speedProvider!.clearSpeedTrainer(false);
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
                    22.0.height,
                    // STARTING TEMPO
                    Heading(
                        title: AppStrings.startingTempo,
                        numbers: controller.startTempo.toStringAsFixed(0)),
                    // SPACER
                    12.0.height,
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
                    18.0.height,
                    // TARGET TEMPO
                    Heading(
                        title: AppStrings.targetTempo,
                        numbers: controller.targetTempo.toStringAsFixed(0)),
                    // SPACER
                    22.0.height,
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
                    32.0.height,
                    // BARS
                    AddAndSubtractButton(
                        redButtonSize: 30,
                        title: AppStrings.bars,
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
                    27.0.height,
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
                    22.0.height,
                    // BPM VALUE SECTION
                    BpmValueWidget(
                        bpmValue:controller.bpm == null
                            ? AppStrings.bpmNull
                            : controller.bpm!.toStringAsFixed(0),).center,
                    20.0.height,
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
                  controller.clearSpeedTrainer(true);
                }),
            centerWidget: JHGPlayPauseBtn(
                isPlaying: controller.isPlaying,
                onChanged: (val) {
                  controller.startStop();
                }),
          ),
          10.0.height,
        ],
      );
    });
  }
}
