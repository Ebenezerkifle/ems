// ignore: import_of_legacy_library_into_null_safe
//import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:ems/Screens/signin_screen.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  late String _name;
  late String _email;
  late String _password;
  late String _url;
  late String _phoneNumber;
  late String _calories;
  String dropdownvalue = 'Employee';
  var positions = ['Employee', 'Sub-Manager', 'General Manager', 'Admin'];
  String dropdownvalue2 = 'Department 1';
  var departments = [
    'Department 1',
    'Department 2',
    'Department 3',
    'Department 4'
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  get onChanged => null;

  Widget _buildFirstName() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.white),
            hintText: 'First Name',
            hintStyle: TextStyle(color: Colors.white)),
        //labelText: 'Name'),
        //maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is Required';
          }

          return null;
        },
        onSaved: (value) {
          _name = value!;
        },
      ),
    );
  }

  Widget _buildMiddleName() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.white),
            hintText: 'Middle Name',
            hintStyle: TextStyle(color: Colors.white)),
        //labelText: 'Name'),
        //maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is Required';
          }

          return null;
        },
        onSaved: (value) {
          _name = value!;
        },
      ),
    );
  }

  Widget _buildLastName() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.white),
            hintText: 'Last Name',
            hintStyle: TextStyle(color: Colors.white)),
        //labelText: 'Name'),
        //maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Name is Required';
          }

          return null;
        },
        onSaved: (value) {
          _name = value!;
        },
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone_android, color: Colors.white),
          hintText: 'Phone Number',
          hintStyle: TextStyle(color: Colors.white)),
      //decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (value) {
        _url = value!;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Colors.white),
          hintText: 'Email',
          hintStyle: TextStyle(color: Colors.white)),
      //decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (value) {
        _email = value!;
      },
    );
  }

  Widget _buildPosition() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.work,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Position',
            style: TextStyle(color: Colors.white),
          ),
        ),
        DropdownButton(
          items: positions.map((positionsname) {
            return DropdownMenuItem(
                value: positionsname,
                child: Text(
                  positionsname,
                  style: TextStyle(color: Color(0xff5ac18e)),
                ));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
          value: dropdownvalue,
        )
      ],
    );
  }

/*   Widget _buildPosition() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.work, color: Colors.white),
          hintText: 'Position',
          hintStyle: TextStyle(color: Colors.white)),
      //decoration: InputDecoration(labelText: 'Password'),
    );
  } */

  Widget _buildDepartment() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.work,
            color: Colors.white,
          ),
        ),
        Text('Department',
            style: TextStyle(
              color: Colors.white,
            )),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: DropdownButton(
            items: departments.map((departmentsname) {
              return DropdownMenuItem(
                  value: departmentsname,
                  child: Text(
                    departmentsname,
                    style: TextStyle(color: Color(0xff5ac18e)),
                  ));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue2 = newValue!;
              });
            },
            value: dropdownvalue2,
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.password, color: Colors.white),
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.white)),
      //decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  Widget _buildLogInButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
      //  => print("Sign Up Pressed"),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'Already have account?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          TextSpan(
              text: ' Sign In ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () => print('Submit Pressed'),
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: Text(
          'Submit',
          style: TextStyle(
              color: Color(0xff5ac18e),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Form Demo")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0x665ac18e),
              Color(0x995ac18e),
              Color(0xcc5ac18e),
              Color(0xff5ac18e),
            ])),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
                  _buildFirstName(),
                  _buildMiddleName(),
                  _buildLastName(),
                  _buildDepartment(),
                  _buildPosition(),
                  _buildPhoneNumber(),
                  _buildEmail(),
                  _buildPassword(),
                  _buildLogInButton(),
                  SizedBox(height: 100),
                  _buildSubmitButton(),
                  /*    RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        return;
                      }

                      _formKey.currentState?.save();

                      print(_name);
                      print(_email);
                      print(_phoneNumber);
                      print(_url);
                      print(_password);
                      print(_calories);

                      //Send to API
                    },
                  )
                */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
