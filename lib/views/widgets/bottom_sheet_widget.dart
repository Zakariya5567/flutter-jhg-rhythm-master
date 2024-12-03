import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';

import 'beats_number_button.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.numbers,
    required this.onAdd,
    required this.onSubtract,
  });

  final String title;
  final String subtitle;
  final String numbers;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: JHGTextStyles.lrlabelStyle.copyWith(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: JHGTextStyles.subLabelStyle.copyWith(fontSize: 14),
        ),
        SizedBox(height: 17),
        Center(
          child: BeatsNumberButton(
              numbers: numbers, onAdd: onAdd, onSubtract: onSubtract),
        ),
      ],
    );
  }
}
