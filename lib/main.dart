import 'package:ems/Screens/Signin and Signout Screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding?.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'EMS',
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
    //home: email == null ? Login() : Home(),
    home: const LoginScreen(),
    //home: Home(),
  ));
}
