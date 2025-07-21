import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:dynamic_searchbar/src/helpers/utils.dart';
import 'package:dynamic_searchbar/src/models/search_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/employees.dart';

void main() {
  testWidgets('filter and sort widgets should be built', (
    WidgetTester tester,
  ) async {
    final searchState = SearchState(
      [
        FilterAction(
          title: 'Firstname',
          field: 'firstname',
          searchKey: 'Royce',
        ),
      ],
      [SortAction(title: 'Age', field: 'age', order: OrderType.desc)],
    );

    final data = filterList(searchKey: searchState, data: employees);

    expect(data.length == 2, true);
    expect(_checkSort(data), true);
  });

  testWidgets('sort should be duplicated', (WidgetTester tester) async {
    final searchState = SearchState([], [
      SortAction(title: 'Age 1', field: 'age', order: OrderType.desc),
      SortAction(title: 'Age 2', field: 'age', order: OrderType.desc),
    ]);

    final isDuplicated = isDuplicatedSorts(searchState.sorts);

    expect(isDuplicated, true);
  });

  testWidgets('filter should be duplicated', (WidgetTester tester) async {
    final searchState = SearchState([
      FilterAction(title: 'Firstname', field: 'firstname', searchKey: 'Royce'),
      FilterAction(
        title: 'Firstname',
        field: 'firstname',
        searchKey: 'Royceann',
      ),
    ], []);

    final isDuplicated = isDuplicatedFilters(searchState.filters);

    expect(isDuplicated, true);
  });

  testWidgets('searchstate should be empty', (WidgetTester tester) async {
    SearchState searchState = SearchState(
      [
        FilterAction(
          title: 'Firstname',
          field: 'firstname',
          searchKey: 'Royce',
        ),
      ],
      [SortAction(title: 'Age', field: 'age', order: OrderType.desc)],
    );

    searchState = removeFilter(
      searchAction: searchState,
      filter: searchState.filters[0],
      sort: searchState.sorts[0],
    );

    expect(searchState.filters.isEmpty, true);
    expect(searchState.sorts.isEmpty, true);
  });
}

bool _checkSort(List data) {
  bool isGreater = false;
  for (var i = 0; i < data.length - 1; i++) {
    if (data[i].age < data[i + 1].age) {
      isGreater = true;
    }
  }

  return !isGreater;
}
