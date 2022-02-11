import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Models/Employee.dart';

class DatabaseServices {
  final CollectionReference employeesInfo =
      FirebaseFirestore.instance.collection("Users");
  late final String uid;

  Future register(Employee employee, String uid) async {
    return await employeesInfo.doc(uid).set({
      'firstname': employee.firstName,
      'middlename': employee.middleName,
      'lastname': employee.lastName,
      'department': employee.departement,
      'position': employee.position,
      'email': employee.email,
      'password': employee.password, // can be ignored!
      'phoneNumber': employee.phoneNumber,
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

  Future fetchMessage(
      CollectionReference myCollection, String receiverEmail) async {
    List itemsList = [];
    try {
      //await myCollection.snapshots();

      await myCollection
          .where(receiverEmail, isEqualTo: 'user')
          .orderBy("timeStamp")
          .get()
          .then((QuerySnapshot) {
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
