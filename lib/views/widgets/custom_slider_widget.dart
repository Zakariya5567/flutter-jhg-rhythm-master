
import 'package:flutter/material.dart';
import 'package:rhythm_master/utils/app_colors.dart';
import 'package:rhythm_master/views/widgets/custom_slider_track_shape.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required this.height,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final double height;
  final double min;
  final double max;
  final double value;
  final void Function(double)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: height * 0.016,
        ),
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: height * 0.008,
        trackShape: const CustomSliderTrackShape(),
      ),
      child: Slider(
        activeColor: AppColors.whitePrimary,
        inactiveColor: AppColors.whitePrimary,
        thumbColor: AppColors.whitePrimary,
        min: min,
        max: max,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
