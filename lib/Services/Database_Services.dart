import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/Employee.dart';

class DatabaseServices {
  final CollectionReference employeesInfo =
      FirebaseFirestore.instance.collection("Users");
  late final String uid;

  Future updateUsersData(Employee employee, String uid) async {
    return await employeesInfo.doc(uid).set({
      'firstName': employee.firstName,
      'lastName': employee.lastName,
      'phoneNumber': employee.phoneNumber,
      'password': employee.password,
      'email': employee.email,
    });
  }

  Future getUsersInfo() async {
    List itemsList = [];
    try {
      await employeesInfo.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future sendMessage(String email, String message) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.getToken().then((value) => message);
    } catch (e) {
      print(e.toString());
    }
  }
}
