import 'package:ems/Models/Login.dart';
import 'package:ems/Services/Authentication_Services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  //SharedPreferences preferences;
  LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  // SharedPreferences preferences;
  // _LoginState(this.preferences);

  final Authentication _auth = Authentication();
  final _formKey = GlobalKey<FormState>();

  String error = '';
  Login login = Login();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 40.0, color: Colors.blueAccent))),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) =>
                          !value!.contains('@') ? "Enter a valid email!" : null,
                      onChanged: (value) =>
                          {setState(() => login.email = value)},
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(hintText: "email"),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      validator: (value) =>
                          value!.length < 6 ? "Enter 6+ characters!" : null,
                      onChanged: (value) =>
                          {setState(() => login.password = value)},
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "password"),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth.singin(login);
                            if (result == null) {
                              setState(() => error =
                                  "couldn't signin with this credential!");
                              Fluttertoast.showToast(msg: error);
                            } else {
                              setState(() => error = "successfully signed in!");
                              Fluttertoast.showToast(msg: error);

                              // preferences.setString("email", email);

                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const HomeScreenGM()));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            textStyle: const TextStyle(fontSize: 15.0)),
                        child: const Text("login")),
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 5)),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account "),
                  GestureDetector(
                      onTap: () {},
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => Register()));
                      // },

                      child: Semantics(
                        label: "Register",
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.redAccent),
                        ),
                      ))
                ])
              ],
            )),
      )),
    );
  }
}
