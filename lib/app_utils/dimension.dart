import 'package:flutter/material.dart';

import '../main.dart';

double widgetHeight(double pixels) {
  double height =  MediaQuery.sizeOf(navigatorKey.currentContext!).width;
  return height / (height/ pixels);
}

double widgetWidth(double pixels) {
  double width =  MediaQuery.sizeOf(navigatorKey.currentContext!).width;
  return width / (width / pixels);
}
