import 'package:flutter/material.dart';

import '../db/local_db.dart';

class HomeProvider extends ChangeNotifier {
  // initial values tab page
  // 0 for Metronome | 1 for Tap Tempo | 2 for Speed Trainer
  int selectedButton = 0;

  bool? isFirstTimeOpen ;

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

}
