import 'package:flutter/cupertino.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';

// ignore: must_be_immutable
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
            color: JHGColors.white,
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
