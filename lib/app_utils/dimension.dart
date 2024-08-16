import 'package:flutter/material.dart';

import '../main.dart';

double widgetHeight(double pixels) {
  double height =  MediaQuery.sizeOf(navKey.currentContext!).width;
  return height / (height/ pixels);
}

double widgetWidth(double pixels) {
  double width =  MediaQuery.sizeOf(navKey.currentContext!).width;
  return width / (width / pixels);
}
