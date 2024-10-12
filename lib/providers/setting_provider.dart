import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/main.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/providers/home_provider.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/services/local_db.dart';

//The MetroProvider class is responsible for managing the metronome functionality,
// controlling BPM, animation, and sound playback.

class SettingProvider extends ChangeNotifier {
  // Custom value selection
  int beatNumerator = 2;
  int beatDenominator = 2;
  double speedDefaultInterval = 1;
  double metronomeDefaultInterval = 1;

  setSpeedTrainerDefaultInterval(double value) {
    speedDefaultInterval = value;
    notifyListeners();
  }

  setSpeedTrainerSInterval(double value) {
    speedDefaultInterval = value;
    notifyListeners();
  }

  setMetronomeDefaultInterval(double value) {
    metronomeDefaultInterval = value;
    notifyListeners();
  }

  clearBottomSheetBeats() {
    beatNumerator = 2;
    beatDenominator = 2;
    setBottomSheetBeatAndNotes();
    notifyListeners();
  }

  resetSettingCustomBottomSheet(){
    beatNumerator = 2;
    beatDenominator = 2;
    notifyListeners();
  }


  incrementBeatNumerator() {
    if (beatNumerator < 96) {
      beatNumerator = beatNumerator + 1;
      notifyListeners();
    }
  }

  decrementBeatNumerator() {
    if (beatNumerator > 2) {
      beatNumerator = beatNumerator - 1;
      notifyListeners();
    }
  }

  incrementBeatDenominator() {
    if (beatDenominator < 64) {
      beatDenominator = beatDenominator + beatDenominator;
      notifyListeners();
    }
  }

  decrementBeatDenominator() {
    if (beatDenominator > 2) {
      beatDenominator = beatDenominator - beatDenominator ~/ 2;
      notifyListeners();
    }
  }

  String? metronomeSelectedValue;
  String? speedTrainerSelectedValue;

  setValueOfMetronomeBottomSheet() {
    selectedMetronomeButton = 4;
    String value = "${beatNumerator}/${beatDenominator}";
    metronomeSelectedValue = value;
    notifyListeners();
  }

  setValueOfSpeedTrainerBottomSheet() {
    selectedSpeedTrainerButton = 4;
    String value = "${beatNumerator}/${beatDenominator}";
    speedTrainerSelectedValue = value;
    notifyListeners();
  }

  // initial values of BPM
  int bpm = 120;
  int bpmMin = 1;
  int bpmMax = 300;

  // List of Beat buttons
  List<String> tapButtonList = ['4/4', '3/4', '6/8', '12/8'];

  // List of Speed Trainer Beat buttons
  List<String> tapSpeedTrainerButtonList = ['4/4', '3/4', '6/8', '12/8'];


  // Initialize  animation controller
  initializeAnimationController() async {
    Future.delayed(Duration.zero, () async {

      double? defBPM = await SharedPref.getDefaultBPM;
      int? defSound = await SharedPref.getDefaultSound;
      int? defTiming = await SharedPref.getDefaultTiming;
      int? defSpeedTrainerTiming = await SharedPref.getSpeedTrainerDefaultTiming;

      String? defMetroValue = await SharedPref.getMetronomeDefaultValue;
      String? defSpeedValue = await SharedPref.getSpeedTrainerDefaultValue;

      double? defMetroInterval = await SharedPref.getMetronomeDefaultInterval;
      double? defSpeedInterval = await SharedPref.getSpeedTrainerDefaultInterval;

      metronomeDefaultInterval = defMetroInterval ?? 1;
      speedDefaultInterval = defSpeedInterval ?? 1;

      selectedMetronomeButton = defTiming ?? 0;
      selectedSpeedTrainerButton = defSpeedTrainerTiming ?? 0;

      metronomeSelectedValue = defMetroValue ?? "4/4";
      speedTrainerSelectedValue = defSpeedValue ?? "4/4";

      bpm = defBPM == null ? 120 : defBPM.toInt();

      selectedIndex = defSound ?? 0;
      soundName = (defSound == null ? AppStrings.logic : soundList[defSound].name)!;
      firstBeat = (defSound == null ? AppStrings.logic1Sound : soundList[defSound].beat1)!;
      secondBeat = (defSound == null ? AppStrings.logic2Sound : soundList[defSound].beat2)!;

      int? defSpeedTrainerSound = await SharedPref.getStoreSpeedTrainerDefaultSound;

      speedTrainerSelectedIndex = defSpeedTrainerSound ?? 0;
      speedTrainerSoundName = (defSpeedTrainerSound == null ? AppStrings.logic : soundList[defSpeedTrainerSound].name)!;
      speedTrainerFirstBeat = (defSpeedTrainerSound == null ? AppStrings.logic : soundList[defSpeedTrainerSound].beat1)!;
      speedTrainerSecondBeat = (defSpeedTrainerSound == null ? AppStrings.logic : soundList[defSpeedTrainerSound].beat2)!;

      notifyListeners();
    });
  }

  setBottomSheetBeatAndNotes(){
    int settingOption = Provider.of<HomeProvider>(navKey.currentContext!,listen: false).selectedButton;
    String? value = settingOption == 0 ? metronomeSelectedValue : speedTrainerSelectedValue;
    List noteBeats = (value??"4/4").trim().split('/');
    beatNumerator = int.tryParse( noteBeats.first)!;
    beatDenominator = int.tryParse( noteBeats.last)!;
    noteBeats;
  }
  // select Sound index
  int selectedIndex = 0;

  // Set selected sound
  String soundName = AppStrings.logic;
  String firstBeat = AppStrings.logic1Sound;
  String secondBeat = AppStrings.logic2Sound;

  // Setting selected sound and notifying listeners
  setSound(
      {required String name,
      required String beat1,
      required beat2,
      required int index}) {
    selectedIndex = index;
    soundName = name;
    firstBeat = beat1;
    secondBeat = beat2;
    notifyListeners();
  }

  // select Sound index
  int speedTrainerSelectedIndex = 0;

  // Set selected sound
  String speedTrainerSoundName = AppStrings.logic;
  String speedTrainerFirstBeat = AppStrings.logic1Sound;
  String speedTrainerSecondBeat = AppStrings.logic2Sound;

  setSpeedTrainerSound({
    required String name,
    required String beat1,
    required beat2,
    required int index,
  }) {
    speedTrainerSelectedIndex = index;
    speedTrainerSoundName = name;
    speedTrainerFirstBeat = beat1;
    speedTrainerSecondBeat = beat2;
    notifyListeners();
  }

  // Increase BPM
  // Increasing BPM, resetting total ticks, and notifying listeners
  // void increaseBpm() {
  //   if (bpm < bpmMax) {
  //     bpm += 1;
  //   }
  //   notifyListeners();
  // }

  void onBpmChanged(newValue) {
    bpm = newValue;
    notifyListeners();
  }

  // Decrease BPM
  // Decreasing BPM, resetting total ticks, and notifying listeners
  // void decreaseBpm() {
  //   if (bpm > bpmMin) {
  //     bpm -= 1;
  //     if (bpm < 1) {
  //       bpm = 1;
  //     }
  //   }
  //   notifyListeners();
  // }

  ///===================================
  // Set beats based on the selected button
  // Setting total beats based on the selected button and notifying listeners

  int selectedMetronomeButton = 0;
  int selectedSpeedTrainerButton = 0;

  setMetronomeBeats(int index, String value) {
    selectedMetronomeButton = index;
    metronomeSelectedValue = value;
    notifyListeners();
  }

  setSpeedTrainerBeats(int index, String value) {
    selectedSpeedTrainerButton = index;
    speedTrainerSelectedValue = value;
    notifyListeners();
  }

  onSave(BuildContext context) async {
    await SharedPref.storeDefaultBPM(bpm.toDouble());

    await SharedPref.storeDefaultSound(selectedIndex);

    await SharedPref.storeDefaultTiming(selectedMetronomeButton);

    await SharedPref.storeSpeedTrainerDefaultSound(speedTrainerSelectedIndex);

    await SharedPref.storeSpeedTrainerDefaultTiming(selectedSpeedTrainerButton);

    await SharedPref.storeMetronomeDefaultValue(metronomeSelectedValue!);

    await SharedPref.storeSpeedTrainerDefaultValue(speedTrainerSelectedValue!);

    await SharedPref.storeSpeedTrainerDefaultInterval(speedDefaultInterval);

    await SharedPref.storeMetronomeDefaultInterval(metronomeDefaultInterval);

    Provider.of<SpeedProvider>(context, listen: false)
        .setSpeedTrainerDefaultValue();

    Provider.of<MetroProvider>(context, listen: false)
        .setMetronomeDefaultValue();
  }
}
