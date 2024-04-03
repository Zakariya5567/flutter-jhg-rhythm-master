import 'package:flutter/material.dart';

import '../../app_utils/dimension.dart';


extension IntExtension on double {

  Widget get height => SizedBox(height: widgetHeight(toDouble()));

  Widget get width => SizedBox(width: widgetWidth(toDouble()));

  // Extension use for height and width of the widget

  double get h => widgetHeight(toDouble());

  double get w => widgetWidth(toDouble());
}
