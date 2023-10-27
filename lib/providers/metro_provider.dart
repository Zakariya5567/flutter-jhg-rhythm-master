import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tempo_bpm/utils/app_constant.dart';





class MetroProvider extends ChangeNotifier{


  double bpmMin = 1.0;
  double bpmMax = 300.0;
  double sliderMin = 1.0;
  double sliderMax = 300.0;

  List<String> tapButtonList = ['4/4', '3/4','6/8'];


  double position = 0;
  double bpm = 120;
  int totalBeat = 4;
  int totalTick = 0;
  bool isPlaying = false;

  AnimationController? controller;
  Animation<double>? animation;

  final player = AudioPlayer();


  initializeAnimationController(TickerProviderStateMixin ticker)async{
    controller = AnimationController(
      duration: Duration(milliseconds: (30000 / bpm).round()),
      vsync: ticker,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
  }

  Future<void> disposeController() async {
    isPlaying = false;
    if(controller != null){
      controller!.dispose();
    }

  }

  setPosition(double value,TickerProviderStateMixin ticker){
    position = value;
    bpm  = value;
    totalTick = 0;
    notifyListeners();
    if(isPlaying == true){
      setTimer(ticker);
    }
  }

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

  setTimer(TickerProviderStateMixin ticker) async {
    firstTime = true;
    controller!.reset();
    controller!.dispose();
    controller =  AnimationController(
      duration:  Duration( milliseconds: (30000 / bpm).round()),
      vsync: ticker,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller!);
    controller!.repeat(reverse: true);
    controller!.addStatusListener((status) {
      if(status == AnimationStatus.forward){
        if(firstTime == true){
          firstTime = false;}
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


  Future playSound()async{
    totalTick = totalTick+1;
    if(totalTick == 1){
      await player.setAsset(AppConstant.clickSound);
      await player.play();
    }else{
      if(totalTick<totalBeat+1){
        await player.setAsset(AppConstant.tapSound);
        await player.play();
        if(totalTick == totalBeat) {
          totalTick = 0;
        }
      }
    }
  }

}

