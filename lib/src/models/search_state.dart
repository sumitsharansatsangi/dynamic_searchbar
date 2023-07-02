import 'package:dynamic_searchbar/src/models/search_action.dart';

class SearchState {
  List<FilterAction> filters;
  List<SortAction> sorts;

  SearchState(
    this.filters,
    this.sorts,
  );

  SearchState.init()
      : filters = [],
        sorts = [];

  SearchState copyWith({
    List<FilterAction>? filters,
    List<SortAction>? sorts,
  }) {
    return SearchState(
      filters ?? this.filters,
      sorts ?? this.sorts,
    );
  }

  SearchState clone() {
    return SearchState(filters, sorts);
  }
}
