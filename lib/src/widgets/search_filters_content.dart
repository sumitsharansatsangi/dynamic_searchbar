import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:dynamic_searchbar/src/models/tag.dart';
import 'package:dynamic_searchbar/src/widgets/filters/datetime_range_filter.dart';
import 'package:dynamic_searchbar/src/widgets/filters/number_range_filter.dart';
import 'package:dynamic_searchbar/src/widgets/filters/string_filter.dart';
import 'package:dynamic_searchbar/src/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchFiltersContent extends StatefulWidget {
  const SearchFiltersContent({
    Key? key,
    required this.searchState,
    required this.filters,
    required this.sorts,
    required this.searchSink,
    required this.onClose,
  }) : super(key: key);

  final SearchState searchState;
  final List<FilterAction> filters;
  final List<SortAction> sorts;
  final StreamSink<SearchState> searchSink;
  final Function() onClose;

  @override
  State<SearchFiltersContent> createState() => _SearchFiltersContentState();
}

class _SearchFiltersContentState extends State<SearchFiltersContent> {
  @override
  Widget build(BuildContext context) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    return HookBuilder(
      builder: (BuildContext context) {
        final filterList = useState<List<Tag>>([]);
        final sortList = useState<List<Tag>>([]);

        final tempFilters = useState<List<FilterAction>>([]);
        final tempSorts = useState<List<SortAction>>([]);

        useEffect(() {
          _setInit(
            tempFilters,
            filterList,
            tempSorts,
            sortList,
            widget.searchState,
          );

          return;
        }, []);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(themeData?.filterTitle ?? 'Filters'),
              const Divider(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filterList.value.asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      Tag filter = entry.value;
                      FilterAction filterEntry = filter.entry as FilterAction;

                      if (filterEntry.type == FilterType.dateRangeFilter) {
                        return DateTimeRangeFilter(
                          key: ObjectKey(filterEntry.field),
                          dateRange: filterEntry.dateRange!,
                          field: filterEntry.field,
                          onChanged: (dateTimeRange) {
                            filterEntry = FilterAction(
                              title: filterEntry.title,
                              field: filterEntry.field,
                              searchKey: filterEntry.searchKey,
                              numberRange: filterEntry.numberRange,
                              dateRange: dateTimeRange,
                              type: filterEntry.type,
                            );

                            final tempFilter = Tag(
                              entry: filterEntry,
                              isSelected: true,
                            );

                            if (filterList.value[index].isSelected) {
                              final index = tempFilters.value.indexWhere(
                                  (element) =>
                                      element.field == filter.entry.field);

                              if (index != -1) {
                                tempFilters.value[index] = tempFilter.entry;
                              }
                            } else {
                              tempFilters.value.add(tempFilter.entry);
                            }

                            filterList.value[index] = tempFilter;

                            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                            filterList.notifyListeners();
                          },
                        );
                      } else if (filterEntry.type ==
                          FilterType.numberRangeFilter) {
                        return NumberRangeFilter(
                          key: ObjectKey(filterEntry.field),
                          values: filterEntry.numberRange!,
                          min: filterEntry.minNumberRange!,
                          max: filterEntry.maxNumberRange!,
                          onChanged: (newValues) {
                            filterEntry = FilterAction(
                              title: filterEntry.title,
                              field: filterEntry.field,
                              numberRange: newValues,
                              maxNumberRange: filterEntry.maxNumberRange,
                              minNumberRange: filterEntry.minNumberRange,
                              searchKey: filterEntry.searchKey,
                              dateRange: filterEntry.dateRange,
                              type: filterEntry.type,
                            );

                            final tempFilter = Tag(
                              entry: filterEntry,
                              isSelected: true,
                            );

                            if (filterList.value[index].isSelected) {
                              final index = tempFilters.value.indexWhere(
                                  (element) =>
                                      element.field == filter.entry.field);

                              if (index != -1) {
                                tempFilters.value[index] = tempFilter.entry;
                              }
                            } else {
                              tempFilters.value.add(tempFilter.entry);
                            }

                            filterList.value[index] = tempFilter;

                            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                            filterList.notifyListeners();
                          },
                        );
                      }

                      return StringFilter(
                        key: ObjectKey(filterEntry.field),
                        hintText: filterEntry.title,
                        searchKey: filterEntry.searchKey ?? '',
                        onChanged: (text, operator) {
                          filterEntry = FilterAction(
                            title: filterEntry.title,
                            field: filterEntry.field,
                            searchKey: text,
                            searchKeyOperator: operator,
                            numberRange: filterEntry.numberRange,
                            dateRange: filterEntry.dateRange,
                            type: filterEntry.type,
                          );

                          final tempFilter = Tag(
                            entry: filterEntry,
                            isSelected: true,
                          );

                          if (filterList.value[index].isSelected) {
                            final index = tempFilters.value.indexWhere(
                                (element) =>
                                    element.field == filter.entry.field);

                            if (index != -1) {
                              tempFilters.value[index] = tempFilter.entry;
                            }
                          } else {
                            tempFilters.value.add(tempFilter.entry);
                          }

                          filterList.value[index] = tempFilter;

                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          filterList.notifyListeners();
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(themeData?.sortTitle ?? 'Sorts'),
              const Divider(),
              Container(
                constraints: const BoxConstraints(maxHeight: 124),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: sortList.value.asMap().entries.map(
                      (entry) {
                        int index = entry.key;
                        Tag sort = entry.value;

                        SortAction sortEntry = sort.entry as SortAction;

                        return TagWidget(
                          onTap: () {
                            final tempSort = Tag(
                              entry: sort.entry,
                              isSelected: !sort.isSelected,
                            );

                            sortList.value[index] = tempSort;

                            if (tempSort.isSelected) {
                              tempSorts.value.add(tempSort.entry);
                            } else {
                              tempSorts.value.removeWhere(
                                  (element) => element == tempSort.entry);
                            }

                            // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                            filterList.notifyListeners();
                          },
                          entry: sortEntry,
                          isSort: true,
                          isSelected: sort.isSelected,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onClose();
                      },
                      style: themeData?.cancelButton.style,
                      child: Text(themeData?.cancelButton.title ?? 'Cancel'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.searchSink.add(SearchState.init());

                        _setInit(
                          tempFilters,
                          filterList,
                          tempSorts,
                          sortList,
                          SearchState.init(),
                        );
                      },
                      style: themeData?.clearFilterButton.style,
                      child: Text(
                          themeData?.clearFilterButton.title ?? 'Clear filter'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.searchSink.add(SearchState(
                        tempFilters.value,
                        tempSorts.value,
                      ));

                      widget.onClose();
                    },
                    style: themeData?.applyButton.style,
                    child: Text(themeData?.applyButton.title ?? 'Apply'),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _setInit(
    ValueNotifier<List<FilterAction>> tempFilters,
    ValueNotifier<List<Tag<dynamic>>> filterList,
    ValueNotifier<List<SortAction>> tempSorts,
    ValueNotifier<List<Tag<dynamic>>> sortList,
    SearchState searchState,
  ) {
    for (var filter in widget.filters) {
      final selectedFilter = searchState.filters
          .firstWhereOrNull((element) => element.field == filter.field);

      if (selectedFilter != null) {
        tempFilters.value.add(selectedFilter);
        filterList.value.add(Tag(entry: selectedFilter, isSelected: true));
      } else {
        filterList.value.add(Tag(entry: filter));
      }
    }

    for (var sort in widget.sorts) {
      final selectedSort = searchState.sorts
          .firstWhereOrNull((element) => element.field == sort.field);

      if (selectedSort != null) {
        tempSorts.value.add(sort);
        sortList.value.add(Tag(entry: sort, isSelected: true));
      } else {
        sortList.value.add(Tag(entry: sort));
      }
    }
  }
}
