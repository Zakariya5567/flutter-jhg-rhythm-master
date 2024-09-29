import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:reg_page/reg_page.dart';
import 'package:rhythm_master/app_utils/app_strings.dart';
import 'package:rhythm_master/app_utils/app_utils.dart';
import 'package:rhythm_master/models/sound_model.dart';
import 'package:rhythm_master/services/local_db.dart';

//The MetroProvider class is responsible for managing the metronome functionality,
//controlling BPM, animation, and sound playback.

class MetroProvider extends ChangeNotifier {
  // Custom value selection
  int beatNumerator = 2;
  int beatDenominator = 2;

  // initial values of BPM
  Timer? bpmContinuousTimer;
  double bpm = 120;
  double bpmMin = 1.0;
  double bpmMax = 300.0;

  // Initial value of slider
  // double sliderMin = 1.0;
  // double sliderMax = 300.0;

  // List of Beat buttons
  List<String> tapButtonList = ['4/4', '3/4', '6/8', '12/8'];

  // Position of the slider
  double position = 0;
  int totalBeat = 4;
  int totalTick = 0;
  bool isPlaying = false;

  // Animation controller values
  AnimationController? controller;
  Animation<double>? animation;

  // Instance of the Player
  final player = AudioPlayer();

  int selectedIndex = 0;

  double timeStamp = 0;

  double? defaultBPM;
  int? defaultSound;
  int? defaultTiming;
  String? defaultBeatValue;

  // Instance of the Player
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();

  bool firstTime = true;
  bool isRepeat = true;
  Timer? timer;

  // Set selected sound
  String soundName = AppStrings.logic;
  String firstBeat = AppStrings.logic1Sound;
  String secondBeat = AppStrings.logic2Sound;
  int selectedButton = 0;

  clearBottomSheetBeats() {
    beatNumerator = 2;
    beatDenominator = 2;
    notifyListeners();
  }

  Future<void> preloadSounds() async {
    var directory1 =
        !kIsWeb ? Utils.getAsset(firstBeat) : AppUtils.setWebAsset(firstBeat);
    var directory2 =
        !kIsWeb ? Utils.getAsset(secondBeat) : AppUtils.setWebAsset(secondBeat);

    await player1.setFilePath(directory1.path, preload: true);
    await player2.setFilePath(directory2.path, preload: true);
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

  String? customBeatValue;

  setValueOfBottomSheet(TickerProviderStateMixin ticker) {
    selectedButton = 4;
    String value = "${beatNumerator}/${beatDenominator}";
    customBeatValue = value;
    notifyListeners();
    getBeatsDuration(value, selectedButton);
    if (isPlaying) {
      setTimer(ticker);
    }
  }

  setTimeStamp(int value) {
    timeStamp = 240000 / value;
    notifyListeners();
  }

  double gafInterval = 1;

  // Initialize  animation controller
  initializeAnimationController(
    TickerProviderStateMixin ticker,
  ) async {
    if (timer != null) {
      timer!.cancel();
    }
    await preloadSounds();    
    // timer =
    //     Timer.periodic(Duration(milliseconds: (60000 / bpm).round()), (timer) {
    //   Future.delayed(Duration.zero, () async {
    //     await player.setVolume(0);
    //     try {
    //       playSound();
    //     } catch (e) {
    //       print('exception on player $e');
    //     }
    //   });
    // });
    // calling sound list to add sound to sound list

    controller = AnimationController(
      duration: Duration(milliseconds: (30000 / bpm).round()),
      vsync: ticker,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    controller!.repeat(reverse: true);
    controller!.stop();

    Future.delayed(Duration.zero, () async {
      setMetronomeDefaultValue();
    });
  }

  setMetronomeDefaultValue() async {
    double? defBPM = await SharedPref.getDefaultBPM;
    int? defSound = await SharedPref.getDefaultSound;
    int? defTiming = await SharedPref.getDefaultTiming;
    String? defValue = await SharedPref.getMetronomeDefaultValue;

    double? defMetroInterval = await SharedPref.getMetronomeDefaultInterval;

    gafInterval = defMetroInterval ?? 1;

    defaultBPM = defBPM ?? 120;
    defaultSound = defSound ?? 0;
    defaultTiming = defTiming ?? 0;
    defaultBeatValue = defValue ?? "4/4";

    selectedIndex = defaultSound ?? 0;
    selectedButton = defaultTiming ?? 0;
    getBeatsDuration(defaultBeatValue!, selectedButton);
    bpm = defaultBPM ?? 120;
    position = 0;
    totalTick = 0;
    isPlaying = false;

    soundName = (defaultSound == null
        ? AppStrings.logic
        : soundList[defaultSound!].name)!;
    firstBeat = (defaultSound == null
        ? AppStrings.logic1Sound
        : soundList[defaultSound!].beat1)!;
    secondBeat = (defaultSound == null
        ? AppStrings.logic2Sound
        : soundList[defaultSound!].beat2)!;
    notifyListeners();
  }

  // dispose controller if off the page
  Future<void> disposeController() async {
    if (timer != null) {
      timer!.cancel();
    }
    isPlaying = false;
    if (controller != null) {
      controller!.dispose();
      controller = null;
    }
    if (bpmContinuousTimer != null) {
      bpmContinuousTimer!.cancel();
    }
  }

  // clear metronome
  clearMetronome() {
    if (timer != null) {
      timer!.cancel();
    }
    if (controller != null) {
      animation = Tween<double>(begin: 0, end: 1).animate(controller!);
      controller!.reset();
    }
    setMetronomeDefaultValue();
    notifyListeners();
  }

  // Set position of the slider
  // Setting position, BPM, and notifying listeners
  setPosition(double value, TickerProviderStateMixin ticker) {
    position = value;
    bpm = value;
    totalTick = 0;
    notifyListeners();
    if (isPlaying == true) {
      setTimer(ticker);
    }
  }

  // Start/stop the metronome
  // Toggling between start and stop states and notifying listeners

  Future<void> startStop(TickerProviderStateMixin ticker) async {
    firstTime = true;
    totalTick = 0;
    if (isPlaying) {
      controller!.reset();
      animation = Tween<double>(begin: 0, end: 1).animate(controller!);
      if (timer != null) {
        timer!.cancel();
      }
      if (player.playing) {
        await player.stop();
      }
    } else {
      setTimer(ticker);
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  // Increase BPM
  // Increasing BPM, resetting total ticks, and notifying listeners
  void increaseBpm(TickerProviderStateMixin ticker) {
    if (bpm < bpmMax) {
      totalTick = 0;
      bpm += 1;
      notifyListeners();
      if (isPlaying == true) {
        setTimer(ticker);
      }
    }
  }

  // Continuously increase bpm value until it equal to the bpmMax
  void continuousIncreaseBpm(TickerProviderStateMixin ticker) {
    if (bpmContinuousTimer != null) {
      bpmContinuousTimer!.cancel;
    }
    bpmContinuousTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      increaseBpm(ticker);
    });
  }

  // Decrease BPM
  // Decreasing BPM, resetting total ticks, and notifying listeners
  void decreaseBpm(TickerProviderStateMixin ticker) {
    if (bpm > bpmMin) {
      totalTick = 0;
      bpm -= 1;
      if (bpm < 1) {
        bpm = 1;
      }
      notifyListeners();
      if (isPlaying == true) {
        setTimer(ticker);
      }
    }
  }

  // Continuously decrease bpm value until it equal to the bpmMin
  void continuousDecreaseBpm(TickerProviderStateMixin ticker) {
    if (bpmContinuousTimer != null) {
      bpmContinuousTimer!.cancel;
    }
    bpmContinuousTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      decreaseBpm(ticker);
    });
  }

  ///=================================
  //Set timer base on the BPM
  setTimer(TickerProviderStateMixin ticker) async {
    player.setVolume(1.0);
    // dispose the previous timer adn add new one base on BPM
    totalTick = 0;
    firstTime = true;
    controller!.reset();
    controller!.dispose();

    int timerInterval = (timeStamp / bpm).round();

    controller = AnimationController(
      duration: Duration(milliseconds: timerInterval),
      vsync: ticker,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(Duration(milliseconds: timerInterval), (timer) {
      playSound();
    });

    controller!.repeat(reverse: true);
    // Listen to timer to animate stalk and play sound
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        if (firstTime == true) {
          firstTime = false;
        }
      }
      if (status == AnimationStatus.reverse) {
        if (firstTime == true) {
          animation = Tween<double>(begin: -1, end: 1).animate(controller!);
          controller!.repeat(
            reverse: true,
          );
        }
      }
    });
  }

  ///===================================
  // Set beats based on the selected button
  // Setting total beats based on the selected button and notifying listeners

  getBeatsDuration(String value, int buttonIndex) {
    List beatValue = value.split("/");

    int beatN = int.parse(beatValue[0]);
    int beatD = int.parse(beatValue[1]);

    print("Beat Numerator : $beatN");
    print("Beat Denomenator : $beatD");

    totalBeat = beatN;

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

    if (selectedButton == 4) {
      customBeatValue = value;
      beatNumerator = beatN;
      beatDenominator = beatD;
    }
    notifyListeners();
  }

  setBeats(
      {required TickerProviderStateMixin ticker,
      required int index,
      required String indexValue}) {
    customBeatValue = null;
    selectedButton = index;
    beatNumerator = 2;
    beatDenominator = 2;
    notifyListeners();
    getBeatsDuration(indexValue, index);
    if (isPlaying) {
      setTimer(ticker);
    }
  }

  // Setting selected sound and notifying listeners
  setSound(
      {required TickerProviderStateMixin? ticker,
      required String name,
      required String beat1,
      required beat2,
      required int index}) {
    selectedIndex = index;
    soundName = name;
    firstBeat = beat1;
    secondBeat = beat2;
    notifyListeners();
    totalTick = 0;
    notifyListeners();
    if (ticker == null) return;
    if (isPlaying == true) {
      setTimer(ticker);
    }
  }

  // Play sound based on the metronome ticks
  Future playSound() async {
    totalTick = totalTick + 1;
    if (totalTick == 1) {
      player.playing ? playBeat(firstBeat, true) : playBeat(firstBeat, false);
    } else {
      if (totalTick < totalBeat + 1) {
        player.playing
            ? playBeat(secondBeat, true)
            : playBeat(secondBeat, false);
        if (totalTick == totalBeat) {
          totalTick = 0;
        }
      }
    }
  }

  // playBeat(String beat, bool isStop) {
  //   isStop == true ? player.stop() : null;
  //   var directory = !kIsWeb ? Utils.getAsset(beat) : AppUtils.setWebAsset(beat);
  //   player.setFilePath(directory.path, preload: true);
  //   player.play();
  // }

  playBeat(String beat, bool isStop) {
    //  isStop == true ? player.stop() : null;
    if (beat == AppStrings.logic1Sound) {
      player1.seek(Duration.zero);
      // player1.load();
      player1.play();
    } else {
      player2.seek(Duration.zero);
      // player2.load();
      player2.play();
    }
  }
}
