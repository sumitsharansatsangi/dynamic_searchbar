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
