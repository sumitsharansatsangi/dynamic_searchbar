import 'package:dynamic_searchbar/dynamic_searchbar.dart';

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
    title: 'Hired date DESC',
    field: 'hiredDate',
    order: OrderType.desc,
  ),
];
