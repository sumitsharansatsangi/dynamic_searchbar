import 'package:dynamic_searchbar/src/constants/enums.dart';
import 'package:dynamic_searchbar/src/helpers/utils.dart';
import 'package:dynamic_searchbar/src/widgets/global_searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagWidget<T> extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.entry,
    this.onTap,
    this.onRemove,
    this.isSelected,
    this.isSort,
    this.dismissible,
  });

  final dynamic entry;
  final Function()? onTap;
  final Function()? onRemove;
  final bool? isSelected;
  final bool? isSort;
  final bool? dismissible;

  @override
  Widget build(BuildContext context) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    var decoration = themeData?.tagTheme.decoration ??
        BoxDecoration(
          border: Border.all(
            color: themeData?.primaryColor ?? Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(8.0),
        );

    var selectedDecoration = themeData?.tagTheme.selectedDecoration ??
        BoxDecoration(
          color: themeData?.primaryColor ?? Theme.of(context).primaryColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        );

    return Card(
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: isSelected == true || dismissible == true
              ? selectedDecoration
              : decoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.title),
              if (dismissible == true && isSort != true)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0 / 2),
                  child: entry.type == FilterType.stringFilter
                      ? Text('key: ${entry.searchKey}')
                      : entry.type == FilterType.dateRangeFilter
                          ? Text(
                              'from: ${dateTimeToString(entry.dateRange.start)}, to: ${dateTimeToString(entry.dateRange.end)}')
                          : Text(
                              'from: ${entry.numberRange.start}, to: ${entry.numberRange.end}'),
                ),
              if (isSort == true)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0 / 2),
                  child: entry.order == OrderType.asc
                      ? const Icon(
                          CupertinoIcons.sort_up,
                          size: 16,
                        )
                      : const Icon(
                          CupertinoIcons.sort_down,
                          size: 16,
                        ),
                ),
              if (dismissible == true)
                InkWell(
                  onTap: () => onRemove?.call(),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
