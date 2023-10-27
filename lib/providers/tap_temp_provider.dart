import 'package:flutter/foundation.dart';

class TapTempoProvider extends ChangeNotifier{

  List<double> tapIntervals = [];
  double? tapTimestamp;
  double? bpm ;
  String musicName = '';

  void handleTap() {

    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();

    if (tapTimestamp != null) {
      final interval = currentTime - tapTimestamp!;
      tapIntervals.add(interval);

      // Calculate average BPM
      final averageInterval = tapIntervals.reduce((a, b) => a + b) / tapIntervals.length;
      final newBpm = 60000 / averageInterval;
        bpm = newBpm;
        notifyListeners();
    }

    tapTimestamp = currentTime;
    if(bpm != null){
      setAudioName();
    }

  }

  setAudioName(){
    if (bpm! <= 20) {
      musicName = "Larghissimo";
    } else if (bpm! <= 40) {
      musicName = "Grave";
    } else if (bpm! <= 60) {
      musicName = "Largo";
    } else if (bpm! <= 66) {
      musicName = "Larghetto";
    } else if (bpm! <= 76) {
      musicName = "Adagio";
    } else if (bpm! <= 80) {
      musicName = "Adagietto";
    } else if (bpm! == 80) {
      musicName = "Tranquillo";
    } else if (bpm! <= 98) {
      musicName = "Andante";
    } else if (bpm! <= 120) {
      musicName = "Moderato";
    } else if (bpm! <= 128) {
      musicName = "Allegretto";
    } else if (bpm! <= 156) {
      musicName = "Allegro";
    } else if (bpm! <= 176) {
      musicName = "Vivace";
    } else if (bpm! <= 200) {
      musicName = "Presto";
    } else {
      musicName = "Prestissimo";
    }

  }

  void clearBPM() {
      tapTimestamp = null;
      musicName = '';
      tapIntervals.clear();
      bpm = null;
      notifyListeners();
  }


}