import 'package:flutter/material.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';

class BeatsNumberButton extends StatelessWidget {
  const BeatsNumberButton({super.key,
    required this.numbers,
    required this.onAdd,
    required this.onSubtract,
  });

  final String numbers;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.sizeOf(context).height;
    final  width =  MediaQuery.sizeOf(context).width;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // MINUS BUTTON
        GestureDetector(
          onTap: (onSubtract),
          child: Container(
            height: height * 0.038,
            width:  height * 0.038,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColors.redPrimary,
            ),
            child: Center(
                child: Icon(
                  Icons.remove,
                  color: AppColors.whitePrimary,
                )),
          ),
        ),

        SizedBox(width: 8),

        Container(
          height: height * 0.065,
          width:  width * 0.18,
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

        SizedBox(width: 8),
        // PLUS BUTTON

        GestureDetector(
          onTap: (onAdd),
          child: Container(
            height:  height * 0.038,
            width:  height * 0.038,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
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
    );
  }
}
