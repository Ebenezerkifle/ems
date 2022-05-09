import 'package:ems/Models/Login.dart';

class Employee {
  late String firstName;
  late String middleName;
  late String lastName;
  late String departement;
  late String position;
  late String uid;
  late String phoneNumber;
  late Login login;

  Employee();

  Employee.forJson(this.firstName, this.lastName, this.login, this.uid);

/*   set position(String position) {}

  set middleName(String middleName) {} */

  static Employee fromJson(Map<String, dynamic> json) => Employee.forJson(
      json['firstname'], json['lastname'], json['email'], json['uid']);

  toJson() => {
        'firstname': firstName,
        'middlename': middleName,
        'lastname': lastName,
        'department': departement,
        'position': position,
        'email': login.email,
        'password': login.password, // can be ignored!
        'phoneNumber': phoneNumber,
      };

  set setFirstName(String firstName) {
    this.firstName;
  }

  set setLastName(String lastName) {
    this.lastName;
  }

  set setUID(String uid) {
    this.uid;
  }

  set setphoneNumber(String phoneNumber) {
    this.phoneNumber;
  }
}
