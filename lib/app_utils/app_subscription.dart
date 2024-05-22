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

String get nativeBannerAdId => kIsWeb
    ? ''
    : Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/2247696110'
    : 'ca-app-pub-3940256099942544/3986624511';

String get interstitialAdId => kIsWeb
    ? ''
    : Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';

List<String> getFeaturesList() =>
    ["Feature1,Feature2,Feature3,Feature4,Feature5"];
