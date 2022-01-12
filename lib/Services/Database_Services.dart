import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/Employee.dart';

class DatabaseServices {
  final CollectionReference usersInfo =
      FirebaseFirestore.instance.collection("Users");
  final String uid;
  DatabaseServices({required this.uid});

  Future updateUsersData(Employee employee) async {
    return await usersInfo.doc(uid).set({
      'firstName': employee.firstName,
      'lastName': employee.lastName,
      'phoneNumber': employee.phoneNumber,
      'password': employee.password,
      'email': employee.email,
    });
  }
}
