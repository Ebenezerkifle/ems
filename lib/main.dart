import 'package:ems/Screens/ChatHomepage.dart';
import 'package:ems/Screens/Home_Screen.dart';
import 'package:ems/Screens/Home_Screen_AD.dart';
import 'package:ems/Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/Home_Screen_SM.dart';
import 'package:ems/Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/Login_Screen.dart';
import 'package:ems/Screens/Registration_Screen.dart';
import 'package:ems/Screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  print('------------------------------');

  //SharedPreferences preferences = await SharedPreferences.getInstance();
  //var email = preferences.getString('email');
  // entry point of an application.
  // inflates the widget and show it on app screen.
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: email == null ? Login() : Home(),
    //home: HomeScreenGM(),
    home: FormScreen(),
    //home: Home(),
  ));
}
