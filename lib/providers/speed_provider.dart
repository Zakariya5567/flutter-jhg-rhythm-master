import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/services/local_db.dart';

//The SpeedProvider class manages the functionality of a speed trainer,
// including BPM, intervals, and audio playback.

class SpeedProvider extends ChangeNotifier {
  // INDICATE SOUND IS PLAYING OR STOP
  bool isPlaying = false;

  // BPM IS BEAT PER MINUTE
  double bpm = 120;

  // TIMER IS  BPM
  Timer? _timer;

  // START TEMPO VALUES
  double startTempo = 120;
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
  int bar = 2;
  int minBar = 1;
  int maxBar = 60;

  int totalBeats = 4;

  final player = AudioPlayer();

  String soundName = AppStrings.logic;
  String firstBeat = AppStrings.logic1Sound;
  String secondBeat = AppStrings.logic2Sound;

  String? defaultBeatValue;

  double gafInterval = 1;

  // List of sound list
  List<SoundModel> soundList = [];

  // set sounds to sound list
  setSoundList() {
    soundList.clear();

    soundList.add(SoundModel(
        id: 0,
        name: AppStrings.logic,
        beat1: AppStrings.logic1Sound,
        beat2: AppStrings.logic2Sound));

    soundList.add(SoundModel(
        id: 1,
        name: AppStrings.click,
        beat1: AppStrings.click1Sound,
        beat2: AppStrings.click2Sound));

    soundList.add(SoundModel(
        id: 2,
        name: AppStrings.drumsticks,
        beat1: AppStrings.drumsticks1Sound,
        beat2: AppStrings.drumsticks2Sound));

    soundList.add(SoundModel(
        id: 3,
        name: AppStrings.ping,
        beat1: AppStrings.ping1Sound,
        beat2: AppStrings.ping2Sound));

    soundList.add(SoundModel(
        id: 4,
        name: AppStrings.seiko,
        beat1: AppStrings.seiko1Sound,
        beat2: AppStrings.seiko2Sound));

    soundList.add(SoundModel(
        id: 5,
        name: AppStrings.ableton,
        beat1: AppStrings.ableton1Sound,
        beat2: AppStrings.ableton2Sound));

    soundList.add(SoundModel(
        id: 6,
        name: AppStrings.cubase,
        beat1: AppStrings.cubase1Sound,
        beat2: AppStrings.cubase2Sound));

    soundList.add(SoundModel(
        id: 7,
        name: AppStrings.flStudio,
        beat1: AppStrings.flStudio1Sound,
        beat2: AppStrings.flStudio2Sound));

    soundList.add(SoundModel(
        id: 8,
        name: AppStrings.maschine,
        beat1: AppStrings.maschine1Sound,
        beat2: AppStrings.maschine2Sound));

    soundList.add(SoundModel(
        id: 9,
        name: AppStrings.protoolDefault,
        beat1: AppStrings.protoolsDefault1Sound,
        beat2: AppStrings.protoolsDefault2Sound));

    soundList.add(SoundModel(
        id: 10,
        name: AppStrings.protoolMarimba,
        beat1: AppStrings.protoolsMarimba1Sound,
        beat2: AppStrings.protoolsMarimba2Sound));

    soundList.add(SoundModel(
        id: 11,
        name: AppStrings.reason,
        beat1: AppStrings.reason1Sound,
        beat2: AppStrings.reason2Sound));

    soundList.add(SoundModel(
        id: 12,
        name: AppStrings.sonar,
        beat1: AppStrings.sonar1Sound,
        beat2: AppStrings.sonar2Sound));
  }

  // Initialize  animation controller
  initializeAnimationController() async {
    setSoundList();
    Future.delayed(Duration.zero, () async {
      setSpeedTrainerDefaultValue();
    });
  }

  setSpeedTrainerDefaultValue() async {
    int? defSound = await SharedPref.getStoreSpeedTrainerDefaultSound;
    String? defValue = await SharedPref.getSpeedTrainerDefaultValue;

    double? defSpeedInterval = await SharedPref.getSpeedTrainerDefaultInterval;

    gafInterval = defSpeedInterval ?? 1;

    defaultBeatValue = defValue ?? "4/4";

    soundName = (defSound == null ? AppStrings.logic : soundList[defSound].name)!;
    firstBeat = (defSound == null ? AppStrings.logic1Sound : soundList[defSound].beat1)!;
    secondBeat = (defSound == null ? AppStrings.logic2Sound : soundList[defSound].beat2)!;

    getBeatsDuration(defaultBeatValue!);

    notifyListeners();
  }

  // TOTAL TICK IS USED TO IDENTIFY BEAT AUDIO
  // TWO TYPE OF AUDIO TICK / TAP
  int totalTick = 0;

  getBeatsDuration(String value) {
    List beatValue = value.split("/");

    int beatN = int.parse(beatValue[0]);
    int beatD = int.parse(beatValue[1]);

    print("Beat Numerator : $beatN");
    print("Beat Denomenator : $beatD");

    totalBeats = beatN;

    if (beatD == 2) {
      timeStamp = 120000;
    } else if (beatD == 4) {
      timeStamp = 60000;
    } else if (beatD == 8) {
      timeStamp = 30000;
    } else if (beatD == 16) {
      timeStamp = 15000;
    } else if (beatD == 32) {
      timeStamp = 7500;
    } else if (beatD == 64) {
      timeStamp = 3750;
    }
    notifyListeners();
  }

  // Clear speed trainer settings
  clearSpeedTrainer(bool isNotify) {
    if (_timer != null) {
      _timer!.cancel();
    }
    isPlaying = false;
    bpm = 120;
    startTempo = 120;
    targetTempo = 180;
    interval = 10;
    bar = 2;
    totalTick = 0;
    barCounter = 0;
    if (isNotify == true) {
      notifyListeners();
    }
  }

  // SET START TEMPO RANGE OF SLIDER
  setStartTempo(
    double value,
  ) {
    startTempo = value;
    bpm = startTempo;
    barCounter = 0;
    totalTick = 0;
    firstTime = true;
    notifyListeners();
    if (isPlaying == true) {
      setTimer();
    }
  }

  // SET TARGET RANGE OF SLIDER
  setTargetTempo(
    double value,
  ) {
    targetTempo = value;
    barCounter = 0;
    totalTick = 0;
    firstTime = true;
    notifyListeners();
    if (isPlaying) {
      setTimer();
    }
  }

  // INTERVAL
  void onChangedInterval(int newValue) {
    interval = newValue;
    notifyListeners();
    if (isPlaying) {
      setTimer();
    }
  }

  onChangedBar(int newValue) {
    bar = newValue;
    notifyListeners();
    if (isPlaying) {
      setTimer();
    }
  }


  // START OR STOP AUDIO
  void startStop() {
    totalTick = 0;
    bpm = startTempo;
    barCounter = 0;
    if (isPlaying) {
      if (_timer != null) {
        _timer!.cancel();
      }
    } else {
      setTimer();
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  int timeStamp = 60000;

  // Set timer for BPM
  // Setting or canceling timer based on BPM and target tempo
  setTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      Duration(milliseconds: (timeStamp / bpm).round()),
      (Timer timer) async {
        if (targetTempo + interval > bpm) {
          playSound();
        } else {
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

  //Play sound based on the metronome ticks
  Future playSound() async {
    barCounter = barCounter + 1;
    totalTick = totalTick + 1;
    if (totalTick == 1) {
      bool check = firstTime == true ? barCounter - 1 == bar * totalBeats : barCounter == bar * totalBeats;
      if (check == true) {
        bpm = bpm + interval;
        barCounter = 0;
        firstTime = false;
        notifyListeners();
        setTimer();
      }
      if(bpm >= targetTempo+bar*interval)return;
       playBeat(firstBeat);
    } else {
      if (totalTick < totalBeats) {
        playBeat(secondBeat);
      } else {
        totalTick = 0;
        playBeat(secondBeat);
      }
    }
  }

  playBeat(String beat) {
    if (player.playing) {
      stopLoadAndPlay(beat);
    } else {
      loadAndPlay(beat);
    }
  }

  stopLoadAndPlay(String beat) {
    player.stop();
    player.setAsset(beat);
    player.play();
  }

  loadAndPlay(String beat) {
    player.setAsset(beat);
    player.play();
  }
}
