import 'package:flutter/foundation.dart';


//The TapTempoProvider class handles tap tempo functionality, calculating BPM,
// and determining music tempo names based on the calculated BPM.

class TapTempoProvider extends ChangeNotifier{

  // List to store tap intervals

  List<double> tapIntervals = [];

  // Timestamp of the last tap
  double? tapTimestamp;

  // Calculated BPM value
  double? bpm ;

  // Music name based on BPM
  String musicName = '';


  double buttonScale = 1;
  // Handle tap event to calculate BPM
  void handleTap() {

    buttonScale = 1.2;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 200),(){
      buttonScale = 1;
      notifyListeners();
    });
    // Get current time in milliseconds
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();

    if (tapTimestamp != null) {
      // Calculate the interval between taps
      final interval = currentTime - tapTimestamp!;
      tapIntervals.add(interval);

      // Calculate average BPM
      final averageInterval = tapIntervals.reduce((a, b) => a + b) / tapIntervals.length;
      final newBpm = 60000 / averageInterval;
        bpm = newBpm;
        notifyListeners();
    }
    // Update tap timestamp
    tapTimestamp = currentTime;

    // Set music name based on BPM
    if(bpm != null){
      setAudioName();
    }
  }

  // Set audio name based on BPM range
  setAudioName(){
    if (bpm! <= 20) {
      musicName = "Larghissimo";
    }
    else if (bpm! >= 20  && bpm! <= 40 ) {
      musicName = "Grave";
    }
    else if (bpm! >= 40  && bpm! <= 45 ) {
      musicName = "Lento";
    }
    else if (bpm! >= 45  && bpm! <= 50 ) {
      musicName = "Largo";
    }
    else if (bpm! >= 55  && bpm! <= 65 ) {
      musicName = "Adagio";
    }
    else if (bpm! >= 65  && bpm! <= 69 ) {
      musicName = "Adagietto";
    }
    else if (bpm! >= 73  && bpm! <= 77 ) {
      musicName = "Andante";
    }
    else if (bpm! >= 86  && bpm! <= 97 ) {
      musicName = "Moderato";
    }
    else if (bpm! >= 98  && bpm! <= 109 ) {
      musicName = "Allegretto";
    }
    else if (bpm! >= 109  && bpm! <= 132 ) {
      musicName = "Allegro";
    }
    else if (bpm! >= 132  && bpm! < 140 ) {
      musicName = "Vivace";
    }
    else if (bpm! >= 168  && bpm! < 177 ) {
      musicName = "Presto";
    }
    else if (bpm! >= 178 ) {
      musicName = "Prestissimo";
    }
    else{
      musicName = " ";
    }
    notifyListeners();

  }


  // Clear BPM data and reset values
  void clearBPM() {
      tapTimestamp = null;
      musicName = '';
      tapIntervals.clear();
      bpm = null;
      notifyListeners();
  }


}