import 'package:ems/Models/Employee.dart';
import 'package:ems/Models/Login.dart';
import 'package:ems/Services/Database_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';

// register

  Future authenticat(Employee employee) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: employee.login.email, password: employee.login.password);

      DatabaseServices().register(employee, userCredential.user!.uid);

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
  Future singin(Login login) async {
    try {
      //UserCredential userCredential
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: login.email, password: login.password);
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

  authenticate(Employee user) {}
}
