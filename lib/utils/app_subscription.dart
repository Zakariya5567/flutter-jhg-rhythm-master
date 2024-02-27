import 'dart:io';

import 'package:flutter/foundation.dart';

import 'app_constant.dart';

String monthlySubscription() {
  return kIsWeb
      ? 'web'
      : Platform.isAndroid
          ? AppConstant.androidMonthlySubscriptionId
          : AppConstant.iosMonthlySubscriptionId;
}

String yearlySubscription() {
  return kIsWeb
      ? 'web'
      : Platform.isAndroid
          ? AppConstant.androidYearlySubscriptionId
          : AppConstant.iosYearlySubscriptionId;
}
