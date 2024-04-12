import 'package:flutter/cupertino.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';

class BpmValueWidget extends StatelessWidget {
  BpmValueWidget({super.key, required this.bpmValue});

  String bpmValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // bpmValue.toText(
        //   textAlign: TextAlign.center,
        //   fontWeight: FontWeight.w500,
        //   color: JHGColors.whiteText,
        //   fontSize: 35,
        //   lineHeight: 1.0,
        // ),
        Text(bpmValue, style: JHGTextStyles.bigNumberStyle),
        Text(
          'BPM',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: JHGColors.whiteText,
          ),
        )
      ],
    );
  }
}
