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
        bpmValue.toText(
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          color: JHGColors.whiteText,
          fontSize: 35,
          lineHeight: 1.0
        ),
       'BPM'.toText(
          textAlign: TextAlign.center,
      fontSize: 35,
      fontWeight: FontWeight.w500,
      color: JHGColors.whiteText,
        ),

      ],
    );
  }
}
