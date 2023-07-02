import 'package:dynamic_searchbar/src/constants/enums.dart';
import 'package:flutter/material.dart';

/// The object created by this class is used in the widgets related to
/// the filter.
///
/// [title] is the name given to the filter.
/// For example, the hiredDate field can be named Hired date.
///
/// [field] defines the field of the specified data to be filtered.
/// For example, the firstname or gender fields of the Employee class
/// can be defined.
///
/// [type] is set to [FilterType.stringFilter] by default.
/// In [type], select the filter type. There are types of
/// [FilterType.stringFilter], [FilterType.numberRangeFilter],
/// [FilterType.dateRangeFilter], [FilterType.selectionFilter].
///  * [FilterType.stringFilter] - When searching by text, use the this type.
///  * [FilterType.dateRangeFilter] - Use this type when searching between dates.
///  * [FilterType.numberRangeFilter] - Use this type when
/// searching between number ranges.
///  * [FilterType.selectionFilter] - The this type is used when
/// checking whether the selected value matches.
///
/// The [searchKey] and [searchKeyOperator] fields must be defined when
/// the [FilterType.stringFilter] type is selected. Specify the value to
/// search for in [searchKey].
/// [searchKeyOperator] is set to [StringOperator.contains] by default.
/// [searchKeyOperator] specifies how to search, such as whether
/// the [key] contains or is an exact match.
/// [searchKeyOperator] has the following types:
///  * [StringOperator.contains] - Checks if it contains [key].
///  * [StringOperator.equals] - Checks for an exact match with [key].
///  * [StringOperator.startsWith] - Checks if it starts with [key].
///  * [StringOperator.endsWith] - Checks if it ends with [key].
///
/// The [numberRange] field must be defined when
/// the [FilterType.numberRangeFilter] type is selected.
/// The [numberRange] field is of type [RangeValues] and
/// specifies the start and end numbers.
///
/// The [dateRange] field must be defined when
/// the [FilterType.dateRangeFilter] type is selected.
/// The [numberRange] field is of type [DateTimeRange] and
/// specifies the start and end dates.
///
/// Example:
/// ```dart
/// final List<FilterAction> employeeFilter = [
///  FilterAction(
///    title: 'Firstname',
///    field: 'firstname',
///  ),
///  FilterAction(
///    title: 'Age',
///    field: 'age',
///   type: FilterType.numberRangeFilter,
///   numberRange: const RangeValues(18, 65),
///  ),
///  FilterAction(
///    title: 'Hired date',
///    field: 'hiredDate',
///    type: FilterType.dateRangeFilter,
///    dateRange: DateTimeRange(
///      start: DateTime.now(),
///      end: DateTime.now(),
///    ),
///  ),
/// ];
/// ```
class FilterAction {
  FilterAction({
    required this.title,
    required this.field,
    this.type = FilterType.stringFilter,
    this.searchKey,
    this.searchKeyOperator = StringOperator.contains,
    this.numberRange,
    this.maxNumberRange,
    this.minNumberRange,
    this.dateRange,
  });

  /// [title] is the name given to the filter.
  /// For example, the hiredDate field can be named Hired date.
  final String title;

  /// [field] defines the field of the specified data to be filtered.
  /// For example, the firstname or gender fields of the Employee class
  /// can be defined.
  final String field;

  /// [type] is set to [FilterType.stringFilter] by default.
  /// In [type], select the filter type. There are types of
  /// [FilterType.stringFilter], [FilterType.numberRangeFilter],
  /// [FilterType.dateRangeFilter], [FilterType.selectionFilter].
  ///  * [FilterType.stringFilter] - When searching by text, use the this type.
  ///  * [FilterType.dateRangeFilter] - Use this type when searching between dates.
  ///  * [FilterType.numberRangeFilter] - Use this type when
  /// searching between number ranges.
  ///  * [FilterType.selectionFilter] - The this type is used when
  /// checking whether the selected value matches.
  final FilterType type;

  /// the [FilterType.stringFilter] type is selected. Specify the value to
  /// search for in [searchKey].
  final String? searchKey;

  /// [searchKeyOperator] is set to [StringOperator.contains] by default.
  /// [searchKeyOperator] specifies how to search, such as whether
  /// the [key] contains or is an exact match.
  /// [searchKeyOperator] has the following types:
  ///  * [StringOperator.contains] - Checks if it contains [key].
  ///  * [StringOperator.equals] - Checks for an exact match with [key].
  ///  * [StringOperator.startsWith] - Checks if it starts with [key].
  ///  * [StringOperator.endsWith] - Checks if it ends with [key].
  final StringOperator searchKeyOperator;

  /// The [numberRange] field must be defined when
  /// the [FilterType.numberRangeFilter] type is selected.
  /// The [numberRange] field is of type [RangeValues] and
  /// specifies the start and end numbers.
  final RangeValues? numberRange;

  /// The [maxNumberRange] field must be defined when
  /// the [FilterType.numberRangeFilter] type is selected.
  /// [maxNumberRange] specifies the upper limit of the number range.
  final double? maxNumberRange;

  /// The [minNumberRange] field must be defined when
  /// the [FilterType.numberRangeFilter] type is selected.
  /// [maxNumberRange] specifies the lower bound of the number range.
  final double? minNumberRange;

  /// The [dateRange] field must be defined when
  /// the [FilterType.dateRangeFilter] type is selected.
  /// The [numberRange] field is of type [DateTimeRange] and
  /// specifies the start and end dates.
  final DateTimeRange? dateRange;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'field': field,
      'type': type.name,
      'searchKey': searchKey,
      'numberRange': numberRange != null
          ? {
              'start': numberRange?.start,
              'end': numberRange?.end,
            }
          : null,
      'maxNumberRange': maxNumberRange,
      'minNumberRange': minNumberRange,
      'dateRange': dateRange != null
          ? {
              'start': dateRange?.start.toUtc().toIso8601String(),
              'end': dateRange?.end.toUtc().toIso8601String(),
            }
          : null,
    }..removeWhere((key, value) => value == null);
  }
}

/// The object created by this class is used in the widgets related to
/// the sort.
///
/// [title] is the name given to the sort.
/// For example, the hiredDate field can be named Hired date.
///
/// [field] defines the field of the specified data to be sorted.
/// For example, the firstname or age fields of the Employee class
/// can be defined.
///
/// [order] is set to [OrderType.asc] by default.
/// In [order], select the type to sort. There are types of
/// [OrderType.asc], [OrderType.desc].
///  * [OrderType.asc] - used for ascending order.
///  * [OrderType.desc] - used for descending order.
///
/// Example:
/// ```dart
/// final List<SortAction> employeeSort = [
///  SortAction(
///    title: 'Firstname ASC',
///    field: 'firstname',
///  ),
///  SortAction(
///    title: 'Hired date DESC',
///    field: 'hiredDate',
///    order: OrderType.desc,
///  ),
/// ];
/// ```
class SortAction {
  SortAction({
    required this.title,
    required this.field,
    this.order = OrderType.asc,
  });

  /// [title] is the name given to the sort.
  /// For example, the hiredDate field can be named Hired date.
  final String title;

  /// [field] defines the field of the specified data to be sorted.
  /// For example, the firstname or age fields of the Employee class
  /// can be defined.
  final String field;

  /// [order] is set to [OrderType.asc] by default.
  /// In [order], select the type to sort. There are types of
  /// [OrderType.asc], [OrderType.desc].
  ///  * [OrderType.asc] - used for ascending order.
  ///  * [OrderType.desc] - used for descending order.
  final OrderType order;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'field': field,
      'order': order.name,
    }..removeWhere((key, value) => value == null);
  }
}

class SearchAction {
  final FilterAction filter;
  final SortAction sort;

  SearchAction({
    required this.filter,
    required this.sort,
  });
}
