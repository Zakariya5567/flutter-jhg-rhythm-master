import 'package:flutter/material.dart';

extension StringExtension on String {
  Widget toText(
          {Color? color,
          double? fontSize,
          String? fontFamily,
          int? maxLine,
          TextAlign? textAlign,
          TextOverflow? overflow,
          FontWeight? fontWeight,
          Color? backgroundColor,
          double? lineHeight, double? letterSpacing,}) =>
      Text(
        this,
        maxLines: maxLine ?? maxLine,
        textAlign: textAlign ?? textAlign,
        style: TextStyle(
          height: lineHeight,
          letterSpacing: letterSpacing,
          backgroundColor: backgroundColor ?? backgroundColor,
          color: color ?? Colors.black,
          fontSize: fontSize ?? 12,
          fontFamily: fontFamily,
          overflow: overflow ?? TextOverflow.ellipsis,
          fontWeight: fontWeight ?? FontWeight.w300),
      );
}
