import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:rhythm_master/model/sound_model.dart';
import 'package:rhythm_master/utils/app_%20colors.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.closedColor,
    this.expandedColor,
    this.hint,
    this.label,
  });

  final SoundModel? value;
  final String? hint;
  final List<SoundModel>? items;
  final Color? closedColor;
  final Color? expandedColor;
  final String? label;
  final void Function(SoundModel?)? onChanged;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.titleMedium!.copyWith(
        overflow: TextOverflow.ellipsis, color: AppColors.textHeadingColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(label!),
          ),
        CustomDropdown<SoundModel>(
          closedHeaderPadding:
              EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          // hideSelectedFieldWhenExpanded: true,
          hintText: hint,
          decoration: CustomDropdownDecoration(
            closedFillColor: closedColor ?? AppColors.liteWhite,
            expandedFillColor: expandedColor ?? AppColors.liteWhite,
            listItemStyle: style,
            closedSuffixIcon:
                Icon(Icons.arrow_drop_down, color: AppColors.textHeadingColor),
            expandedSuffixIcon: Icon(Icons.arrow_drop_up_rounded,
                color: AppColors.textHeadingColor),
            headerStyle: style,
          ),
          initialItem: value == null
              ? items != null
                  ? items!.first
                  : null
              : value,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
