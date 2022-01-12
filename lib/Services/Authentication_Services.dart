import 'package:ems/Models/Employee.dart';
import 'package:ems/Services/Database_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';

// register

  Future register(Employee employee) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: employee.email, password: employee.password);
      DatabaseServices(uid: userCredential.user!.uid).updateUsersData(employee);

      error = "The user is successfully registered!";
      return error;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
        return error;
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
        return error;
      }
    } catch (e) {
      error = e.toString();
      return error;
    }
  }

  // login
  Future singin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //DatabaseServices(uid: userCredential.user!.uid).updateUsersData(user);
      error = "The user is successfully registered!";
      return error;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
        return error;
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
        return error;
      }
    } catch (e) {
      error = e.toString();
      return error;
    }
  }
}
