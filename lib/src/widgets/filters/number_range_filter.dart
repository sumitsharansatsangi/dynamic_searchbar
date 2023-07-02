import 'package:dynamic_searchbar/src/widgets/global_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NumberRangeFilter extends HookWidget {
  const NumberRangeFilter({
    Key? key,
    required this.values,
    required this.onChanged,
    required this.min,
    required this.max,
  }) : super(key: key);

  final RangeValues values;
  final Function(RangeValues) onChanged;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    final rangeValues = useState<RangeValues>(values);
    final maxValue = useState<double>(max);
    final minValue = useState<double>(min);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SliderTheme(
        data: themeData?.numberRangeTheme ??
            SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.always,
            ),
        child: RangeSlider(
          values: rangeValues.value,
          min: minValue.value,
          max: maxValue.value,
          labels: RangeLabels(
            rangeValues.value.start.round().toString(),
            rangeValues.value.end.round().toString(),
          ),
          divisions: maxValue.value.toInt(),
          onChanged: (newValues) {
            rangeValues.value = RangeValues(
              newValues.start.round().toDouble(),
              newValues.end.round().toDouble(),
            );
            onChanged(rangeValues.value);
          },
        ),
      ),
    );
  }
}
