import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:flutter/material.dart';

final List<FilterAction> employeeFilter = [
  FilterAction(title: 'Firstname', field: 'firstname'),
  FilterAction(
    title: 'Age',
    field: 'age',
    type: FilterType.numberRangeFilter,
    numberRange: const RangeValues(18, 65),
    maxNumberRange: 100,
    minNumberRange: 0,
  ),
  FilterAction(
    title: 'Hired date',
    field: 'hiredDate',
    type: FilterType.dateRangeFilter,
    dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
  ),
];
