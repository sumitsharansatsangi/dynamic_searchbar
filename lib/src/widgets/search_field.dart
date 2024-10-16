import 'dart:async';
import 'dart:convert';

import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:dynamic_searchbar/src/helpers/utils.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:dynamic_searchbar/src/widgets/search_filters_dialog.dart';
import 'package:dynamic_searchbar/src/widgets/search_filters_sheet.dart';
import 'package:dynamic_searchbar/src/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchField<T> extends StatefulHookWidget {
  /// Creates filter widget
  ///
  /// At the beginning, you need to define the [initialData], [sorts], and [filters] fields.
  /// In [initialData], specify the data you want to filter.
  ///
  /// When the [SearchField] state changes, our widget calls the [onChanged] callback.
  /// The value returned by [onChanged] callback will be filtered and sorted data.
  ///
  /// After filter and sort, [onFilter] callback returns the it as json.
  /// It is intended for use in the back-end.
  ///
  /// Example:
  /// ```dart
  /// SearchField(
  ///   // disableFilter: true,
  ///   filters: employeeFilter,
  ///   sorts: employeeSort,
  ///   initialData: sampleList,
  ///   onChanged: (List<Employee> data) => setState(
  ///     () => samples = data,
  ///   ),
  ///   onFilter: (Map filters) => print(filters),
  /// ),
  /// ```
  const SearchField({
    super.key,
    required this.filters,
    required this.sorts,
    required this.initialData,
    required this.onChanged,
    this.onFilter,
    this.disableFilter = false,
  });

  final List<FilterAction> filters;
  final List<SortAction> sorts;
  final List<T> initialData;
  final void Function(List<T> data) onChanged;
  final void Function(Map map)? onFilter;
  final bool disableFilter;

  @override
  State<SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<SearchField<T>> {
  StreamController<SearchState> streamController = StreamController();
  SearchState state = SearchState.init();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    assert(
        !isDuplicatedFilters(widget.filters), 'Cannot have the same filters');
    assert(!isDuplicatedSorts(widget.sorts), 'Cannot have the same sorts');

    super.initState();

    streamController.stream.listen(
      (event) => setState(
        () => state = event,
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    final searchFilters = state.filters;
    final searchSorts = state.sorts;

    useEffect(() {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final data = filterList(
          searchKey: state,
          data: widget.initialData,
          disableFilter: widget.disableFilter,
        );

        widget.onChanged(data.cast<T>());

        if (widget.onFilter != null) {
          final mappedFilter = json.encode(searchFilters);
          final mappedSort = json.encode(searchSorts);
          final map = {'filter': mappedFilter, 'sort': mappedSort};

          widget.onFilter?.call(map);
        }
      });

      return;
    }, [widget.initialData, state]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: searchFilters.isNotEmpty,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 48),
                  child: ReorderableListView(
                    scrollController: ScrollController(),
                    buildDefaultDragHandles: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        final temp = state.clone();

                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = temp.filters.removeAt(oldIndex);
                        temp.filters.insert(newIndex, item);

                        state = state.copyWith(filters: temp.filters);
                      });
                    },
                    children: searchFilters
                        .map(
                          (filter) => ReorderableDragStartListener(
                            key: UniqueKey(),
                            index: searchFilters.indexOf(filter),
                            child: TagWidget(
                              entry: filter,
                              dismissible: true,
                              onRemove: () => setState(
                                () => state = removeFilter(
                                    searchAction: state, filter: filter),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Visibility(
                visible: searchSorts.isNotEmpty,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 48),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: ReorderableListView(
                      scrollController: _scrollController,
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          final temp = state.clone();

                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = temp.sorts.removeAt(oldIndex);
                          temp.sorts.insert(newIndex, item);

                          state = state.copyWith(sorts: temp.sorts);
                        });
                      },
                      children: searchSorts
                          .map(
                            (sort) => ReorderableDragStartListener(
                              key: UniqueKey(),
                              index: searchSorts.indexOf(sort),
                              child: TagWidget(
                                entry: sort,
                                dismissible: true,
                                isSort: true,
                                onRemove: () => setState(
                                  () => state = removeFilter(
                                      searchAction: state, sort: sort),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            if (isMobileLayout(context)) {
              SearchFiltersSheet(context).showSheet(
                searchState: state,
                filters: widget.filters,
                sorts: widget.sorts,
                searchSink: streamController.sink,
              );
            } else {
              SearchFiltersDialog(context).showDialog(
                searchState: state,
                filters: widget.filters,
                sorts: widget.sorts,
                searchSink: streamController.sink,
              );
            }
          },
          child: Icon(
            themeData?.filterIcon ?? Icons.filter_list_sharp,
            color: themeData?.iconColor ?? Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }
}
