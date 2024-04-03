import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/views/widgets/beats_number_button.dart';

customSelectionBottomSheet(BuildContext context,TickerProviderStateMixin ticker,){
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context){
       final height =  MediaQuery.sizeOf(context).height;
       final  width =  MediaQuery.sizeOf(context).width;
        return  Consumer<MetroProvider>(
          builder: (context,controller,child) {
            return Container(
              height:  height*0.85,
              width: width,
              decoration: BoxDecoration(
                  color: AppColors.greyPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Center(
                      child: Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                            color: AppColors.whiteTextColor,
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                    Text(
                       "Number of Beats",
                        style: TextStyle(
                        fontFamily: AppStrings.sansFont,
                        color: AppColors.whiteTextColor,
                        fontSize:  18,
                        fontWeight: FontWeight.bold,),),
                    SizedBox(height: 10),
                     Text(
                      "This is the top number and represents how\nmany sounds you will hear between each\naccented note.",
                      style: TextStyle(
                        fontFamily: AppStrings.sansFont,
                        color: AppColors.whiteTextColor,
                        fontSize:  14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                     Center(
                       child:
                       BeatsNumberButton(
                        numbers: controller.beatNumerator.toString(),
                        onAdd: (){
                          controller.incrementBeatNumerator();
                        },
                        onSubtract: (){
                          controller.decrementBeatNumerator();
                        }
                    ),),

                    SizedBox(height: 30),
                    Text(
                      "Note Value",
                      style: TextStyle(
                        fontFamily: AppStrings.sansFont,
                        color: AppColors.whiteTextColor,
                        fontSize:  18,
                        fontWeight: FontWeight.bold,),),
                    SizedBox(height: 10),
                    Text(
                      "This is the bottom number and represents, in\ncombination with the BPM setting how\nquickly the sounds will play.",
                      style: TextStyle(
                        fontFamily: AppStrings.sansFont,
                        color: AppColors.whiteTextColor,
                        fontSize:  14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child:
                      BeatsNumberButton(
                          numbers: controller.beatDenominator.toString(),
                          onAdd: (){
                            controller.incrementBeatDenominator();
                          },
                          onSubtract: (){
                            controller.decrementBeatDenominator();
                          }
                      ),),

                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        "Time Signature",
                        style: TextStyle(
                          fontFamily: AppStrings.sansFont,
                          color: AppColors.whiteSecondary,
                          fontSize:  18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child:
                    Text(
                      "${controller.beatNumerator}/${controller.beatDenominator}",
                      style: TextStyle(
                        fontFamily: AppStrings.sansFont,
                        color: AppColors.whiteSecondary,
                        fontSize:  40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),



                    SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        controller.setValueOfBottomSheet(ticker);
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
                            AppStrings.save,
                            style: TextStyle(
                              fontFamily: AppStrings.sansFont,
                              color: AppColors.whitePrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      });
}