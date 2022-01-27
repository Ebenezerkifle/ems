import 'package:ems/Models/Employee.dart';
import 'package:ems/Services/Authentication_Services.dart';
import 'package:flutter/material.dart';
import 'package:ems/Screens/signin_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  Employee employee = Employee();

  final Authentication _auth = Authentication();

  String dropdownvalue = 'Employee';
  String dropdownvalue2 = 'Department 1';
  final List<String> positions = [
    'Employee',
    'Sub-Manager',
    'General Manager',
  ];
  final List<String> departments = [
    'Department 1',
    'Department 2',
    'Department 3',
  ];

  late String _currentPosition = '';
  late String _currentDepartment = '';

  String error = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // get onChanged => null;

  // First Name widget!
  Widget _buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'First Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
              style: const TextStyle(color: Colors.indigo),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person, color: Colors.indigo),
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.indigo)),
              validator: (value) =>
                  value!.isEmpty ? "First Name is required!" : null,
              onChanged: (value) {
                setState(() => employee.firstName = value);
              },
            ))
      ],
    );
  }

  Widget _buildMiddleName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Middle Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
              style: const TextStyle(color: Colors.indigo),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person, color: Colors.indigo),
                  hintText: 'Middle Name',
                  hintStyle: TextStyle(color: Colors.indigo)),
              validator: (value) =>
                  value!.isEmpty ? "Middle Name is required!" : null,
              onChanged: (value) {
                setState(() => employee.middleName = value);
              },
            ))
      ],
    );
  }

  Widget _buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Last Name',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
              style: const TextStyle(color: Colors.indigo),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person, color: Colors.indigo),
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Colors.indigo)),
              validator: (value) =>
                  value!.isEmpty ? "Last Name is required!" : null,
              onChanged: (value) {
                setState(() => employee.firstName = value);
              },
            ))
      ],
    );
  }

  Widget _buildPhoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Phone Number',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
                style: const TextStyle(color: Colors.indigo),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person, color: Colors.indigo),
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(color: Colors.indigo)),
                validator: (value) =>
                    value!.isEmpty ? "Phone Number is required!" : null,
                onChanged: (value) {
                  setState(() {
                    employee.phoneNumber = value;
                  });
                }))
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
              //controller: _emailController,
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
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.indigo),
              onChanged: (value) {
                setState(() {
                  employee.email = value;
                });
              },
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

  Widget _buildPosition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Position',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.work, color: Colors.indigo),
                  hintText: 'Position',
                  hintStyle: TextStyle(color: Colors.indigo)),
              items: positions.map((position) {
                return DropdownMenuItem(
                    value: position,
                    child: Text(
                      position,
                      style: const TextStyle(color: Colors.indigo),
                    ));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _currentDepartment = value.toString();
                  employee.position = _currentPosition;
                });
              },
            ))
      ],
    );
  }

  Widget _buildDepartment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Department',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.work, color: Colors.indigo),
                  hintText: 'Department',
                  hintStyle: TextStyle(color: Colors.indigo)),
              items: departments.map((department) {
                return DropdownMenuItem(
                    value: department,
                    child: Text(
                      department,
                      style: const TextStyle(color: Colors.indigo),
                    ));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _currentDepartment = value.toString();
                  employee.firstName = _currentDepartment;
                });
              },
            ))
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
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
            height: 50,
            child: TextFormField(
              obscureText: true,
              style: const TextStyle(color: Colors.indigo),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.indigo)),
              validator: (value) =>
                  value!.length < 6 ? "6+ characters required!" : null,
              onChanged: (value) {
                setState(() => employee.password = value);
              },
            ))
      ],
    );
  }

  Widget _buildLogInButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      //  => print("Sign Up Pressed"),
      child: RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: 'Already have account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300)),
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
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            dynamic result = await _auth.authenticat(employee);
            if (result == null) {
              setState(() => error = "couldn't register with this credential!");
              Fluttertoast.showToast(msg: error);
            } else if (result == "The user is successfully registered!") {
              //preferences.remove("email");
              Fluttertoast.showToast(msg: error);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else {
              setState(() => error = result);
              Fluttertoast.showToast(msg: error);
            }
          }
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        child: const Text(
          'Submit',
          style: TextStyle(
              color: Colors.indigo, fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Form Demo")),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.indigo),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                _buildFirstName(),
                const SizedBox(height: 20),
                _buildMiddleName(),
                const SizedBox(height: 20),
                _buildLastName(),
                const SizedBox(height: 20),
                _buildDepartment(),
                // _build(),
                const SizedBox(height: 20),
                _buildPosition(),
                const SizedBox(height: 20),
                _buildPhoneNumber(),
                const SizedBox(height: 20),
                _buildEmail(),
                const SizedBox(height: 20),
                _buildPassword(),
                const SizedBox(height: 20),
                _buildLogInButton(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
