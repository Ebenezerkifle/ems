import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/Screens/SharedScreens/Home_Screen_AD.dart';
import 'package:ems/Screens/Employee%20Screens/Home_Screen_EM.dart';
import 'package:ems/Screens/GeneralManager%20Screens/Home_Screen_GM.dart';
import 'package:ems/Screens/SubManager%20Screens/Home_Screen_SM.dart';
import 'package:ems/Services/Authentication_Services.dart';
import 'package:flutter/material.dart';
import 'package:ems/Screens/Signin%20and%20Signout%20Screens/signup_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isRememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Authentication _auth = Authentication();

  String error = '';

  Widget buidEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextFormField(
              controller: _emailController,
              validator: (value) =>
                  !value!.contains('@') ? "Enter a valid email!" : null,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.indigo),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Colors.indigo),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.indigo),
              ),
            ))
      ],
    );
  }

  Widget buidPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 60,
          child: TextFormField(
            validator: (value) =>
                value!.length < 6 ? "Enter 6+ characters!" : null,
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.indigo),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.indigo)),
          ),
        )
      ],
    );
  }

  Widget buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("Forgot Password pressed"),
        padding: const EdgeInsets.only(right: 0),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildRememberCheckBox() {
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value!;
                });
              },
            ),
          ),
          const Text(
            'Remember Me',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            dynamic result = await _auth.singin(
                _emailController.text, _passwordController.text);
            if (result == null) {
              setState(() => error = "couldn't signin with this credential!");
              Fluttertoast.showToast(msg: error);
            } else {
              setState(() => error = "successfully signed in!");
              Fluttertoast.showToast(msg: error);
              _navigate();
            }
          }
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: const Text(
          'LOGIN',
          style: TextStyle(
              color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future _navigate() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: _emailController.text)
        .get()
        .then((QuerySnapshot snapshot) {
      var result = snapshot.docs.first;
      switch (result.get('position')) {
        case 'Admin':
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenAD()));
          break;
        case 'General-Manager':
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreenGM(
                    userInfo: result,
                  )));
          break;
        case 'Sub-Manager':
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenSM()));
          break;
        case 'Employee':
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenEM()));
          break;
      }
    });
  }

  Widget buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FormScreen(),
          ),
        );
      },
      //  => print("Sign Up Pressed"),
      child: RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: ' Sign Up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.indigo),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    buidEmail(),
                    const SizedBox(height: 20),
                    buidPassword(),
                    buildForgotPasswordButton(),
                    // buildRememberCheckBox(),
                    buildLoginButton(),
                    buildSignUpButton(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
