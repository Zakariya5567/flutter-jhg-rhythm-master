import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/utils/images.dart';

import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';
import '../widgets/custom_slider_track_shape.dart';

class MetroView extends StatefulWidget {
  const MetroView({super.key});

  @override
  State<MetroView> createState() => _MetroViewState();
}

class _MetroViewState extends State<MetroView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final metroProvider = Provider.of<MetroProvider>(context, listen: false);
    metroProvider.initializeAnimationController(this);
  }

  MetroProvider? metroProvider;

  @override
  void didChangeDependencies() {
    metroProvider = Provider.of<MetroProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    metroProvider!.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //final metroWidth = width * 0.60 > 300 ? 300.0 : width * 0.60;
    final metroWidth = 240.0;
    return Consumer<MetroProvider>(builder: (context, controller, child) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                //height: height * .7,
                //color: Colors.blue,
                constraints: BoxConstraints(maxWidth: 345, minHeight: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SPACER
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        // Button selection 3/3 ....
                        SizedBox(
                          height: height * 0.35,
                          // width: JHGResponsive.isMobile(context)
                          //     ? width * 0.165
                          //     : JHGResponsive.isMobile(context)
                          //         ? 135
                          //         : width * 0.0805,
                          width: height * 0.08,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              //physics: const NeverScrollableScrollPhysics(),
                              primary: false,
                              itemCount: controller.tapButtonList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    controller.setBeats(this, index);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.02),
                                    child: Container(
                                      height: height * 0.08,
                                      width: height * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            controller.selectedButton == index
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
                        //SizedBox(width: width * 0.03),
                        SizedBox(width: 14),

                        // Metronome
                        Container(
                          alignment: Alignment.center,
                          height: height * 0.40,
                          width: metroWidth,
                          child: Stack(
                            children: [
                              // Metronome
                              SizedBox(
                                height: height * 0.40,
                                width: metroWidth,
                                child: Image.asset(
                                  Images.metronome,
                                  height: height * 0.40,
                                  width: metroWidth,
                                  fit: BoxFit.fill,
                                ),
                              ),

                              // Stalk
                              Positioned(
                                top: height * 0.052,
                                left: 1,
                                right: 1,
                                // right: 20,
                                child: Container(
                                  height: height * 0.23,
                                  width: width * 0.60,
                                  alignment: Alignment.bottomCenter,
                                  child: AnimatedBuilder(
                                    animation: controller.animation!,
                                    builder: (context, child) {
                                      //You can customize the translation and rotation values
                                      double translationValue =
                                          0 * controller.animation!.value;
                                      double rotationValue =
                                          180 * controller.animation!.value;
                                      //

                                      return Transform(
                                        alignment: Alignment.bottomCenter,
                                        transform: Matrix4.identity()
                                          ..translate(translationValue, 0.0)
                                          ..rotateZ(rotationValue * 0.0034533),
                                        // Convert degrees to radians
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: height * 0.40,
                                              width: width * 0.095,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                Images.stalk,
                                                height: height * 0.40,
                                                width: JHGResponsive.isMobile(
                                                        context)
                                                    ? 11
                                                    : 9, // width * 0.020,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            //slider
                                            Positioned(
                                              top: height *
                                                  controller.bpm *
                                                  0.00058,
                                              left: width * 0.002,
                                              right: width * 0.002,
                                              child: Image.asset(
                                                Images.slider,
                                                height: height * 0.045,
                                                width: width * 0.045,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              //Slider wood
                              Positioned(
                                top: height * 0.08,
                                left: width * 0.003,
                                child: Container(
                                  // color: Colors.amber,
                                  height: height * 0.40,
                                  width: metroWidth,
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    Images.metronomeBottom,
                                    height: height * 0.40,
                                    width:
                                        width * 0.42 > 160 ? 160 : width * 0.42,
                                  ),
                                ),
                              ),

                              // Slider up down
                              Positioned(
                                // left: width * 0.270,
                                left: 1,
                                right: 1,
                                top: height * 0.050,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  height: height * 0.21,
                                  width: width * 0.060,
                                  color: Colors.transparent,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Opacity(
                                      opacity: 0,
                                      child: Slider(
                                        divisions: 300,
                                        activeColor: Colors.transparent,
                                        inactiveColor: Colors.transparent,
                                        thumbColor: Colors.transparent,
                                        value: controller.bpm,
                                        min: 1,
                                        max: 300,
                                        onChanged: (value) {
                                          controller.setPosition(value, this);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // SPACER
                    SizedBox(
                      height: height * 0.03,
                    ),

                    //Sound button with arrow down

                    JHGDropDown<SoundModel>(
                      value: controller.soundList[controller.selectedIndex],
                      items: controller.soundList,
                      expandedColor: AppColors.liteWhite,
                      onChanged: (values) async {
                        controller.setSound(
                          ticker: this,
                          name: values!.name.toString(),
                          beat1: values.beat1.toString(),
                          beat2: values.beat2.toString().toString(),
                          index: values.id!,
                        );
                      },
                    ),

                    // SPACER
                    SizedBox(
                      height: height * 0.025,
                    ),

                    // BPM VALUE SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // DECREASE BUTTON
                        GestureDetector(
                          onTap: () {
                            controller.decreaseBpm(this);
                          },
                          onLongPress: () {
                            controller.continuousDecreaseBpm(this);
                          },
                          onLongPressUp: () {
                            if (controller.bpmContinuousTimer != null) {
                              controller.bpmContinuousTimer!.cancel();
                            }
                          },
                          onLongPressCancel: () {
                            if (controller.bpmContinuousTimer != null) {
                              controller.bpmContinuousTimer!.cancel();
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.redPrimary,
                            ),
                            child: Center(
                                child: Icon(
                              Icons.remove,
                              color: AppColors.whitePrimary,
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
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
                        SizedBox(
                          width: 20,
                        ),
                        // INCREASE BUTTON
                        GestureDetector(
                          onTap: () {
                            controller.increaseBpm(this);
                          },
                          onLongPress: () {
                            controller.continuousIncreaseBpm(this);
                          },
                          onLongPressUp: () {
                            if (controller.bpmContinuousTimer != null) {
                              controller.bpmContinuousTimer!.cancel();
                            }
                          },
                          onLongPressCancel: () {
                            if (controller.bpmContinuousTimer != null) {
                              controller.bpmContinuousTimer!.cancel();
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.redPrimary,
                            ),
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: AppColors.whitePrimary,
                            )),
                          ),
                        ),
                      ],
                    ),

                    // SPACER
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Reset button and play pause button

          JHGAppBar(
            crossAxisAlignment: CrossAxisAlignment.center,
            leadingWidget: JHGResetBtn(
                enabled: true,
                onTap: () {
                  controller.clearMetronome();
                }),
            centerWidget: JHGPlayPauseBtn(onChanged: (val) {
              controller.startStop(this);
            }),
          ),
        ],
      );
    });
  }
}
