import 'package:reg_page/reg_page.dart';

class SharedPref {
  static String defaultBpmKey = "defaultBpmKey";
  static String defaultSoundKey = "defaultSoundKey";
  static String defaultTimingKey = "defaultTimingKey";
  static String speedTrainerTimingKey = "speedTrainerTimingKey";
  static String isFirstTimeOpenApp = "isFirstTimeOpenApp";
  static String speedTrainerDefaultSoundKey = "speedTrainerDefaultSoundKey";
  static String metronomeDefaultValueKey = "metronomeDefaultValueKey";
  static String speedTrainerDefaultValueKey = "speedTrainerDefaultValueKey";
  static String beatNumeratorKey = "beatNumeratorKey";
  static String beatDenominatorKey = "beatNumeratorKey";

  // Set [isFirstTimeOpenApp] value
  static Future<void> setIsFirstTimeOpenApp(bool value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setBool(isFirstTimeOpenApp, value);
  }

  // Get [isFirstTimeOpenApp] value
  static Future<bool?> get getIsFirstTimeOpenApp async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    bool? result = pref!.getBool(isFirstTimeOpenApp);
    return result;
  }

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

  // Set default Speed trainer sound
  static Future<void> storeSpeedTrainerDefaultSound(int value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setInt(speedTrainerDefaultSoundKey, value);
  }

  // Get default sound
  static Future<int?> get getStoreSpeedTrainerDefaultSound async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    int? key = pref!.getInt(speedTrainerDefaultSoundKey);
    return key;
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

  // Set default timing
  static Future<void> storeSpeedTrainerDefaultTiming(int value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setInt(speedTrainerTimingKey, value);
  }

  // Get default timing
  static Future<int?> get getSpeedTrainerDefaultTiming async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    int? bpm = pref!.getInt(speedTrainerTimingKey);
    return bpm;
  }

  // Set default timing
  static Future<void> storeMetronomeDefaultValue(String value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setString(metronomeDefaultValueKey, value);
  }

  // Get default timing
  static Future<String?> get getMetronomeDefaultValue async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    String? bpm = pref!.getString(metronomeDefaultValueKey);
    return bpm;
  }

  // Set default timing
  static Future<void> storeSpeedTrainerDefaultValue(String value) async {
    // initialized shared preferences
    final pref = await LocalDB.getPref;
    pref!.setString(speedTrainerDefaultValueKey, value);
  }

  // Get default timing
  static Future<String?> get getSpeedTrainerDefaultValue async {
    // Initialized shared preferences
    final pref = await LocalDB.getPref;
    String? bpm = pref!.getString(speedTrainerDefaultValueKey);
    return bpm;
  }

}