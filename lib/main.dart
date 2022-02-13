import 'package:ems/Screens/SharedScreens/ChatHomepage.dart';
import 'package:ems/Screens/SharedScreens/Home_Screen_AD.dart';
import 'package:ems/Screens/GeneralManager Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/SubManager Screens/Home_Screen_SM.dart';
import 'package:ems/Screens/Employee Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/Signin and Signout Screens/signin_screen.dart';
import 'package:ems/Services/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //print('------------------------------');

  //SharedPreferences preferences = await SharedPreferences.getInstance();
  //var email = preferences.getString('email');
  // entry point of an application.
  // inflates the widget and show it on app screen.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'EMS',
    theme: ThemeData(
      primaryColor: Colors.white,
    ),
    //home: email == null ? Login() : Home(),
    home: LoginScreen(),
    //home: Home(),
  ));
}
