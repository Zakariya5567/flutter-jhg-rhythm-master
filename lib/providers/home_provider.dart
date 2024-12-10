import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/main.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/services/local_db.dart';
import 'package:universal_html/html.dart';

class HomeProvider extends ChangeNotifier {
  // disable the web when active status is false
  var userNameWeb = 'DefaultUserName';
  var isActive = true;
  bool? isAudioDownloading = true;
  setDownloadingStatus(bool status,TickerProviderStateMixin ticker) {
    isAudioDownloading = status;
    final MetroProvider metroProvider = Provider.of(navKey.currentContext!,listen: false);
    metroProvider.initializeAnimationController(ticker);
    notifyListeners();
  }

  // initial values tab page
  // 0 for Metronome | 1 for Tap Tempo | 2 for Speed Trainer
  int selectedButton = 0;

  bool? isFirstTimeOpen;

  /// Initial crucial saved value for this provider.
  initialize() async {
    isFirstTimeOpen = await SharedPref.getIsFirstTimeOpenApp ?? true;
  }

  /// Set button value base on selection
  ///
  /// Base on this value we will show the screen
  ///
  /// 0 for Metronome | 1 for Tap Tempo | 2 for Speed Trainer
  void changeTab(int newSelectedButton) {
    selectedButton = newSelectedButton;
    notifyListeners();
  }

  /// This function set the [isFirstTimeOpen] to false.
  ///
  ///
  /// isFirstTimeOpen will trigger tooltips to open when the app is
  /// determined to be the first time used.
  setToNotFirstTimeOpenApp() async {
    isFirstTimeOpen = false;
    await SharedPref.setIsFirstTimeOpenApp(false);
    notifyListeners();
  }

  void getUserNameFromRL() async {
    try {
      var uri = Uri.parse(window.location.href);
      userNameWeb = uri.queryParameters['username'].toString();
      isActive = bool.parse(uri.queryParameters['active'].toString());
      notifyListeners();
    } on Exception {}
  }
}
