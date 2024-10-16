import 'package:dynamic_searchbar/dynamic_searchbar.dart';
import 'package:faker/faker.dart' hide Color;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Employee {
  final int id;
  final String lastname;
  final String firstname;
  final String email;
  final String position;
  final int age;
  final String hiredDate;

  Employee({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.position,
    required this.age,
    required this.hiredDate,
  });

  Employee.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastname = json['lastname'],
        firstname = json['firstname'],
        email = json['email'],
        position = json['position'],
        age = json['age'],
        hiredDate = json['hiredDate'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastname': lastname,
      'firstname': firstname,
      'email': email,
      'position': position,
      'age': age,
      'hiredDate': hiredDate
    };
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
      };
}

void main() {
  runApp(const TestingApp());
}

class TestingApp extends StatelessWidget {
  const TestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalSearchbar(
      searchThemeData: SearchThemeData(
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
                WidgetStateProperty.all<Color>(const Color(0xFF348FFF)),
          ),
        ),
        clearFilterButton: ActionButtonTheme(
          title: 'Clear filter',
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(const Color(0xFF3DD89B)),
          ),
        ),
        cancelButton: ActionButtonTheme(
          title: 'Cancel',
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(const Color(0xFFE8E7E4)),
          ),
        ),
      ),
      child: MaterialApp(
        title: 'Testing Sample',
        debugShowCheckedModeBanner: false,
        scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
        theme: ThemeData(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
        },
        initialRoute: HomePage.routeName,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FilterAction> employeeFilter = [
    FilterAction(
      title: 'Firstname',
      field: 'firstname',
    ),
    FilterAction(
      title: 'Lastname',
      field: 'lastname',
    ),
    FilterAction(
      title: 'Age',
      field: 'age',
      type: FilterType.numberRangeFilter,
      numberRange: const RangeValues(18, 65),
      maxNumberRange: 65,
      minNumberRange: 18,
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
      title: 'Lastname ASC',
      field: 'lastname',
    ),
    SortAction(
      title: 'Email DESC',
      field: 'email',
      order: OrderType.desc,
    ),
    SortAction(
      title: 'Position DESC',
      field: 'position',
      order: OrderType.desc,
    ),
    SortAction(
      title: 'Hired date ASC',
      field: 'hiredDate',
    ),
    SortAction(
      title: 'Hired date DESC',
      field: 'hiredDate',
      order: OrderType.desc,
    ),
  ];

  final sampleList = List<Employee>.generate(
    100,
    (index) => Employee(
      id: index,
      firstname: Faker().person.firstName(),
      lastname: Faker().person.lastName(),
      position: Faker().job.title(),
      email: Faker().internet.email(),
      age: Faker().randomGenerator.integer(65, min: 18),
      hiredDate: Faker().date.dateTime(minYear: 1990, maxYear: 2022).toString(),
    ),
  );

  List samples = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Sample'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            SearchField(
              // disableFilter: true,
              filters: employeeFilter,
              sorts: employeeSort,
              initialData: sampleList,
              onChanged: (List<Employee> data) => setState(
                () => samples = data,
              ),
              // ignore: avoid_print
              onFilter: (Map filters) => print(filters),
            ),
            Expanded(
              flex: 10,
              child: ListView.builder(
                  itemCount: samples.length,
                  itemBuilder: ((context, index) {
                    final employee = samples[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('id'),
                                Text(
                                  employee.id.toString(),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Firstname'),
                                Text(
                                  employee.firstname,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Lastname'),
                                Text(
                                  employee.lastname,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Email'),
                                Text(
                                  employee.email,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Position'),
                                Text(
                                  employee.position,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Age'),
                                Text(
                                  employee.age.toString(),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hired date'),
                                Text(
                                  employee.hiredDate.toString(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}
