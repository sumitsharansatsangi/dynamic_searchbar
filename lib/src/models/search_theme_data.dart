import 'package:flutter/material.dart';

/// Set the settings you want to customize in [searchThemeData].
/// Example:
/// ```dart
/// SearchThemeData(
///   filterIcon: Icons.filter_list_sharp,
///   title: 'Filter',
///   filterTitle: 'Filters',
///   sortTitle: 'Sorts',
///   primaryColor: Colors.tealAccent,
///   iconColor: const Color(0xFFE8E7E4),
///   applyButton: ActionButtonTheme(
///     title: 'Apply',
///     style: ButtonStyle(
///       backgroundColor:
///           MaterialStateProperty.all<Color>(const Color(0xFF348FFF)),
///     ),
///   ),
///   clearFilterButton: ActionButtonTheme(
///     title: 'Clear filter',
///     style: ButtonStyle(
///       backgroundColor:
///           MaterialStateProperty.all<Color>(const Color(0xFF3DD89B)),
///     ),
///   ),
///   cancelButton: ActionButtonTheme(
///     title: 'Cancel',
///     style: ButtonStyle(
///       backgroundColor:
///           MaterialStateProperty.all<Color>(const Color(0xFFE8E7E4)),
///     ),
///   ),
/// ),
/// ```

class SearchThemeData {
  SearchThemeData({
    this.filterIcon = Icons.filter_list_sharp,
    this.title = 'Filter',
    this.filterTitle = 'Filters',
    this.sortTitle = 'Sorts',
    this.primaryColor = Colors.blueAccent,
    this.iconColor = const Color(0xFFBBBECA),
    this.cancelButton = const ActionButtonTheme(
      title: 'Cancel',
      style: ButtonStyle(),
    ),
    this.clearFilterButton = const ActionButtonTheme(
      title: 'Clear filter',
      style: ButtonStyle(),
    ),
    this.applyButton = const ActionButtonTheme(
      title: 'Apply',
      style: ButtonStyle(),
    ),
    this.stringFilterTheme = const StringFilterTheme(prefixIcon: Icons.search),
    this.numberRangeTheme = const SliderThemeData(),
    this.dateRangeTheme = const DateRangeTheme(),
    this.tagTheme = const TagTheme(),
  });

  /// [filterIcon] is used for [SearchField].
  final IconData filterIcon;

  /// In [SearchField], the title is defined in the [title] field.
  final String title;

  /// In [SearchField], the title of the filter section is defined
  /// in the [filterTitle] field.
  final String filterTitle;

  /// In [SearchField], the title of the sort section is defined
  /// in the [sortTitle] field.
  final String sortTitle;

  /// Same as Primary color.
  final Color primaryColor;

  /// It will change the color of all icons.
  final Color iconColor;

  /// In [SearchField],  set the style of the cancel button.
  final ActionButtonTheme cancelButton;

  /// In [SearchField],  set the style of the clear button.
  final ActionButtonTheme clearFilterButton;

  /// In [SearchField],  set the style of the apply button.
  final ActionButtonTheme applyButton;

  /// Sets the style of the [FilterType.stringFilter] filter.
  final StringFilterTheme stringFilterTheme;

  /// Sets the style of the [FilterType.numberRangeFilter] filter.
  final SliderThemeData numberRangeTheme;

  /// Sets the style of the [FilterType.dateRangeFilter] filter.
  final DateRangeTheme dateRangeTheme;

  /// /// Sets the style of the tag.
  final TagTheme tagTheme;
}

class TagTheme {
  final BoxDecoration? decoration;
  final BoxDecoration? selectedDecoration;

  const TagTheme({this.decoration, this.selectedDecoration});
}

class DateRangeTheme {
  final TextStyle? style;
  final InputDecoration? decoration;

  const DateRangeTheme({this.style, this.decoration});
}

class StringFilterTheme {
  final IconData prefixIcon;
  final TextStyle? style;
  final InputDecoration? decoration;

  const StringFilterTheme({
    required this.prefixIcon,
    this.style,
    this.decoration,
  });
}

class ActionButtonTheme {
  final String title;
  final ButtonStyle style;

  const ActionButtonTheme({required this.title, required this.style});
}
