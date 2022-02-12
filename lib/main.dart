import 'package:ems/Screens/ChatHomepage.dart';
import 'package:ems/Screens/Home_Screen.dart';
import 'package:ems/Screens/Home_Screen_AD.dart';
import 'package:ems/Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/Home_Screen_SM.dart';
import 'package:ems/Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/Login_Screen.dart';
import 'package:ems/Screens/signin_screen.dart';
import 'package:ems/Services/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';

//import 'package:shared_preferences/shared_preferences.dart';

/* Future<void> main() async {
  //SharedPreferences preferences = await SharedPreferences.getInstance();
  //var email = preferences.getString('email');
  // entry point of an application.
  // inflates the widget and show it on app screen.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {
        WidgetsFlutterBinding.ensureInitialized();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: email == null ? Login() : Home(),
      home: HomeScreenGM(),
      //home: Home(),
    );
  }
}  */

final configurations = Configurations();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: configurations.apiKey,
          appId: configurations.appId,
          messagingSenderId: configurations.messagingSenderId,
          projectId: configurations.projectId));
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
    home: Login(),
    //home: Home(),
  ));
}
