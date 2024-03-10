import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rhythm_master/db/local_db.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/utils/app_constant.dart';

//The MetroProvider class is responsible for managing the metronome functionality,
// controlling BPM, animation, and sound playback.

class MetroProvider extends ChangeNotifier {
  // initial values of BPM
  Timer? bpmContinuousTimer;
  double bpm = 120;
  double bpmMin = 1.0;
  double bpmMax = 300.0;

  // Initial value of slider
  double sliderMin = 1.0;
  double sliderMax = 300.0;

  // List of Beat buttons
  List<String> tapButtonList = ['4/4', '3/4', '6/8'];

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

  // List of sound list
  List<SoundModel> soundList = [];

  int selectedIndex = 0;

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

  double? defaultBPM;
  int? defaultSound;
  int? defaultTiming;

  // Initialize  animation controller
  initializeAnimationController(
    TickerProviderStateMixin ticker,
  ) async {
    setSoundList();
    if (timer != null) {
      timer!.cancel();
    }
    timer =
        Timer.periodic(Duration(milliseconds: (60000 / bpm).round()), (timer) {
      Future.delayed(Duration.zero, () async {
        await player.setVolume(0);
        playSound();
      });
    });
    // calling sound list to add sound to sound list

    controller = AnimationController(
      duration: Duration(milliseconds: (30000 / bpm).round()),
      vsync: ticker,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    controller!.repeat(reverse: true);
    controller!.stop();

    Future.delayed(Duration.zero, () async {
      double? defBPM = await SharedPref.getDefaultBPM;
      int? defSound = await SharedPref.getDefaultSound;
      int? defTiming = await SharedPref.getDefaultTiming;

      defaultBPM = defBPM ?? 120;
      defaultSound = defSound ?? 0;
      defaultTiming = defTiming ?? 0;

      selectedIndex = defaultSound ?? 0;
      selectedButton = defaultTiming ?? 0;
      totalBeat = selectedButton == 0 ? 4 : selectedButton == 1 ? 3 : 6;
      bpm = defaultBPM ?? 120;
      position = 0;
      totalTick = 0;
      isPlaying = false;
      soundName = (defaultSound == null
          ? AppConstant.logic
          : soundList[defaultSound!].name)!;
      firstBeat = (defaultSound == null
          ? AppConstant.logic1Sound
          : soundList[defaultSound!].beat1)!;
      secondBeat = (defaultSound == null
          ? AppConstant.logic2Sound
          : soundList[defaultSound!].beat2)!;
      notifyListeners();
    });
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
    position = 0;
    totalTick = 0;
    isPlaying = false;
    selectedButton = defaultTiming ?? 0;
    totalBeat = selectedButton == 0
        ? 4
        : selectedButton == 1
            ? 3
            : 6;
    bpm = defaultBPM ?? 120;
    selectedIndex = defaultSound ?? 0;
    soundName = (defaultSound == null
        ? AppConstant.logic
        : soundList[defaultSound!].name)!;
    firstBeat = (defaultSound == null
        ? AppConstant.logic1Sound
        : soundList[defaultSound!].beat1)!;
    secondBeat = (defaultSound == null
        ? AppConstant.logic2Sound
        : soundList[defaultSound!].beat2)!;

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

  bool firstTime = true;
  bool isRepeat = true;
  Timer? timer;

  ///=================================
  //Set timer base on the BPM
  setTimer(TickerProviderStateMixin ticker) async {
    player.setVolume(1.0);
    // dispose the previous timer adn add new one base on BPM
    totalTick = 0;
    firstTime = true;
    controller!.reset();
    controller!.dispose();
    if (totalBeat == 6) {
      controller = AnimationController(
        duration: Duration(milliseconds: (30000 / bpm).round()),
        vsync: ticker,
      );
    } else {
      controller = AnimationController(
        duration: Duration(milliseconds: (60000 / bpm).round()),
        vsync: ticker,
      );
    }

    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    if (timer != null) {
      timer!.cancel();
    }
    if (totalBeat == 6) {
      timer = Timer.periodic(Duration(milliseconds: (30000 / bpm).round()),
          (timer) {
        playSound();
      });
    } else {
      timer = Timer.periodic(Duration(milliseconds: (60000 / bpm).round()),
          (timer) {
        playSound();
      });
    }

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

  int selectedButton = 0;
  setBeats(TickerProviderStateMixin ticker, index) {
    if (index == 0) {
      totalBeat = 4;
      selectedButton = index;
      notifyListeners();
      if (isPlaying) {
        setTimer(ticker);
      }
    } else if (index == 1) {
      totalBeat = 3;
      selectedButton = index;
      notifyListeners();
      if (isPlaying) {
        setTimer(ticker);
      }
    } else if (index == 2) {
      totalBeat = 6;
      selectedButton = index;
      notifyListeners();
      if (isPlaying) {
        setTimer(ticker);
      }
    }
  }

  // Set selected sound

  String soundName = AppConstant.logic;
  String firstBeat = AppConstant.logic1Sound;
  String secondBeat = AppConstant.logic2Sound;

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
      if (player.playing) {
        await player.stop();
        await player.setAsset(firstBeat);
        await player.play();
      } else {
        await player.setAsset(firstBeat);
        await player.play();
      }
    } else {
      if (totalTick < totalBeat + 1) {
        if (player.playing) {
          await player.stop();
          await player.setAsset(secondBeat);
          await player.play();
        } else {
          try {
            print("playing==");
            await player.setAsset(secondBeat);
            await player.play();
          } catch (e) {
            print("==${e}");
          }
        }
        if (totalTick == totalBeat) {
          totalTick = 0;
        }
      }
    }
  }
}
