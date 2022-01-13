import 'package:ems/Models/Employee.dart';
import 'package:ems/Screens/Login_Screen.dart';
import 'package:ems/Services/Authentication_Services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Authentication _auth = Authentication();
  final _formKey = GlobalKey<FormState>();

  String error = "";

  Employee user = Employee();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: Text("SignUp",
                                style: TextStyle(
                                    fontSize: 40.0, color: Colors.blueAccent))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? "Enter a valid input!"
                                  : null,
                              onChanged: (value) =>
                                  {setState(() => user.firstName = value)},
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(hintText: "first name"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) => value!.isEmpty
                                  ? "Enter a valid input!"
                                  : null,
                              onChanged: (value) =>
                                  {setState(() => user.lastName = value)},
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(hintText: "last name"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) => !value!.contains("@")
                                  ? "Enter a valid email!"
                                  : null,
                              onChanged: (value) =>
                                  {setState(() => user.email = value)},
                              keyboardType: TextInputType.text,
                              decoration:
                                  const InputDecoration(hintText: "email"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) => value!.length != 10
                                  ? "Enter a valid phone number!"
                                  : null,
                              onChanged: (value) =>
                                  {setState(() => user.phoneNumber = value)},
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: "phone number"),
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: TextFormField(
                              validator: (value) => value!.length < 6
                                  ? "Enter 6+ chars for password"
                                  : null,
                              onChanged: (value) =>
                                  {setState(() => user.password = value)},
                              //controller: _middlenameController,
                              obscureText: true, // for password!
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "password",
                              ),
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        // child: Text(
                        //     style:
                        //         TextStyle(fontSize: 40.0, color: Colors.blueAccent))),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    dynamic result = await _auth.register(user);
                                    if (result == null) {
                                      setState(() => error =
                                          "couldn't signin with this credential!");
                                      Fluttertoast.showToast(msg: error);
                                    } else if (result ==
                                        "The user is successfully registered!") {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()));
                                      Fluttertoast.showToast(msg: error);
                                    } else {
                                      setState(() => error = result);
                                      Fluttertoast.showToast(msg: error);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    textStyle: const TextStyle(fontSize: 15.0)),
                                child: const Text("submit")),
                            const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5)),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 14.0),
                        )
                      ],
                    )))));
  }
}
