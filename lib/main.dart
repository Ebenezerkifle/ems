import 'package:ems/Screens/Home_Screen.dart';
import 'package:ems/Screens/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.get('email');
  // entry point of an application.
  // inflates the widget and show it on app screen.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? Login(preferences) : Home(preferences),
    //home: Home(),
  ));
}
