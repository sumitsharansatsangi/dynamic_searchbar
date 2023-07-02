import 'dart:async';

import 'package:dynamic_searchbar/src/models/search_action.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:dynamic_searchbar/src/widgets/custom_dialog.dart';
import 'package:dynamic_searchbar/src/widgets/global_searchbar.dart';
import 'package:dynamic_searchbar/src/widgets/search_filters_content.dart';
import 'package:flutter/material.dart';

class SearchFiltersDialog {
  final BuildContext context;

  SearchFiltersDialog(this.context);

  void showDialog({
    required SearchState searchState,
    required List<FilterAction> filters,
    required List<SortAction> sorts,
    required StreamSink<SearchState> searchSink,
  }) {
    final themeData = GlobalSearchbar.of(context)?.themeData;

    CustomDialogBuilder(context, dismissible: false).showCustomDialog(
      isWrapContent: true,
      titleText: Text(themeData?.title ?? 'Filter'),
      content: SearchFiltersContent(
        searchState: searchState,
        filters: filters,
        sorts: sorts,
        searchSink: searchSink,
        onClose: () => CustomDialogBuilder(context).hideOpenDialog(),
      ),
    );
  }
}
