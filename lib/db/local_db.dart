
import 'package:reg_page/reg_page.dart';

class SharedPref {

  static String defaultBpmKey = "defaultBpmKey";
  static String defaultSoundKey = "defaultSoundKey";
  static String defaultTimingKey = "defaultTimingKey";

  // Store default BPM
  static Future<void> storeDefaultBPM(double value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setDouble(defaultBpmKey, value);
  }

  // Get default BPM
  static Future<double?> get getDefaultBPM async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    double? bpm = pref!.getDouble(defaultBpmKey);
    return bpm;
  }


  // Set default sound
  static Future<void> storeDefaultSound(int value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setInt(defaultSoundKey, value);
  }

  // Get default sound
  static Future<int?> get getDefaultSound async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    int? bpm = pref!.getInt(defaultSoundKey);
    return bpm;
  }



  // Set default timing
  static Future<void> storeDefaultTiming(int value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setInt(defaultTimingKey, value);
  }

  // Get default timing
  static Future<int?> get getDefaultTiming async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    int? bpm = pref!.getInt(defaultTimingKey);
    return bpm;
  }



}