import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_utils.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/services/local_db.dart';

//The SpeedProvider class manages the functionality of a speed trainer,
// including BPM, intervals, and audio playback.

class SpeedProvider extends ChangeNotifier {
  // INDICATE SOUND IS PLAYING OR STOP
  bool isPlaying = false;

  // BPM IS BEAT PER MINUTE
  double bpm = 120;
// Instance of the Player
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();
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
  int defaultBar = 2;
  int defaultInterval = 1;
  int sliderInterval = 1;
  int totalBeats = 4;

  final player = AudioPlayer();

  String soundName = AppStrings.logic;
  String firstBeat = AppStrings.logic1Sound;
  String secondBeat = AppStrings.logic2Sound;

  String? defaultBeatValue;

  double gafInterval = 1;

  // Initialize  animation controller
  initializeAnimationController() async {
    Future.delayed(Duration.zero, () async {
      setSpeedTrainerDefaultValue();
    });
    // await preloadSounds();
  }

  Future<void> preloadSounds() async {
    var directory1 =
        !kIsWeb ? Utils.getAsset(firstBeat) : AppUtils.setWebAsset(firstBeat);
    var directory2 =
        !kIsWeb ? Utils.getAsset(secondBeat) : AppUtils.setWebAsset(secondBeat);
    await player1.setFilePath(directory1.path, preload: true);
    await player2.setFilePath(directory2.path, preload: true);
  }

  setSpeedTrainerDefaultValue() async {
    int? defSound = await SharedPref.getStoreSpeedTrainerDefaultSound;
    String? defValue = await SharedPref.getSpeedTrainerDefaultValue;

    double? defSpeedInterval = await SharedPref.getSpeedTrainerDefaultInterval;

    gafInterval = defSpeedInterval ?? 1;

    defaultBeatValue = defValue ?? "4/4";

    soundName =
        (defSound == null ? AppStrings.logic : soundList[defSound].name)!;
    firstBeat = (defSound == null
        ? AppStrings.logic1Sound
        : soundList[defSound].beat1)!;
    secondBeat = (defSound == null
        ? AppStrings.logic2Sound
        : soundList[defSound].beat2)!;

    getBeatsDuration(defaultBeatValue!);

    await preloadSounds();
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
    interval = defaultInterval;
    bar = defaultBar;
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
    print("intervalIs $interval");
    notifyListeners();
    if (isPlaying) {
      setTimer();
    }
  }

  // onChangedBar(int newValue) {
  //   bar = newValue;
  //   notifyListeners();
  //   if (isPlaying) {
  //     setTimer();
  //   }
  // }
  onChangedBar(int newValue) {
    bar = newValue;

    // Reset critical counters and flags
    totalTick = 0;
    barCounter = 0;
    firstTime = true; // Important to reset the first-time flag

    notifyListeners();

    if (isPlaying) {
      setTimer(); // Re-set the timer to adapt to the new bar setting
    }
  }

  onChangedDefaultBar(int newValue) {
    defaultBar = newValue;
    notifyListeners();
  }

  onChangedDefaultInterval(int newValue) {
    defaultInterval = newValue;
    notifyListeners();
  }

  onChangedSliderInterval(int newValue) {
    sliderInterval = newValue;
    notifyListeners();
  }

  // START OR STOP AUDIO
  // void startStop() {
  //   totalTick = 0;
  //   bpm = startTempo;
  //   barCounter = 0;
  //   if (isPlaying) {
  //     if (_timer != null) {
  //       _timer!.cancel();
  //     }
  //   } else {
  //     setTimer();
  //   }
  //   isPlaying = !isPlaying;
  //   // notifyListeners();
  // }

  void startStop() {
    totalTick = 0;
    barCounter = 0;
    firstTime = true; // Reset so it knows to increase BPM again
   // bpm = startTempo; // Reset BPM to the starting tempo

    if (isPlaying) {
      if (_timer != null) {
        _timer!.cancel(); // Stop the current timer
      }
    } else {
      setTimer(); // Restart with updated settings
    }

    isPlaying = !isPlaying;
  }

  int timeStamp = 60000;

  ///===========
  setTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      Duration(milliseconds: (timeStamp / bpm).round()),
      (Timer timer) async {
        print(
            "interval is $interval targetTempo is $targetTempo bpm is $bpm timeStamp is ${(timeStamp / bpm).round()} targetTempo + interval is ${targetTempo + interval}");
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
  // Future playSound() async {
  //   barCounter = barCounter + 1;
  //   totalTick = totalTick + 1;
  //   if (totalTick == 1) {
  //     bool check = firstTime == true
  //         ? barCounter - 1 == bar * totalBeats
  //         : barCounter == bar * totalBeats;

  //     if (check == true) {
  //       bpm = bpm + interval;

  //       barCounter = 0;
  //       firstTime = false;
  //       notifyListeners();
  //       setTimer();
  //     }
  //     if (bpm >= targetTempo + bar * interval) return;
  //     playBeat1();
  //     //    playBeat(firstBeat);
  //   } else {
  //     if (totalTick < totalBeats) {
  //       playBeat2();
  //       // playBeat(secondBeat);
  //     } else {
  //       totalTick = 0;
  //       playBeat2();
  //       //playBeat(secondBeat);
  //     }
  //   }
  // }
  Future playSound() async {
    barCounter = barCounter + 1;
    totalTick = totalTick + 1;

    if (totalTick == 1) {
      // Adjust this check to handle the barCounter correctly
      bool check = firstTime == true
          ? barCounter - 1 == bar * totalBeats
          : barCounter == bar * totalBeats;

      if (check == true) {
        bpm = bpm + interval;
        barCounter = 0;
        firstTime = false;
        notifyListeners();
        setTimer();
      }

      // If we've reached the target tempo, stop increasing
      if (bpm >= targetTempo + bar * interval) return;

      playBeat1();
    } else {
      if (totalTick < totalBeats) {
        playBeat2();
      } else {
        totalTick = 0;
        playBeat2();
      }
    }
  }

  playBeat1() {
    player1.seek(Duration.zero);
    player1.play();
  }

  playBeat2() {
    player2.seek(Duration.zero);
    player2.play();
  }

  playBeat(String beat) {
    if (player1.playing) {
      stopLoadAndPlay(beat);
    } else {
      loadAndPlay(beat);
    }
  }

  stopLoadAndPlay(String beat) {
    // player.stop();
    if (!kIsWeb) {
      player1.seek(Duration.zero);
    } else {
      var directory = AppUtils.setWebAsset(beat);
      player.setFilePath(directory.path, preload: true);
    }

    //player.setAsset(beat);
    player1.play();
  }

  // stopLoadAndPlay(String beat) {
  //   player.stop();
  //   if (!kIsWeb) {
  //     var directory = Utils.getAsset(beat);
  //     player.setFilePath(directory.path, preload: true);
  //   } else {
  //     var directory = AppUtils.setWebAsset(beat);
  //     player.setFilePath(directory.path, preload: true);
  //   }

  //   //player.setAsset(beat);
  //   player.play();
  // }

  void incrementTempo(int interval) {
    // print(
    //     "startTempo is $startTempo sliderInterval is $sliderInterval targetTempo is $targetTempo");
    if (startTempo + sliderInterval <= targetTempo) {
      startTempo += sliderInterval;
    } else {
      // If incrementing would exceed targetTempo, set startTempo to targetTempo
      startTempo = targetTempo;
    }
    bpm = startTempo;
    notifyListeners();
  }

  void decrementTempo(int interval) {
    if (startTempo - sliderInterval >= 1) {
      startTempo -= sliderInterval;
    } else {
      // If reducing would go below 1, just set startTempo to 1
      startTempo = 1;
    }
    bpm = startTempo;

    notifyListeners();
  }

  void incrementTargetTempo(int interval) {
    if (targetTempo + sliderInterval <= 300) {
      targetTempo += sliderInterval;
    } else {
      // If incrementing would exceed targetTempo, set startTempo to targetTempo
      targetTempo = 300;
    }

    notifyListeners();
  }

  void decrementTargetTempo(int interval) {
    if (targetTempo - sliderInterval >= 1) {
      targetTempo -= sliderInterval;
    } else {
      targetTempo = 1;
    }
    notifyListeners();
  }

  loadAndPlay(String beat) {
    // var directory = getAsset(beat);
    if (!kIsWeb) {
      player2.seek(Duration.zero);
      // var directory = Utils.getAsset(beat);
      // player2.setFilePath(directory.path, preload: true);
    } else {
      var directory = AppUtils.setWebAsset(beat);
      player2.setFilePath(directory.path, preload: true);
    }
    //player.setFilePath(directory.path, preload: true);
    // player.setAsset(beat);
    player2.play();
  }
  // loadAndPlay(String beat) {
  //   // var directory = getAsset(beat);
  //   if (!kIsWeb) {
  //     var directory = Utils.getAsset(beat);
  //     player.setFilePath(directory.path, preload: true);
  //   } else {
  //     var directory = AppUtils.setWebAsset(beat);
  //     player.setFilePath(directory.path, preload: true);
  //   }
  //   //player.setFilePath(directory.path, preload: true);
  //   // player.setAsset(beat);
  //   player.play();
  // }
}
