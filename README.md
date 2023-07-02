## Introduction

Define your fields and filter the list by keyword, date range, and number range. And sort it. You can filter on frontend and backend.

## Usage

First, define your filter as in the example below.

```dart
final List<FilterAction> employeeFilter = [
  FilterAction(
    title: 'Firstname',
    field: 'firstname',
  ),
  FilterAction(
    title: 'Age',
    field: 'age',
    type: FilterType.numberRangeFilter,
    numberRange: const RangeValues(18, 65),
  ),
  FilterAction(
    title: 'Hired date',
    field: 'hiredDate',
    type: FilterType.dateRangeFilter,
    dateRange: DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    ),
  ),
];

final List<SortAction> employeeSort = [
  SortAction(
    title: 'Firstname ASC',
    field: 'firstname',
  ),
  SortAction(
    title: 'Email DESC',
    field: 'email',
    order: OrderType.desc,
  ),
  SortAction(
    title: 'Hired date ASC',
    field: 'hiredDate',
  ),
];
```

then use the SearchField widget.

```dart
SearchField(
  disableFilter: false, // if true, filters are disabled.
  filters: employeeFilter, // specify your filters
  sorts: employeeSort, // specify your sorts
  initialData: sampleList, // specify the data to filter.
  onChanged: (List<Employee> data) => setState(
    () => samples = data,
  ), // the value is returned in the onChanged method when filtering.
  onFilter: (Map filters) => print(filters), // The filter json data will be returned.
),
```

## Customize filter

If you want to customize, you can wrap it with GlobalSearchbar widget. Then you need to define the SearchThemeData object.
Here's an example with the following code

```dart
SearchThemeData(
  filterIcon: Icons.filter_list_sharp,
  title: 'Filter',
  filterTitle: 'Filters',
  sortTitle: 'Sorts',
  primaryColor: Colors.tealAccent,
  iconColor: const Color(0xFFE8E7E4),
  applyButton: ActionButtonTheme(
  title: 'Apply',
  style: ButtonStyle(
    backgroundColor:
      MaterialStateProperty.all<Color>(const Color(0xFF348FFF)),
    ),
  ),
  clearFilterButton: ActionButtonTheme(
  title: 'Clear filter',
  style: ButtonStyle(
    backgroundColor:
      MaterialStateProperty.all<Color>(const Color(0xFF3DD89B)),
    ),
  ),
  cancelButton: ActionButtonTheme(
  title: 'Cancel',
  style: ButtonStyle(
    backgroundColor:
      MaterialStateProperty.all<Color>(const Color(0xFFE8E7E4)),
    ),
  ),
),
```

## Examples

![filter 1](https://user-images.githubusercontent.com/89500759/184049813-8049e16f-03e6-425f-b196-4230dd50d7df.gif)

![filter 2](https://user-images.githubusercontent.com/89500759/184049821-c97560ba-0fe3-407c-9e87-784f8b1c4487.gif)

![sort 1](https://user-images.githubusercontent.com/89500759/184049822-8285ad03-84f3-4c1f-ac71-7a350eda8be3.gif)
