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

  Future getUsersInfo(CollectionReference myCollection) async {
    List itemsList = [];
    try {
      //await myCollection.snapshots();
      await myCollection.get().then((QuerySnapshot) {
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

  Future fetchMessage(CollectionReference myCollection) async {
    List itemsList = [];
    try {
      //await myCollection.snapshots();
      await myCollection.orderBy("timeStamp").get().then((QuerySnapshot) {
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
}
