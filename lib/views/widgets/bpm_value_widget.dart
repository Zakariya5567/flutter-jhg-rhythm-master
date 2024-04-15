import 'package:flutter/cupertino.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';
import 'package:rhythm_master/views/extension/string_extension.dart';

class BpmValueWidget extends StatelessWidget {
  BpmValueWidget({super.key,required this.bpmValue});
  String bpmValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          bpmValue,
          textAlign: TextAlign.center,
          style:
          TextStyle(
            fontFamily: kFontFamilyJak,
            package: kPkgName,
            color: JHGColors.whiteText,
            height: 1.0,
            fontSize: 35,
            fontWeight: FontWeight.w700,
          ),


        ),
        Text(
        'BPM',
        textAlign: TextAlign.center,
        style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w500,
        color:  JHGColors.greyText,
        ),
        )
      ],
    );
  }
}
