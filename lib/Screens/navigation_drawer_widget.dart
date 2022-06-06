import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/GeoFence/googleMap.dart';
import 'package:ems/Models/task.dart';
import 'package:ems/Screens/GeneralManager%20Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/GeneralManager%20Screens/todoListProgress.dart';
import 'package:ems/Screens/SharedScreens/ChatHomepage.dart';
import 'package:ems/Screens/SharedScreens/TaskHomePage.dart';
import 'package:ems/Screens/Signin%20and%20Signout%20Screens/signin_screen.dart';
import 'package:ems/Screens/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final QueryDocumentSnapshot<Object?> userInfo;

  NavigationDrawerWidget(this.userInfo, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final name = userInfo.get('firstname') + ' ' + userInfo.get('middlename');
    final email = userInfo.get('email');
    final urlImage =
        'https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png';

    return Drawer(
      child: Container(
        color: Colors.indigo,
        child: ListView(
          children: <Widget>[
            buildHeader(
                //urlImage: urlImage,
                name: name,
                email: email,
                onClicked: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => UserPage(
                  //     name: 'Sarah Abs',
                  //     urlImage: urlImage,
                  //   ),
                  // ));
                }),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 12),
                  buildSearchField(),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'Tasks',
                    icon: Icons.task_alt_outlined,
                    onClicked: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TaskHomePage(userInfo)));
                    },
                  ),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'Chat',
                    icon: Icons.chat_bubble_outline,
                    onClicked: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatHomePage(userInfo)));
                    },
                  ),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'Location',
                    icon: Icons.location_on_outlined,
                    onClicked: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const GoogleMapInforamtion()));
                    },
                  ),
                  buildMenuItem(
                    text: 'Todo List Progress',
                    icon: Icons.run_circle_outlined,
                    onClicked: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TodoListProgress(userInfo)));
                    },
                  ),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'Notifications',
                    icon: Icons.notifications_outlined,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const Divider(color: Colors.white70),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onClicked: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    // required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          color: Colors.black38,
          padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              //CircleAvatar(radius: 30, backgroundImage: AssetImage(urlImage)),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    // switch (index) {
    //   case 0:
    //     Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) => ChatHomePage(),
    //     ));
    //     break;
    //   case 1:
    //     // Navigator.of(context).push(MaterialPageRoute(
    //     //   builder: (context) => EmployeeInfo(),
    //     // ));
    //     break;
    // }
  }
}
