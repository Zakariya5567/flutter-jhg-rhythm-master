import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_assets.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/views/widgets/custom_slider_widget.dart';
import '../widgets/custom_selection_bottomsheet.dart';
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
    metroProvider?.init();
    final height = MediaQuery.of(context).size.height;
    final metroWidth = 240.0;
    final metroHeight = 308.0;
    return Consumer<MetroProvider>(builder: (context, controller, child) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                //color: Colors.blue,
                constraints: BoxConstraints(maxWidth: 345, minHeight: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SPACER
                    SizedBox(height: height * 0.025),
                    Row(
                      children: [
                        // Button selection 3/3 ....
                        SizedBox(
                          height: height * 0.41,
                          width: height * 0.08,
                          child: ListView.builder(
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.zero,
                              primary: false,
                              itemCount: controller.tapButtonList.length+1,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    if(index ==  controller.tapButtonList.length){
                                      // controller.clearBottomSheetBeats();
                                      customSelectionBottomSheet(context);
                                    }else{
                                      controller.setBeats(ticker: this, index: index,indexValue: controller.tapButtonList[index]);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.009),
                                    child: Container(
                                      height: height * 0.08,
                                      width: height * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: controller.selectedButton == index ? AppColors.greySecondary : AppColors.greyPrimary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          index ==  controller.tapButtonList.length ? "Custom":
                                          controller.tapButtonList[index],
                                          style: TextStyle(
                                            fontFamily: AppStrings.sansFont,
                                            color: AppColors.whitePrimary,
                                            fontSize:  index ==  controller.tapButtonList.length ? 12 : 18,
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
                          //color: Colors.red,
                          alignment: Alignment.center,
                          height: metroHeight,
                          width: metroWidth,
                          child: Stack(
                            children: [
                              // Metronome
                              SizedBox(
                                height: metroHeight,
                                width: metroWidth,
                                child: Image.asset(
                                  AppAssets.metronome,
                                  height: metroHeight,
                                  width: metroWidth,
                                  fit: BoxFit.fill,
                                ),
                              ),

                              // Stalk
                              Positioned(
                                top: 40,
                                left: 1,
                                right: 1,
                                // right: 20,
                                child: Container(
                                  //color: Colors.yellow,
                                  height: 177,
                                  //width: 100,
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
                                              //color: Colors.green,
                                              height: metroHeight,
                                              width: 37,
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                AppAssets.stalk,
                                                height: metroHeight,
                                                width: JHGResponsive.isMobile(
                                                        context)
                                                    ? 11
                                                    : 9, // width * 0.020,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            //slider
                                            Positioned(
                                              top: 765 *
                                                  controller.bpm *
                                                  0.00058,
                                              left: 1,
                                              right: 1,
                                              child: Image.asset(
                                                AppAssets.slider,
                                                height: 37,
                                                width: 37,
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
                                top: 61.5,
                                left: 2,
                                child: Container(
                                  height: metroHeight,
                                  width: metroWidth,
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    AppAssets.metronomeBottom,
                                    height: metroHeight,
                                    width: 203,
                                  ),
                                ),
                              ),

                              // Slider up down
                              Positioned(
                                left: 1,
                                right: 1,
                                top: 39,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  height: 162,
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

                    SliderWidget(
                      height: height,
                      value: controller.bpm,
                      min: 1,
                      max: 300,
                      onChanged: (value) {
                        controller.setPosition(value, this);
                      },
                    ),

                    // SPACER
                    SizedBox(
                      height: height * 0.015,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            Text(
                              AppStrings.bpm,
                              style: TextStyle(
                                fontFamily: AppStrings.sansFont,
                                color: AppColors.greySecondary,
                                fontSize: 25,
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
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }
}
