import '../app_utils/app_strings.dart';

class SoundModel{

   int? id;
   String? name;
   String? beat1;
   String? beat2;

   SoundModel({required this.id,required this.name,required this.beat1,required this.beat2});

   @override
  String toString() {
    return name!;
  }
}
List<SoundModel> soundList = [
SoundModel(
id: 0,
name: AppStrings.logic,
beat1: AppStrings.logic1Sound,
beat2: AppStrings.logic2Sound),
SoundModel(
id: 1,
name: AppStrings.click,
beat1: AppStrings.click1Sound,
beat2: AppStrings.click2Sound),
SoundModel(
id: 2,
name: AppStrings.drumsticks,
beat1: AppStrings.drumsticks1Sound,
beat2: AppStrings.drumsticks2Sound),
SoundModel(
id: 3,
name: AppStrings.ping,
beat1: AppStrings.ping1Sound,
beat2: AppStrings.ping2Sound),
SoundModel(
id: 4,
name: AppStrings.seiko,
beat1: AppStrings.seiko1Sound,
beat2: AppStrings.seiko2Sound),
SoundModel(
id: 5,
name: AppStrings.ableton,
beat1: AppStrings.ableton1Sound,
beat2: AppStrings.ableton2Sound),
SoundModel(
id: 6,
name: AppStrings.cubase,
beat1: AppStrings.cubase1Sound,
beat2: AppStrings.cubase2Sound),
SoundModel(
id: 7,
name: AppStrings.flStudio,
beat1: AppStrings.flStudio1Sound,
beat2: AppStrings.flStudio2Sound),
SoundModel(
id: 8,
name: AppStrings.maschine,
beat1: AppStrings.maschine1Sound,
beat2: AppStrings.maschine2Sound),
SoundModel(
id: 9,
name: AppStrings.protoolDefault,
beat1: AppStrings.protoolsDefault1Sound,
beat2: AppStrings.protoolsDefault2Sound),
SoundModel(
id: 10,
name: AppStrings.protoolMarimba,
beat1: AppStrings.protoolsMarimba1Sound,
beat2: AppStrings.protoolsMarimba2Sound),
SoundModel(
id: 11,
name: AppStrings.reason,
beat1: AppStrings.reason1Sound,
beat2: AppStrings.reason2Sound),
SoundModel(
id: 12,
name: AppStrings.sonar,
beat1: AppStrings.sonar1Sound,
beat2: AppStrings.sonar2Sound),
];