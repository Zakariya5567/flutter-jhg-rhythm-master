import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import '../utils/app_constant.dart';
import 'package:async/async.dart';





class SpeedProvider extends ChangeNotifier{


  // INDICATE SOUND IS PLAYING OR STOP
  bool isPlaying = false;


  // BPM IS BEAT PER MINUTE
  double bpm = 40;


  // TIMER IS  BPM
  Timer? _timer;


  // START TEMPO VALUES
  double startTempo = 40;
  double startTempoMin = 1;
  double startTempoMax = 300;


  // TARGET TEMPO VALUES
  double targetTempo = 120;
  double targetTempoMin = 1;
  double targetTempoMax = 300;

  // INTERVAL VALUES
  // BPM SPEED WILL CHANGE ACCORDING TO INTERVAL
  int interval = 1;
  int minInterval = 1;
  int maxInterval = 120;


  // BAR IS BEAT PER BPM
  int bar = 1;
  int minBar = 1;
  int maxBar = 60;

  int totalBeats = 4;


  // TOTAL TICK IS USED TO IDENTIFY BEAT AUDIO
  // TWO TYPE OF AUDIO TICK / TAP
  int totalTick = 0;

  // INITIALIZE SOUND TO PRELOAD
  initializedPlayer()async{
    FlameAudio.play(AppConstant.clickSound,volume: 0);
  }

  // SET START TEMPO RANGE OF SLIDER
  setStartTempo(double value,) {
    startTempo = value;
    bpm = startTempo;
    notifyListeners();
    if(isPlaying == true){
      setTimer();
    }
  }

  // SET TARGET RANGE OF SLIDER
  setTargetTempo(double value,) {
    targetTempo = value;
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



  // setTimer() async {
  //
  //   for (int i = startTempo.toInt(); i<= targetTempo.toInt(); i++ ){
  //
  //     await Future.delayed(Duration( milliseconds: (60000 / bpm).round()),(){
  //       playSound();
  //     });
  //   }
  //
  // }


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
          }

      },
    );
  }
  //
  int barCounter = 0;

  Future playSound()async{

     barCounter = barCounter + 1;

    if(barCounter < totalBeats * bar ){

      totalTick = totalTick+1;

      if(totalTick == 1){
        FlameAudio.play(AppConstant.clickSound);
      }else{
        if(totalTick<totalBeats){
          FlameAudio.play(AppConstant.tapSound);
        }else{
          FlameAudio.play(AppConstant.tapSound);
          totalTick = 0;
        }
      }
    }else{
      barCounter = 0;
      totalTick = 0;
      if(targetTempo > bpm + interval){
        bpm = bpm + interval;
      }else{
        bpm = targetTempo;
      }
      FlameAudio.play(AppConstant.tapSound);
      setTimer();
      notifyListeners();
    }
  }

  Future stopSound()async{
    totalTick = 0;
    barCounter = 0;
  }

  disposeController() {
    if(_timer != null){
      _timer!.cancel();
    }
    isPlaying = false;
    bpm = 40;
    startTempo = 40;
    targetTempo = 120;
    interval = 1;
    bar = 1;
    totalTick = 0;
    barCounter = 0;
    notifyListeners();

  }

}



//========================================================================

// class SpeedProvider extends ChangeNotifier{
//
//
//   // INDICATE SOUND IS PLAYING OR STOP
//   bool isPlaying = false;
//
//
//  // BPM IS BEAT PER MINUTE
//   double bpm = 40;
//
//
//   // TIMER IS BASICALLY BPM AND INTERVAL TIMER
//   Timer? _timer;
//   Timer? _timer2;
//   Timer? _intervalTimer;
//
//
//   // START TEMPO VALUES
//   double startTempo = 40;
//   double startTempoMin = 1;
//   double startTempoMax = 300;
//
//
//   // TARGET TEMPO VALUES
//   double targetTempo = 120;
//   double targetTempoMin = 1;
//   double targetTempoMax = 300;
//
//   // INTERVAL VALUES
//   // BPM SPEED WILL CHANGE ACCORDING TO INTERVAL
//   int interval = 1;
//   int minInterval = 1;
//   int maxInterval = 120;
//
//
//   // BAR IS BEAT PER BPM
//   int bar = 1;
//   int minBar = 1;
//   int maxBar = 60;
//
//
//   // TOTAL TICK IS USED TO IDENTIFY BEAT AUDIO
//   // TWO TYPE OF AUDIO TICK / TAP
//   int totalTick = 0;
//
//   Timer? update;
//
//   // INITIALIZE SOUND TO PRELOAD
//   initializedPlayer()async{
//     FlameAudio.play(AppConstant.clickSound,volume: 0);
//   }
//
//
//   // SET START TEMPO RANGE OF SLIDER
//   setStartTempo(double value){
//       startTempo = value;
//       bpm = startTempo;
//       notifyListeners();
//     if(isPlaying == true){
//       setTimer();
//     }
//   }
//
//
//   // SET TARGET RANGE OF SLIDER
//   setTargetTempo(double value){
//       targetTempo = value;
//       notifyListeners();
//     if(isPlaying){
//       setTimer();
//     }
//
//   }
//
//   // INCREASE INTERVAL
//   increaseInterval(){
//
//     if(interval<maxInterval){
//         interval = interval+1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   // DECREASE INTERVAL
//   decreaseInterval(){
//     if(interval>minInterval){
//         interval = interval-1;
//         notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   // INCREASE BAR
//   increaseBar(){
//     if(bar<maxBar){
//       bar = bar+1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   // DECREASE BAR
//   decreaseBar(){
//     if(bar>minBar){
//         bar = bar-1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   // START OR STOP AUDIO
//   void startStop() {
//     totalTick = 0;
//     if (isPlaying) {
//       if(_timer != null){
//         _timer!.cancel();
//       }
//       if(_intervalTimer != null){
//         _intervalTimer!.cancel();
//       }
//     } else {
//       setTimer();
//     }
//     isPlaying = !isPlaying;
//     notifyListeners();
//
//
//   }
//
//   setTimer(){
//     if(_timer != null){
//       _timer!.cancel();
//     }
//     _timer = Timer.periodic(
//       Duration( milliseconds: (60000 / bpm).round()),
//           (Timer timer) {
//           playSound();
//       },
//     );
//
//     if(_intervalTimer != null){
//       _intervalTimer!.cancel();
//     }
//     _intervalTimer = Timer.periodic(Duration(seconds: interval),(Timer timer) {
//       if(bpm < targetTempo){
//           bpm = bpm + interval;
//           notifyListeners();
//           _timer!.cancel();
//           _timer = Timer.periodic(
//               Duration( milliseconds: (60000 / bpm).round()),
//               (Timer timer) {
//                   playSound();
//           },
//        );
//
//       }else{
//         _intervalTimer!.cancel();
//         _timer!.cancel();
//         isPlaying = false;
//         notifyListeners();
//       }
//     });
//   }
//
//   Future playSound()async{
//     totalTick = totalTick+1;
//     if(totalTick == 1){
//         FlameAudio.play(AppConstant.clickSound);
//     }else{
//       if(totalTick<bar){
//         FlameAudio.play(AppConstant.tapSound);
//       }else{
//         FlameAudio.play(AppConstant.tapSound);
//          totalTick = 0;
//       }
//     }
//   }
//
//   Future stopSound()async{
//     totalTick = 0;
//   }
//
//   disposeController() {
//     if(_timer != null){
//       _timer!.cancel();
//     }
//     if(_intervalTimer != null){
//       _intervalTimer!.cancel();
//     }
//     isPlaying = false;
//      bpm = 40;
//      startTempo = 40;
//      targetTempo = 120;
//      interval = 1;
//      bar = 1;
//      totalTick = 0;
//      notifyListeners();
//
//   }
//
//
// }
//


//========================================================================


// class SpeedProvider extends ChangeNotifier{
//
//   bool isPlaying = false;
//
//   double bpm = 40;
//   final player = AudioPlayer();
//
//
//   Timer? _timer;
//   Timer? _intervalTimer;
//
//
//
//   double startTempo = 40;
//   double startTempoMin = 1;
//   double startTempoMax = 300;
//
//
//   double targetTempo = 120;
//   double targetTempoMin = 1;
//   double targetTempoMax = 300;
//
//
//
//
//   int interval = 1;
//   int minInterval = 1;
//   int maxInterval = 120;
//
//
//   int bar = 1;
//   int minBar = 1;
//   int maxBar = 60;
//
//
//   int totalTick = 0;
//
//   setStartTempo(double value){
//       startTempo = value;
//       bpm = startTempo;
//      notifyListeners();
//     if(isPlaying == true){
//       setTimer();
//     }
//   }
//
//
//   setTargetTempo(double value){
//       targetTempo = value;
//       notifyListeners();
//     if(isPlaying){
//       setTimer();
//     }
//
//   }
//
//   increaseInterval(){
//
//     if(interval<maxInterval){
//         interval = interval+1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//
//   }
//
//   decreaseInterval(){
//     if(interval>minInterval){
//         interval = interval-1;
//         notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   increaseBar(){
//     if(bar<maxBar){
//       bar = bar+1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   decreaseBar(){
//     if(bar>minBar){
//
//         bar = bar-1;
//       notifyListeners();
//       if(isPlaying){
//         setTimer();
//       }
//     }
//   }
//
//   void startStop() {
//     totalTick = 0;
//     if (isPlaying) {
//       if(_timer != null){
//         _timer!.cancel();
//       }
//       if(_intervalTimer != null){
//         _intervalTimer!.cancel();
//       }
//     } else {
//       setTimer();
//     }
//     isPlaying = !isPlaying;
//     notifyListeners();
//
//
//   }
//
//   setTimer(){
//
//     if(_timer != null){
//       _timer!.cancel();
//     }
//     _timer = Timer.periodic(
//       Duration( milliseconds: (60000 / bpm).round()),
//           (Timer timer) {
//         playSound();
//       },
//     );
//
//     if(_intervalTimer != null){
//       _intervalTimer!.cancel();
//     }
//     _intervalTimer = Timer.periodic(Duration(seconds: bar),(Timer timer) {
//       if(bpm < targetTempo){
//           bpm = bpm + interval;
//         notifyListeners();
//         if(_timer != null){
//           _timer!.cancel();
//         }
//         _timer = Timer.periodic(
//           Duration( milliseconds: (60000 / bpm).round()),
//               (Timer timer) {
//             playSound();
//           },
//         );
//       }else{
//
//         _intervalTimer!.cancel();
//         _timer!.cancel();
//         isPlaying = false;
//         notifyListeners();
//       }
//
//     });
//
//   }
//
//   Future playSound()async{
//
//     totalTick = totalTick+1;
//     notifyListeners();
//     if(totalTick == 1){
//       await player.setAudioSource(AudioSource.asset(AppConstant.clickSound));
//       if(player.playing == false){
//         await player.play();
//       }
//     }else{
//       if(totalTick<bar){
//         await player.setAudioSource(AudioSource.asset(AppConstant.tapSound));
//         if(player.playing == false){
//           await player.play();
//         }
//       }else{
//         await player.setAudioSource(AudioSource.asset(AppConstant.tapSound));
//         if(player.playing == false){
//           await player.play();
//         }
//         totalTick = 0;
//         notifyListeners();
//       }
//     }
//   }
//
//   Future stopSound()async{
//     if(player.playing){
//       await player.stop();
//     }
//     totalTick = 0;
//   }
//
//   disposeController() {
//     if(_timer != null){
//       _timer!.cancel();
//     }
//     if(_intervalTimer != null){
//       _intervalTimer!.cancel();
//     }
//   }
//
//
// }

