import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tempo_bpm/model/sound_model.dart';
import 'package:tempo_bpm/utils/app_constant.dart';




//The MetroProvider class is responsible for managing the metronome functionality,
// controlling BPM, animation, and sound playback.

class MetroProvider extends ChangeNotifier{


  // initial values of BPM
  double bpm = 120;
  double bpmMin = 1.0;
  double bpmMax = 300.0;

  // Initial value of slider
  double sliderMin = 1.0;
  double sliderMax = 300.0;

  // List of Beat buttons
  List<String> tapButtonList = ['4/4', '3/4','6/8'];


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
  List <SoundModel> soundList = [];

  int selectedIndex = 0;

  // set sounds to sound list
  setSoundList(){
    soundList.clear();
    soundList.add(SoundModel(id: 0, name: AppConstant.logic, beat1: AppConstant.logic1Sound, beat2: AppConstant.logic2Sound));
    soundList.add(SoundModel(id: 1,name: AppConstant.click, beat1: AppConstant.clave1Sound, beat2: AppConstant.clave2Sound));
    soundList.add(SoundModel(id: 2,name: AppConstant.drumsticks, beat1: AppConstant.drumsticks1Sound, beat2: AppConstant.drumsticks2Sound));
    soundList.add(SoundModel(id: 3,name: AppConstant.fineMetronome, beat1: AppConstant.fineMetronome1Sound, beat2: AppConstant.fineMetronome2Sound));
    soundList.add(SoundModel(id: 4,name: AppConstant.heartbeat, beat1: AppConstant.heartbeat1Sound, beat2: AppConstant.heartbeat2Sound));
    soundList.add(SoundModel(id: 5,name: AppConstant.lowClave, beat1: AppConstant.logic1Sound, beat2: AppConstant.logic2Sound));
    soundList.add(SoundModel(id: 6,name: AppConstant.ping, beat1: AppConstant.ping1Sound, beat2: AppConstant.ping2Sound));
    soundList.add(SoundModel(id: 7,name: AppConstant.rim, beat1: AppConstant.reason1Sound, beat2: AppConstant.reason2Sound));
    soundList.add(SoundModel(id: 8,name: AppConstant.seiko, beat1: AppConstant.seiko1Sound, beat2: AppConstant.seiko2Sound));
    soundList.add(SoundModel(id: 9,name: AppConstant.softClick, beat1: AppConstant.softClick1Sound, beat2: AppConstant.softClick2Sound));
    soundList.add(SoundModel(id: 10,name: AppConstant.ableton, beat1: AppConstant.ableton1Sound, beat2: AppConstant.ableton2Sound));
    soundList.add(SoundModel(id: 11,name: AppConstant.cubase, beat1: AppConstant.clave1Sound, beat2: AppConstant.cubase2Sound));
    soundList.add(SoundModel(id: 12,name: AppConstant.flStudio, beat1: AppConstant.flStudio1Sound, beat2: AppConstant.flStudio2Sound));
    soundList.add(SoundModel(id: 13,name: AppConstant.maschine, beat1: AppConstant.maschinelSound, beat2: AppConstant.maschine2Sound));
    soundList.add(SoundModel(id: 14,name: AppConstant.mpc, beat1: AppConstant.mpc1Sound, beat2: AppConstant.mpc2Sound));
    soundList.add(SoundModel(id: 15,name: AppConstant.protoolDefault, beat1: AppConstant.protoolsDefault1Sound, beat2: AppConstant.protoolsDefault2Sound));
    soundList.add(SoundModel(id: 16,name: AppConstant.protoolMarimba, beat1: AppConstant.protoolsMarimba1Sound, beat2: AppConstant.protoolsMarimba2Sound));
    soundList.add(SoundModel(id: 17,name: AppConstant.reason, beat1: AppConstant.reason1Sound, beat2: AppConstant.reason2Sound));
    soundList.add(SoundModel(id: 18,name: AppConstant.sonar, beat1: AppConstant.sonar1Sound, beat2: AppConstant.sonar2Sound));
  }



  // Initialize  animation controller
  initializeAnimationController(TickerProviderStateMixin ticker,bool isMute)async{

    // calling sound list to add sound to sound list
    setSoundList();

   soundName = AppConstant.logic;
   firstBeat = AppConstant.logic1Sound;
   secondBeat = AppConstant.logic2Sound;

   // assign values to controller

    if(isMute == true){
      controller = AnimationController(
        duration: Duration(milliseconds: (60000 / bpm).round()),
        vsync: ticker,
      );
      animation = Tween<double>(begin: -1, end: 1).animate(controller!);

      player.setVolume(0.0);
      controller!.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3),() async {
        controller!.reset();
        animation = Tween<double>(begin: 0, end: 1).animate(controller!);
        await player.stop();
        player.setVolume(1.0);
        notifyListeners();
      });
    }else{
      controller = AnimationController(
        duration: Duration(milliseconds: (30000 / bpm).round()),
        vsync: ticker,
      );
      animation = Tween<double>(begin: 0, end: 1).animate(controller!);

    }

  }

  // dispose controller if off the page
  Future<void> disposeController() async {
    isPlaying = false;
    if(controller != null){
      controller!.dispose();
    }

  }


  // clear metronome
  clearMetronome(){

     position = 0;
     bpm = 120;
     totalBeat = 4;
     totalTick = 0;
     isPlaying = false;
     if(controller != null){
       animation = Tween<double>(begin: 0, end: 1).animate(controller!);
       controller!.reset();
     }
     soundName = AppConstant.logic;
     firstBeat = AppConstant.logic1Sound;
     secondBeat = AppConstant.logic2Sound;
     notifyListeners();
  }

  // Set position of the slider
  // Setting position, BPM, and notifying listeners
  setPosition(double value,TickerProviderStateMixin ticker){
    position = value;
    bpm  = value;
    totalTick = 0;
    notifyListeners();
    if(isPlaying == true){
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
       if(player.playing){
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
  void increaseBpm(TickerProviderStateMixin ticker){
    if( bpm < bpmMax) {
      totalTick = 0;
      bpm += 1;
      notifyListeners();
      if(isPlaying == true){
        setTimer(ticker);
      }
    }
  }

  // Decrease BPM
  // Decreasing BPM, resetting total ticks, and notifying listeners
  void decreaseBpm(TickerProviderStateMixin ticker) {
    if(bpm > bpmMin){
      totalTick = 0;
      bpm -= 1;
      if (bpm < 1) {
        bpm = 1;
      }
      notifyListeners();
      if(isPlaying == true){
        setTimer(ticker);
      }
    }
  }



  bool firstTime = true;

  // Set timer base on the BPM
  setTimer(TickerProviderStateMixin ticker) async {

    // dispose the previous timer adn add new one base on BPM
    firstTime = true;
    controller!.reset();
    controller!.dispose();
    controller =  AnimationController(
      duration:  Duration( milliseconds: (30000 / bpm).round()),
      vsync: ticker,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    controller!.repeat(reverse: true);

    // Listen to timer to animate stalk and play sound
    controller!.addStatusListener((status) {
      if(status == AnimationStatus.forward){
        if(firstTime == true){
          firstTime = false;
        }
        else{
          playSound();
        }

      }
      if(status == AnimationStatus.reverse){
        if(firstTime == true){
          controller!.duration = Duration( milliseconds: (60000 / bpm).round());
          animation = Tween<double>(begin: -1, end: 1).animate(controller!);
          controller!.repeat(reverse: true);

        }else{
          playSound();
        }
      }
      if(status == AnimationStatus.completed){
      }
      if(status == AnimationStatus.dismissed){}


    });
  }


  // Set beats based on the selected button
  // Setting total beats based on the selected button and notifying listeners

  int selectedButton = 0;
  setBeats(index){
    if(index == 0 ){
      totalBeat = 4;
      selectedButton = index;
      notifyListeners();

    }else if(index == 1 ){
      totalBeat = 3;
      selectedButton = index;
      notifyListeners();
    }else if(index == 2 ){
      totalBeat = 6;
      selectedButton = index;
      notifyListeners();
    }

  }




  // Set selected sound

  String soundName = AppConstant.logic;
  String firstBeat = AppConstant.logic1Sound;
  String secondBeat = AppConstant.logic2Sound;

  // Setting selected sound and notifying listeners
  setSound({required TickerProviderStateMixin ticker,
    required String name,
    required String beat1 ,
    required beat2 ,
    required int index}){
    selectedIndex = index;
    soundName = name;
    firstBeat = beat1;
    secondBeat = beat2;
    notifyListeners();
    totalTick = 0;
    notifyListeners();
    if(isPlaying == true){
      setTimer(ticker);
    }
  }


  // Play sound based on the metronome ticks
  Future playSound()async{
    totalTick = totalTick+1;
    if(totalTick == 1){
      await player.setAsset(firstBeat);
      await player.play();
    }else{
      if(totalTick<totalBeat+1){
        await player.setAsset(secondBeat);
        await player.play();
        if(totalTick == totalBeat) {
          totalTick = 0;
        }
      }
    }
  }

}

