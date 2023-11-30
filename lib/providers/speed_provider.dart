import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import '../db/local_db.dart';
import '../model/sound_model.dart';
import '../utils/app_constant.dart';



//The SpeedProvider class manages the functionality of a speed trainer,
// including BPM, intervals, and audio playback.

class SpeedProvider extends ChangeNotifier{


  // INDICATE SOUND IS PLAYING OR STOP
  bool isPlaying = false;


  // BPM IS BEAT PER MINUTE
  double bpm = 40;


  // TIMER IS  BPM
  Timer? _timer;


  // START TEMPO VALUES
  double startTempo = 100;
  double startTempoMin = 1;
  double startTempoMax = 300;


  // TARGET TEMPO VALUES
  double targetTempo = 180;
  double targetTempoMin = 1;
  double targetTempoMax = 300;

  // INTERVAL VALUES
  // BPM SPEED WILL CHANGE ACCORDING TO INTERVAL
  int interval = 10;
  int minInterval = 1;
  int maxInterval = 120;


  // BAR IS BEAT PER BPM
  int bar = 4;
  int minBar = 1;
  int maxBar = 60;

  int totalBeats = 4;


  final player = AudioPlayer();



  String soundName = AppConstant.logic;
  String firstBeat = AppConstant.logic1Sound;
  String secondBeat = AppConstant.logic2Sound;


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
      int? defSound = await SharedPref.getStoreSpeedTrainerDefaultSound;
      soundName = (defSound == null ? AppConstant.logic : soundList[defSound].name)!;
      firstBeat = (defSound == null ? AppConstant.logic1Sound : soundList[defSound].beat1)!;
      secondBeat = (defSound == null ? AppConstant.logic2Sound : soundList[defSound].beat2)!;
      notifyListeners();
    });
  }



  // TOTAL TICK IS USED TO IDENTIFY BEAT AUDIO
  // TWO TYPE OF AUDIO TICK / TAP
  int totalTick = 0;



  // Clear speed trainer settings
  clearSpeedTrainer(){
    if(_timer != null){
      _timer!.cancel();
    }
    isPlaying = false;
    bpm = 100;
    startTempo = 100;
    targetTempo = 180;
    interval = 10;
    bar = 4;
    totalTick = 0;
    barCounter = 0;
    notifyListeners();
  }

  // SET START TEMPO RANGE OF SLIDER
  setStartTempo(double value,) {
    startTempo = value;
    bpm = startTempo;
    barCounter = 0;
    totalTick = 0;
    firstTime = true;
    notifyListeners();
    if(isPlaying == true){
      setTimer();
    }
  }

  // SET TARGET RANGE OF SLIDER
  setTargetTempo(double value,) {
    targetTempo = value;
    barCounter = 0;
    totalTick = 0;
    firstTime = true;
    notifyListeners();
    if(isPlaying){
      setTimer();
    }

  }

  // INCREASE INTERVAL
  increaseInterval() {

    if(interval<maxInterval){
      interval = interval+1;
      notifyListeners();
      if(isPlaying){
        setTimer();
      }
    }
  }

  // DECREASE INTERVAL
  decreaseInterval() {
    if(interval>minInterval){
      interval = interval-1;
      notifyListeners();
      if(isPlaying){
        setTimer();
      }
    }
  }

  // INCREASE BAR
  increaseBar() {
    if(bar<maxBar){
      bar = bar+1;
      notifyListeners();
      if(isPlaying){
        setTimer();
      }
    }
  }

  // DECREASE BAR
  decreaseBar() {
    if(bar>minBar){
      bar = bar-1;
      notifyListeners();
      if(isPlaying){
        setTimer();
      }
    }
  }

  // START OR STOP AUDIO
  void startStop() {
    totalTick = 0;
    bpm = startTempo;
    barCounter = 0;
    if (isPlaying) {
      if(_timer != null){
        _timer!.cancel();
      }
    } else {
      setTimer();
    }
    isPlaying = !isPlaying;
    notifyListeners();


  }


  // Set timer for BPM
  // Setting or canceling timer based on BPM and target tempo
  setTimer(){
    if(_timer != null){
      _timer!.cancel();
    }
    _timer = Timer.periodic( Duration( milliseconds: (60000 / bpm).round()),
          (Timer timer) async {
        if(targetTempo > bpm){
          await playSound();
        }else{
          _timer!.cancel();
          totalTick = 0;
          barCounter = 0;
          isPlaying = false;
          firstTime = true;
          bpm = targetTempo;
          notifyListeners();
        }

      },
    );
  }


  // Bar counter and first-time flags
  int barCounter = 0;
  bool firstTime = true;

  // Play sound based on the metronome ticks
  Future playSound()async{
    barCounter = barCounter + 1;
    totalTick = totalTick+1;
    if(totalTick == 1){
      bool check = firstTime == true ? barCounter-1 == bar * totalBeats : barCounter == bar * totalBeats;
      if(check == true){
        bpm = bpm + interval;
        barCounter = 0;
        firstTime = false;
        notifyListeners();
        setTimer();
      }

      await player.setAsset(firstBeat);
      await player.play();
    }else{
      if(totalTick<totalBeats){
        await player.setAsset(secondBeat);
        await player.play();
      }else{
        await player.setAsset(secondBeat);
        await player.play();
        totalTick = 0;
      }
    }
  }


  // Dispose controller and reset settings
  disposeController() {
    if(_timer != null){
      _timer!.cancel();
    }
    isPlaying = false;
    bpm = 100;
    startTempo = 100;
    targetTempo = 180;
    interval = 10;
    bar = 4;
    totalTick = 0;
    barCounter = 0;
  }
}