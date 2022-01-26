import 'package:ems/Screens/ChatHomepage.dart';
import 'package:ems/Screens/Home_Screen.dart';
import 'package:ems/Screens/Home_Screen_AD.dart';
import 'package:ems/Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/Home_Screen_SM.dart';
import 'package:ems/Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/Login_Screen.dart';
<<<<<<< HEAD
import 'package:ems/Screens/Registration_Screen.dart';
import 'package:ems/Screens/signup_screen.dart';
=======
import 'package:ems/Screens/signin_screen.dart';
import 'package:ems/Services/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
>>>>>>> fa357b10601ae081ea721d9eaf2a6bf2803f4e4f
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:ems/Services/Notification.dart';
=======
import 'package:provider/provider.dart';
>>>>>>> c29a6117c7fe29708d79aa53bae3fd9195dd9892

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
<<<<<<< HEAD
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
=======
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  print('------------------------------');
>>>>>>> c29a6117c7fe29708d79aa53bae3fd9195dd9892

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
<<<<<<< HEAD
    //home: HomeScreenGM(),
    home: FormScreen(),
=======
    home: Login(),
>>>>>>> fa357b10601ae081ea721d9eaf2a6bf2803f4e4f
    //home: Home(),
  ));
}
