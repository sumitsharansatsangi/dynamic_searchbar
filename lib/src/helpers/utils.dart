import 'dart:convert';

import 'package:dynamic_searchbar/src/constants/enums.dart';
import 'package:dynamic_searchbar/src/models/search_action.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateTimeToString(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  return formatter.format(date);
}

bool isFieldKeyExisted(List fields, List items) {
  bool isAllExisted = false;

  if (items.isEmpty || fields.isEmpty) {
    return true;
  }

  Map mappedItem = jsonDecode(jsonEncode(items.first));
  for (var field in fields) {
    if (mappedItem.containsKey(field)) {
      isAllExisted = true;
    } else {
      isAllExisted = false;
      break;
    }
  }

  return isAllExisted;
}

bool isDuplicatedFilters(List entries) {
  bool isDuplicated = false;

  List fields = [];

  for (var entry in entries) {
    if (fields.contains(entry.field)) {
      isDuplicated = true;
      break;
    } else {
      fields.add(entry.field);
    }
  }

  return isDuplicated;
}

bool isDuplicatedSorts(List entries) {
  bool isDuplicated = false;

  List fields = [];
  List ids = [];

  for (var index = 0; index < entries.length; index++) {
    var entry = entries[index];

    var fieldIndex = fields.indexWhere((element) => element == entry.field);

    if (fieldIndex != -1 && entries[ids[fieldIndex]].order == entry.order) {
      isDuplicated = true;
      break;
    } else {
      ids.add(index);
      fields.add(entry.field);
    }
  }

  return isDuplicated;
}

bool isMobileLayout(BuildContext context) {
  final size = MediaQuery.of(context).size;
  double deviceWidth = size.shortestSide;
  if (kIsWeb) {
    deviceWidth = size.width;
  }

  return deviceWidth < 600;
}

List multisort(List entries, List<SortAction> sorts) {
  if (sorts.isEmpty) return entries;

  int compare(int i, dynamic a, dynamic b) {
    Map map1 = jsonDecode(jsonEncode(a));
    Map map2 = jsonDecode(jsonEncode(b));

    if (OrderType.asc == sorts[i].order) {
      return map1[sorts[i].field].compareTo(map2[sorts[i].field]);
    } else {
      return -map1[sorts[i].field].compareTo(map2[sorts[i].field]);
    }
  }

  int sortall(a, b) {
    int i = 0;
    int result = 0;
    while (i < sorts.length) {
      result = compare(i, a, b);
      if (result != 0) break;
      i++;
    }
    return result;
  }

  entries.sort((a, b) => sortall(a, b));

  return entries;
}

List filterList({
  required SearchState searchKey,
  required List data,
  bool disableFilter = false,
}) {
  final filters = searchKey.filters;
  final sorts = searchKey.sorts;

  if (disableFilter) return data;

  if (filters.isEmpty) return multisort(data, sorts);

  List<dynamic> filteredList = [...data];

  var searchMethod = _searchString;

  for (var filter in filters) {
    // Default: FilterType.stringFilter
    switch (filter.type) {
      case FilterType.dateRangeFilter:
        searchMethod = _searchDateRange;
        break;
      case FilterType.numberRangeFilter:
        searchMethod = _searchNumberRange;
        break;
      case FilterType.selectionFilter:
        break;
      default:
        if (filter.searchKey!.isEmpty) continue;
        searchMethod = _searchString;
    }

    final tempList = filteredList.where((entry) {
      Map map = jsonDecode(jsonEncode(entry));

      bool isContains = false;

      isContains = searchMethod(filter, map);

      return isContains;
    }).toList();

    filteredList.clear();
    filteredList.addAll(tempList);
  }

  return multisort(filteredList, sorts);
}

bool _searchNumberRange(FilterAction filter, Map<dynamic, dynamic> map) {
  double startNumber = filter.numberRange!.start;
  double endNumber = filter.numberRange!.end;
  double targetNumber = map[filter.field].toDouble();

  if (targetNumber >= startNumber && targetNumber <= endNumber) {
    return true;
  }

  return false;
}

bool _searchDateRange(FilterAction filter, Map<dynamic, dynamic> map) {
  DateTime targetDate = DateTime.parse(map[filter.field]);
  DateTime startDate = filter.dateRange!.start;
  DateTime endDate = filter.dateRange!.end;

  if (startDate.isBefore(targetDate) && endDate.isAfter(targetDate)) {
    return true;
  }

  return false;
}

bool _searchString(FilterAction filter, Map<dynamic, dynamic> map) {
  final key = filter.searchKey;
  final operator = filter.searchKeyOperator;

  // Default: StringOperator.contains
  switch (operator) {
    case StringOperator.equals:
      return map[filter.field].toLowerCase() == key?.toLowerCase();
    case StringOperator.startsWith:
      return map[filter.field].toLowerCase().startsWith(key?.toLowerCase());
    case StringOperator.endsWith:
      return map[filter.field].toLowerCase().endsWith(key?.toLowerCase());
    default:
      return map[filter.field].toLowerCase().contains(key?.toLowerCase());
  }
}

SearchState removeFilter({
  required SearchState searchAction,
  FilterAction? filter,
  SortAction? sort,
}) {
  final temp = searchAction.clone();

  if (filter != null) temp.filters.remove(filter);

  if (sort != null) temp.sorts.remove(sort);

  return temp;
}
