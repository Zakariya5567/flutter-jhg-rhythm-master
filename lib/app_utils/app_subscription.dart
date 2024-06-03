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
    ? 'ca-app-pub-8243857750402094/5169233790'
    : 'ca-app-pub-8243857750402094/5635690548';

String get interstitialAdId => kIsWeb
    ? ''
    : Platform.isAndroid
    ? 'ca-app-pub-8243857750402094/4586332752'
    : 'ca-app-pub-8243857750402094/8916907116';

List<String> getFeaturesList() =>
    ["Feature1,Feature2,Feature3,Feature4,Feature5"];
