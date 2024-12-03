import 'package:rhythm_master/utils/app_assets.dart';

import '../utils/app_strings.dart';

class SoundModel {
  int? id;
  String? name;
  String? beat1;
  String? beat2;

  SoundModel(
      {required this.id,
      required this.name,
      required this.beat1,
      required this.beat2});

  @override
  String toString() {
    return name!;
  }
}

List<SoundModel> soundList = [
  SoundModel(
      id: 0,
      name: AppStrings.logic,
      beat1: AppAssets.logic1Sound,
      beat2: AppAssets.logic2Sound),
  SoundModel(
      id: 1,
      name: AppStrings.click,
      beat1: AppAssets.click1Sound,
      beat2: AppAssets.click2Sound),
  SoundModel(
      id: 2,
      name: AppStrings.drumsticks,
      beat1: AppAssets.drumsticks1Sound,
      beat2: AppAssets.drumsticks2Sound),
  SoundModel(
      id: 3,
      name: AppStrings.ping,
      beat1: AppAssets.ping1Sound,
      beat2: AppAssets.ping2Sound),
  SoundModel(
      id: 4,
      name: AppStrings.seiko,
      beat1: AppAssets.seiko1Sound,
      beat2: AppAssets.seiko2Sound),
  SoundModel(
      id: 5,
      name: AppStrings.ableton,
      beat1: AppAssets.ableton1Sound,
      beat2: AppAssets.ableton2Sound),
  SoundModel(
      id: 6,
      name: AppStrings.cubase,
      beat1: AppAssets.cubase1Sound,
      beat2: AppAssets.cubase2Sound),
  SoundModel(
      id: 7,
      name: AppStrings.flStudio,
      beat1: AppAssets.flStudio1Sound,
      beat2: AppAssets.flStudio2Sound),
  SoundModel(
      id: 8,
      name: AppStrings.maschine,
      beat1: AppAssets.maschine1Sound,
      beat2: AppAssets.maschine2Sound),
  SoundModel(
      id: 9,
      name: AppStrings.protoolDefault,
      beat1: AppAssets.protoolsDefault1Sound,
      beat2: AppAssets.protoolsDefault2Sound),
  SoundModel(
      id: 10,
      name: AppStrings.protoolMarimba,
      beat1: AppAssets.protoolsMarimba1Sound,
      beat2: AppAssets.protoolsMarimba2Sound),
  SoundModel(
      id: 11,
      name: AppStrings.reason,
      beat1: AppAssets.reason1Sound,
      beat2: AppAssets.reason2Sound),
  SoundModel(
      id: 12,
      name: AppStrings.sonar,
      beat1: AppAssets.sonar1Sound,
      beat2: AppAssets.sonar2Sound),
];
