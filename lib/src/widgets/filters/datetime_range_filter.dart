import 'dart:math';

import 'package:dynamic_searchbar/src/helpers/utils.dart';
import 'package:dynamic_searchbar/src/widgets/global_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DateTimeRangeFilter extends HookWidget {
  const DateTimeRangeFilter({
    super.key,
    required this.dateRange,
    required this.onChanged,
    required this.field,
  });

  final DateTimeRange dateRange;
  final Function(DateTimeRange) onChanged;
  final String field;

  @override
  Widget build(BuildContext context) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    final startDate = useTextEditingController(
      text: dateTimeToString(dateRange.start),
    );
    final endDate = useTextEditingController(
      text: dateTimeToString(dateRange.end),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              key: ValueKey('${field}Start'),
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: [DateTextFormatter()],
              controller: startDate,
              onChanged: (value) {
                if (value.length == 10) {
                  final dateTimeRange = DateTimeRange(
                    start: DateTime.parse(value),
                    end: DateTime.parse(endDate.text),
                  );

                  onChanged(dateTimeRange);
                }
              },
              style: themeData?.dateRangeTheme.style,
              decoration:
                  themeData?.dateRangeTheme.decoration ??
                  InputDecoration(
                    hintText: 'Start date',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color:
                            themeData?.primaryColor ??
                            Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                    ),
                  ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              key: ValueKey('${field}End'),
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: [DateTextFormatter()],
              controller: endDate,
              onChanged: (value) {
                if (value.length == 10) {
                  final dateTimeRange = DateTimeRange(
                    start: DateTime.parse(startDate.text),
                    end: DateTime.parse(value),
                  );

                  onChanged(dateTimeRange);
                }
              },
              style: themeData?.dateRangeTheme.style,
              decoration:
                  themeData?.dateRangeTheme.decoration ??
                  InputDecoration(
                    hintText: 'End date',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color:
                            themeData?.primaryColor ??
                            Theme.of(context).primaryColor,
                        width: 1.0,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTextFormatter extends TextInputFormatter {
  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String separator = '-';
    var text = _format(newValue.text, oldValue.text, separator);

    return newValue.copyWith(
      text: text,
      selection: updateCursorPosition(oldValue, text),
    );
  }

  String _format(String value, String oldValue, String separator) {
    var isErasing = value.length < oldValue.length;
    var isComplete = value.length > _maxChars + 2;

    if (!isErasing && isComplete) {
      return oldValue;
    }

    value = value.replaceAll(separator, '');
    final result = <String>[];

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      result.add(value[i]);

      if ((i == 3 || i == 5) && i != value.length - 1) {
        result.add(separator);
      }
    }

    return result.join();
  }

  TextSelection updateCursorPosition(TextEditingValue oldValue, String text) {
    var endOffset = max(oldValue.text.length - oldValue.selection.end, 0);

    var selectionEnd = text.length - endOffset;

    return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
  }
}
