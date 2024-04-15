import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:rhythm_master/app_utils/app_%20colors.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';


class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.title,
    required this.numbers,
    this.textColor,
    this.fontSize,
    this.padding,
    this.fontWeight,
  });

  final String title;
  final String numbers;
  final double? fontSize;
  final Color? textColor;
  final double? padding;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 14), //width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            title,
            style: JHGTextStyles.lrlabelStyle.copyWith(
              color: textColor ?? AppColors.whitePrimary,
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight?? FontWeight.w700,
            ),
          ),
          Text(
            numbers,
            style: JHGTextStyles.labelStyle.copyWith(
              color: AppColors.whitePrimary,
              fontSize: 24
            ),
          ),
        ],
      ),
    );
  }
}
