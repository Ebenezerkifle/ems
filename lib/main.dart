import 'package:ems/Screens/Signin and Signout Screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyDCpqqVPG37d0zuafVzbyR7VM7KVXsaaJE",
      //     authDomain: "ems-final-project.firebaseapp.com",
      //     databaseURL: "https://ems-final-project-default-rtdb.firebaseio.com",
      //     projectId: "ems-final-project",
      //     storageBucket: "ems-final-project.appspot.com",
      //     messagingSenderId: "991857645454",
      //     appId: "1:991857645454:web:bdd8c9170f3444943ef6df")
          );

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
