import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:rhythm_master/views/extension/int_extension.dart';
import 'package:rhythm_master/views/extension/widget_extension.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../providers/setting_provider.dart';

class TapTempoSetting extends StatelessWidget {
  const TapTempoSetting({super.key, required this.controller});

  final SettingProvider controller;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: TextAlign.center,
      AppStrings.tapTempoSettingText,
      style: JHGTextStyles.labelStyle
          .copyWith(color: AppColors.whitePrimary, fontSize: 17),
    ).paddingOnly(top: 0.0.h);
  }
}