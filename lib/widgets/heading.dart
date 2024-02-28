import 'package:flutter/material.dart';

import '../utils/app_ colors.dart';
import '../utils/app_constant.dart';

class Heading extends StatelessWidget {
  const Heading({
    super.key,
    required this.title,
    required this.numbers,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  final String title;
  final String numbers;
  final double? fontSize;
  final Color? textColor;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 14), //width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppConstant.sansFont,
              color: textColor ?? AppColors.whitePrimary,
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            numbers,
            style: TextStyle(
              fontFamily: AppConstant.sansFont,
              color: AppColors.whitePrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
