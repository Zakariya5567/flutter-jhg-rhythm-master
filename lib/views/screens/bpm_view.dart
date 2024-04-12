import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/providers/tap_temp_provider.dart';
import 'package:rhythm_master/views/widgets/bpm_value_widget.dart';

class BpmView extends StatelessWidget {
  const BpmView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<TapTempoProvider>(builder: (context, controller, child) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 345),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SPACER
                    SizedBox(height: height * 0.07),

                    // THIS SONG IS ANDANTE SECTION
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.thisSongIs,
                          style: TextStyle(
                            fontFamily: AppStrings.sansFont,
                            color: AppColors.whiteLight,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          controller.musicName,
                          style: TextStyle(
                            fontFamily: AppStrings.sansFont,
                            color: AppColors.whiteLight,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // SPACER
                    SizedBox(
                      height: height * 0.06,
                    ),

                    // RED  TAP BUTTON
                    JHGIconButton(
                      onTap: () {
                        controller.handleTap();
                      },
                      child: AnimatedScale(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 100),
                        scale: controller.buttonScale,
                        child: Container(
                          height: height * 0.16,
                          width: height * 0.16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.redPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            AppStrings.tap,
                            style: TextStyle(
                              fontFamily: AppStrings.sansFont,
                              color: AppColors.whitePrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //const Spacer(),
                    // SPACER
                    SizedBox(
                      height: height * 0.07,
                    ),
                    JHGResetBtn(
                        enabled: true,
                        onTap: () {
                          controller.clearBPM();
                        }),
                    // SPACER
                    SizedBox(
                      height: height * 0.06,
                    ),
                    // BPM VALUE SECTION
                    BpmValueWidget(
                      bpmValue: controller.bpm == null
                          ? AppStrings.bpmNull
                          : controller.bpm!.toStringAsFixed(0),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
