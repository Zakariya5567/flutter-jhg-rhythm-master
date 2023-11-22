import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  // initial values tab page
  // 0 for Metronome | 1 for Tap Tempo | 2 for Speed Trainer
  int selectedButton = 0;

  /// Set button value base on selection
  ///
  /// Base on this value we will show the screen
  ///
  /// 0 for Metronome | 1 for Tap Tempo | 2 for Speed Trainer
  void changeTab(int newSelectedButton) {
    selectedButton = newSelectedButton;
    notifyListeners();
  }
}
