import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/extension/string_extension.dart';
import 'package:rhythm_master/views/extension/widget_extension.dart';

class AddAndSubtractButton extends StatelessWidget {
   AddAndSubtractButton({
    super.key,
    required this.title,
    required this.numbers,
    this.description,
    required this.onAdd,
    required this.onSubtract,
    this.redButtonSize,
    this.greyButtonSize,
    this.headingSize,
    this.padding,
  });

  final String title;
  String? description;
  final String numbers;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  final double? redButtonSize;
  final double? greyButtonSize;
  final double? headingSize;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 54,
            width: width,
            child:
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppStrings.sansFont,
                    color: AppColors.headingColor,
                    fontSize: headingSize ?? 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                // MINUS BUTTON
                GestureDetector(
                  onTap: (onSubtract),
                  child: Container(
                    height: redButtonSize ?? height * 0.038,
                    width: redButtonSize ?? height * 0.038,
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

                12.0.width,


                Container(
                  height: height * 0.065,
                  width: greyButtonSize ?? width * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.greyPrimary,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    numbers,
                    style: TextStyle(
                      fontFamily: AppStrings.sansFont,
                      color: AppColors.whitePrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                12.0.width,
                //SizedBox(width: 12),
                // PLUS BUTTON

                GestureDetector(
                  onTap: (onAdd),
                  child:
                  Container(
                    height: redButtonSize ?? height * 0.038,
                    width: redButtonSize ?? height * 0.038,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.redPrimary,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.add,
                      color: AppColors.whitePrimary,
                    )),
                  )
                ),
              ],
            ),
          ),
          10.0.height,
          description == null ? SizedBox() :
          description!.toText(
            fontFamily: AppStrings.sansFont,
            color: AppColors.whiteLight,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
