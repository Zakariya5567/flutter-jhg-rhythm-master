import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app_strings.dart';

String monthlySubscription() {
  return kIsWeb
      ? 'web'
      : Platform.isAndroid
          ? AppStrings.androidMonthlySubscriptionId
          : AppStrings.iosMonthlySubscriptionId;
}

String yearlySubscription() {
  return kIsWeb
      ? 'web'
      : Platform.isAndroid
          ? AppStrings.androidYearlySubscriptionId
          : AppStrings.iosYearlySubscriptionId;
}