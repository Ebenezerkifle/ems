class Employee {
  late String firstName;
  late String lastName;
  late String uid;
  late String email;
  late String password;
  late String phoneNumber;

  Employee();

  Employee.forJson(this.firstName, this.lastName, this.email, this.uid);

  static Employee fromJson(Map<String, dynamic> json) => Employee.forJson(
      json['firstname'], json['lastname'], json['email'], json['uid']);

  Map<String, dynamic> toJson() => {
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      };

  set setFirstName(String firstName) {
    this.firstName;
  }

  set setLastName(String lastName) {
    this.lastName;
  }

  set setUID(String uid) {
    this.uid;
  }

  set setPassword(String password) {
    this.password;
  }

  set setemail(String email) {
    this.email;
  }

  set setphoneNumber(String phoneNumber) {
    this.phoneNumber;
  }
}
