import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rhythm_master/db/local_db.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/providers/metro_provider.dart';
import 'package:rhythm_master/providers/speed_provider.dart';
import 'package:rhythm_master/utils/app_constant.dart';

//The MetroProvider class is responsible for managing the metronome functionality,
// controlling BPM, animation, and sound playback.

class SettingProvider extends ChangeNotifier {


  // Custom value selection
  int beatNumerator = 2;
  int beatDenominator = 2;

  clearBottomSheetBeats(){
    beatNumerator = 2;
    beatDenominator = 2;
    notifyListeners();
  }

  incrementBeatNumerator(){
    if(beatNumerator< 96){
      beatNumerator  = beatNumerator +1;
      notifyListeners();
    }
  }

  decrementBeatNumerator(){
    if(beatNumerator > 2){
      beatNumerator = beatNumerator - 1;
      notifyListeners();
    }}

  incrementBeatDenominator(){
    if(beatDenominator < 64){
      beatDenominator  = beatDenominator + beatDenominator;
      notifyListeners();
    }

  }

  decrementBeatDenominator(){
    if(beatDenominator > 2){
      beatDenominator = beatDenominator - beatDenominator~/2;
      notifyListeners();
    }
  }


  String? metronomeSelectedValue;
  String? speedTrainerSelectedValue;

  setValueOfMetronomeBottomSheet(){
    selectedMetronomeButton = 4;
    String value = "${beatNumerator}/${beatDenominator}";
    metronomeSelectedValue = value;
    notifyListeners();
  }

  setValueOfSpeedTrainerBottomSheet(){
    selectedSpeedTrainerButton = 4;
    String value = "${beatNumerator}/${beatDenominator}";
    speedTrainerSelectedValue = value;
    notifyListeners();
  }




  // initial values of BPM
  double bpm = 120;
  double bpmMin = 1.0;
  double bpmMax = 300.0;


  // List of Beat buttons
  List<String> tapButtonList = ['4/4', '3/4', '6/8','12/8'];

  // List of Speed Trainer Beat buttons
  List<String> tapSpeedTrainerButtonList = ['4/4', '3/4', '6/8', '12/8' ];

  // List of sound list
  List<SoundModel> soundList = [];

  // set sounds to sound list
  setSoundList() {
    soundList.clear();

    soundList.add(SoundModel(
        id: 0,
        name: AppConstant.logic,
        beat1: AppConstant.logic1Sound,
        beat2: AppConstant.logic2Sound));

    soundList.add(SoundModel(
        id: 1,
        name: AppConstant.click,
        beat1: AppConstant.click1Sound,
        beat2: AppConstant.click2Sound));

    soundList.add(SoundModel(
        id: 2,
        name: AppConstant.drumsticks,
        beat1: AppConstant.drumsticks1Sound,
        beat2: AppConstant.drumsticks2Sound));

    soundList.add(SoundModel(
        id: 3,
        name: AppConstant.ping,
        beat1: AppConstant.ping1Sound,
        beat2: AppConstant.ping2Sound));

    soundList.add(SoundModel(
        id: 4,
        name: AppConstant.seiko,
        beat1: AppConstant.seiko1Sound,
        beat2: AppConstant.seiko2Sound));

    soundList.add(SoundModel(
        id: 5,
        name: AppConstant.ableton,
        beat1: AppConstant.ableton1Sound,
        beat2: AppConstant.ableton2Sound));

    soundList.add(SoundModel(
        id: 6,
        name: AppConstant.cubase,
        beat1: AppConstant.cubase1Sound,
        beat2: AppConstant.cubase2Sound));

    soundList.add(SoundModel(
        id: 7,
        name: AppConstant.flStudio,
        beat1: AppConstant.flStudio1Sound,
        beat2: AppConstant.flStudio2Sound));

    soundList.add(SoundModel(
        id: 8,
        name: AppConstant.maschine,
        beat1: AppConstant.maschine1Sound,
        beat2: AppConstant.maschine2Sound));

    soundList.add(SoundModel(
        id: 9,
        name: AppConstant.protoolDefault,
        beat1: AppConstant.protoolsDefault1Sound,
        beat2: AppConstant.protoolsDefault2Sound));

    soundList.add(SoundModel(
        id: 10,
        name: AppConstant.protoolMarimba,
        beat1: AppConstant.protoolsMarimba1Sound,
        beat2: AppConstant.protoolsMarimba2Sound));

    soundList.add(SoundModel(
        id: 11,
        name: AppConstant.reason,
        beat1: AppConstant.reason1Sound,
        beat2: AppConstant.reason2Sound));

    soundList.add(SoundModel(
        id: 12,
        name: AppConstant.sonar,
        beat1: AppConstant.sonar1Sound,
        beat2: AppConstant.sonar2Sound));
  }

  // Initialize  animation controller
  initializeAnimationController() async {
    setSoundList();
    Future.delayed(Duration.zero, () async {

      double? defBPM = await SharedPref.getDefaultBPM;
      int? defSound = await SharedPref.getDefaultSound;
      int? defTiming = await SharedPref.getDefaultTiming;
      int? defSpeedTrainerTiming = await SharedPref.getSpeedTrainerDefaultTiming;

      String? defMetroValue = await SharedPref.getMetronomeDefaultValue;
      String? defSpeedValue = await SharedPref.getSpeedTrainerDefaultValue;

      selectedMetronomeButton = defTiming ?? 0;
      selectedSpeedTrainerButton = defSpeedTrainerTiming ?? 0;

      metronomeSelectedValue = defMetroValue ?? "4/4";
      speedTrainerSelectedValue = defSpeedValue ?? "4/4";

      bpm = defBPM ?? 120;

      selectedIndex = defSound ?? 0;
      soundName = (defSound == null ? AppConstant.logic : soundList[defSound].name)!;
      firstBeat = (defSound == null ? AppConstant.logic1Sound : soundList[defSound].beat1)!;
      secondBeat = (defSound == null ? AppConstant.logic2Sound : soundList[defSound].beat2)!;


      int? defSpeedTrainerSound = await SharedPref.getStoreSpeedTrainerDefaultSound;

      speedTrainerSelectedIndex =  defSpeedTrainerSound ?? 0;
      speedTrainerSoundName = (defSpeedTrainerSound == null ? AppConstant.logic : soundList[defSpeedTrainerSound].name)!;
      speedTrainerFirstBeat = (defSpeedTrainerSound == null ? AppConstant.logic : soundList[defSpeedTrainerSound].beat1)!;
      speedTrainerSecondBeat = (defSpeedTrainerSound == null ? AppConstant.logic : soundList[defSpeedTrainerSound].beat2)!;

      notifyListeners();

    });
  }

  // select Sound index
  int selectedIndex = 0;

  // Set selected sound
  String soundName = AppConstant.logic;
  String firstBeat = AppConstant.logic1Sound;
  String secondBeat = AppConstant.logic2Sound;


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
  String speedTrainerSoundName = AppConstant.logic;
  String speedTrainerFirstBeat = AppConstant.logic1Sound;
  String speedTrainerSecondBeat = AppConstant.logic2Sound;


  setSpeedTrainerSound(
      {required String name,
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
  void increaseBpm() {
    if (bpm < bpmMax) {
      bpm += 1;
    }
    notifyListeners();
  }

  // Decrease BPM
  // Decreasing BPM, resetting total ticks, and notifying listeners
  void decreaseBpm() {
    if (bpm > bpmMin) {
      bpm -= 1;
      if (bpm < 1) {
        bpm = 1;
      }
    }
    notifyListeners();
  }

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

    await SharedPref.storeDefaultBPM(bpm);

    await SharedPref.storeDefaultSound(selectedIndex);

    await SharedPref.storeDefaultTiming(selectedMetronomeButton);

    await SharedPref.storeSpeedTrainerDefaultSound(speedTrainerSelectedIndex);

    await SharedPref.storeSpeedTrainerDefaultTiming(selectedSpeedTrainerButton);

    await SharedPref.storeMetronomeDefaultValue(metronomeSelectedValue!);

    await SharedPref.storeSpeedTrainerDefaultValue(speedTrainerSelectedValue!);

    Provider.of<SpeedProvider>(context,listen: false).setSpeedTrainerDefaultValue();

    Provider.of<MetroProvider>(context,listen: false).setMetronomeDefaultValue();

  }
}
