// ignore_for_file: avoid_print

import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:dynamic_searchbar/src/widgets/filters/datetime_range_filter.dart';
import 'package:dynamic_searchbar/src/widgets/filters/number_range_filter.dart';
import 'package:dynamic_searchbar/src/widgets/filters/string_filter.dart';
import 'package:dynamic_searchbar/src/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/employees.dart';
import 'mock/filters.dart';
import 'mock/sorts.dart';

void main() {
  testWidgets('filter and sort widgets build test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            initialData: employees,
            filters: employeeFilter,
            sorts: employeeSort,
            onChanged: (List<dynamic> data) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.filter_list_sharp));
    await tester.pump();

    expect(find.byType(StringFilter), findsOneWidget);
    expect(find.byType(NumberRangeFilter), findsOneWidget);
    expect(find.byType(DateTimeRangeFilter), findsOneWidget);

    for (var sort in employeeSort) {
      expect(find.text(sort.title), findsOneWidget);
    }
  });

  testWidgets('Check if stringFilter is working correctly',
      (WidgetTester tester) async {
    List filteredData = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            initialData: employees,
            filters: employeeFilter,
            sorts: employeeSort,
            onChanged: (List<dynamic> data) => filteredData = data,
          ),
        ),
      ),
    );

    final filterButton = find.byIcon(Icons.filter_list_sharp);
    final stringFilter = find.byType(StringFilter).first;
    final dropdown = find.byType(DropdownButton<StringOperator>);
    final applyButton = find.text('Apply');

    await tester.tap(filterButton);
    await tester.pump();

    await tester.enterText(stringFilter, 'Royce');

    await tester.tap(applyButton);
    await tester.pump();

    _showResult(filteredData);

    // there should be 2 employees whose names contain the word Royce.
    expect(filteredData.length == 2, true);

    await tester.tap(filterButton);
    await tester.pump();

    await tester.tap(dropdown);
    await tester.pump();

    Finder dropdownItem = find.text('equals').last;

    await tester.tap(dropdownItem);
    await tester.pump();

    await tester.tap(applyButton);
    await tester.pump();

    _showResult(filteredData);

    // there should be 1 employee named Royce.
    expect(filteredData.length == 1, true);

    await tester.tap(filterButton);
    await tester.pump();

    await tester.enterText(stringFilter, 'Ro');

    await tester.tap(dropdown);
    await tester.pump();

    dropdownItem = find.text('startsWith').last;

    await tester.tap(dropdownItem);
    await tester.pump();

    await tester.tap(applyButton);
    await tester.pump();

    _showResult(filteredData);

    // there should be 3 employees with names starting with "Ro".
    expect(filteredData.length == 3, true);

    await tester.tap(filterButton);
    await tester.pump();

    await tester.enterText(stringFilter, 'er');

    await tester.tap(dropdown);
    await tester.pump();

    dropdownItem = find.text('endsWith').last;

    await tester.tap(dropdownItem);
    await tester.pump();

    await tester.tap(applyButton);
    await tester.pump();

    _showResult(filteredData);

    // there should be 2 employees with names ending in "er".
    expect(filteredData.length == 2, true);
  });

  testWidgets('Check if dateRangeFilter is working correctly',
      (WidgetTester tester) async {
    List filteredData = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            initialData: employees,
            filters: employeeFilter,
            sorts: employeeSort,
            onChanged: (List<dynamic> data) => filteredData = data,
          ),
        ),
      ),
    );

    final filterButton = find.byIcon(Icons.filter_list_sharp);
    final applyButton = find.text('Apply');

    final startField = find.byKey(const ValueKey('hiredDateStart'));
    final endField = find.byKey(const ValueKey('hiredDateEnd'));

    await tester.tap(filterButton);
    await tester.pump();

    await tester.enterText(startField, '1991-01-01');
    await tester.enterText(endField, '1996-12-31');

    await tester.tap(applyButton);
    await tester.pump();

    // hired date must not be outside the time range.
    expect(_checkIsBefore(filteredData), false);
    expect(_checkIsAfter(filteredData), false);
  });

  testWidgets('Check if numberRangeFilter is working correctly',
      (WidgetTester tester) async {
    List filteredData = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            initialData: employees,
            filters: employeeFilter,
            sorts: employeeSort,
            onChanged: (List<dynamic> data) => filteredData = data,
          ),
        ),
      ),
    );

    final filterButton = find.byIcon(Icons.filter_list_sharp);
    final applyButton = find.text('Apply');
    final rangeSlider = find.byType(RangeSlider);

    await tester.tap(filterButton);
    await tester.pump();

    final Offset topLeft = tester.getTopLeft(rangeSlider).translate(24, 0);
    final Offset bottomLeft =
        tester.getBottomLeft(rangeSlider).translate(24, 0);
    final Offset bottomRight =
        tester.getBottomRight(rangeSlider).translate(-24, 0);

    final sliderWidth = tester.getSize(rangeSlider).width - 48;
    final dy = topLeft.dy + (bottomLeft.dy - topLeft.dy) / 2;
    final unit = sliderWidth / 100;

    final Offset leftTarget = Offset(bottomLeft.dx + 18 * unit, dy);
    final Offset rightTarget = Offset(bottomRight.dx - 35 * unit, dy);

    await tester.dragFrom(
        leftTarget, leftTarget + Offset(unit * 7 - leftTarget.dx, dy));
    await tester.pumpAndSettle();

    await tester.dragFrom(
        rightTarget, rightTarget - Offset(rightTarget.dx + 25 * unit, dy));
    await tester.pumpAndSettle();

    await tester.tap(applyButton);
    await tester.pump();

    bool isSuccess = true;
    for (var employee in filteredData) {
      if (employee.age <= 25 || employee.age >= 40) {
        isSuccess = false;

        break;
      }
    }

    // employees must be between 25 and 40 years old.
    expect(isSuccess, true);
  });

  testWidgets('tag widget build test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SearchField(
            initialData: employees,
            filters: employeeFilter,
            sorts: employeeSort,
            onChanged: (List<dynamic> data) {},
          ),
        ),
      ),
    );

    final filterButton = find.byIcon(Icons.filter_list_sharp);
    final stringFilter = find.byType(StringFilter).first;
    final applyButton = find.text('Apply');

    await tester.tap(filterButton);
    await tester.pump();

    final startField = find.byKey(const ValueKey('hiredDateStart'));
    final endField = find.byKey(const ValueKey('hiredDateEnd'));

    await tester.enterText(startField, '1991-01-01');
    await tester.enterText(endField, '1996-12-31');
    await tester.enterText(stringFilter, 'Royce');

    await tester.tap(applyButton);
    await tester.pump();

    // 2 tagwidgets should be built
    expect(find.byType(TagWidget), findsAtLeastNWidgets(2));
  });
}

bool _checkIsBefore(List<dynamic> filteredData) {
  bool isBefore = false;
  for (var employee in filteredData) {
    DateTime hiredDate = DateTime.parse(employee.hiredDate);
    DateTime targetDate = DateTime.parse('1991-01-01');

    if (hiredDate.isBefore(targetDate)) {
      isBefore = true;

      break;
    }
  }
  return isBefore;
}

bool _checkIsAfter(List<dynamic> filteredData) {
  bool isAfter = false;
  for (var employee in filteredData) {
    DateTime hiredDate = DateTime.parse(employee.hiredDate);
    DateTime targetDate = DateTime.parse('1996-12-31');

    if (hiredDate.isAfter(targetDate)) {
      isAfter = true;

      break;
    }
  }
  return isAfter;
}

void _showResult(List<dynamic> filteredData) {
  for (var employee in filteredData) {
    print(
        'firstname: ${employee.firstname}, hiredDate: ${employee.hiredDate}, age: ${employee.age}');
  }
  print('------------------------------------');
}
