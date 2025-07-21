import 'dart:async';

import 'package:dynamic_searchbar/src/models/search_action.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:dynamic_searchbar/src/widgets/search_filters_content.dart';
import 'package:flutter/material.dart';

class SearchFiltersSheet {
  final BuildContext context;

  SearchFiltersSheet(this.context);

  void showSheet({
    required SearchState searchState,
    required List<FilterAction> filters,
    required List<SortAction> sorts,
    required StreamSink<SearchState> searchSink,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: SearchFiltersContent(
            searchState: searchState,
            filters: filters,
            sorts: sorts,
            searchSink: searchSink,
            onClose: () => Navigator.pop(context),
          ),
        );
      },
    );
  }
}
