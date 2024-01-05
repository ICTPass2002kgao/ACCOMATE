// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'dart:math';

import 'package:api_com/UpdatedApp/landlordFurntherRegistration.dart';
import 'package:api_com/UpdatedApp/studentFurtherRegistrationPage.dart';
import 'package:flutter/material.dart';

class StudentOrLandlord extends StatefulWidget {
  const StudentOrLandlord({super.key, required this.isLandlord});
  final bool isLandlord;

  @override
  State<StudentOrLandlord> createState() => _StudentOrLandlordState();
}

class _StudentOrLandlordState extends State<StudentOrLandlord> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactDetails = TextEditingController();
  final TextEditingController accomodationName = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  void showError(String val) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text('Missing information',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(val),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Retry'),
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
                minimumSize: MaterialStatePropertyAll(Size(300, 50))),
          ),
        ],
      ),
    );
  }

  void checkStudentValues() {
    String email = emailController.text;
    String contacts = contactDetails.text;
    String password = passwordController.text;
    if (nameController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (surnameController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (emailController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (passwordController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (password.length < 8) {
      showError('Please make sure the length of your password is 8 or more');
    }
    if (email.contains('@gmail.com')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (email.contains('@edu.vut.ac.za')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (contactDetails.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else {
      setState(() {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentFurtherRegister(
                name: nameController.text,
                surname: surnameController.text,
                contactDetails: contactDetails.text,
                university: selectedUniversity,
                gender: selectedGender,
                email: emailController.text,
                password: passwordController.text,
                isLandlord: widget.isLandlord,
              ),
            ));
      });
    }
  }

  void checkLandlordValues() {
    String email = emailController.text;
    String contacts = contactDetails.text;
    String password = passwordController.text;
    if (emailController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (passwordController.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (password.length < 8) {
      showError('Please make sure the length of your password is 8 or more');
    } else if (email.contains('@gmail.com')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (email.contains('@edu.vut.ac.za')) {
      print('everything is well');
    } else {
      showError(
          'Invalid email, Please make sure the email is in a correct format');
    }
    if (contactDetails.text == '') {
      showError('Please make sure you fill in all the required details');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else if (contacts.length != 10) {
      showError('Please make sure the contacts are correct');
    } else {
      setState(() {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => LandlordFurtherRegistration(
                      password: passwordController.text,
                      contactDetails: contactDetails.text,
                      isLandlord: widget.isLandlord,
                      accomodationName: accomodationName.text,
                      landlordEmail: emailController.text,
                    ))));
      });
    }
  }

  bool _obscureText = true;
  String selectedUniversity = '';

  List<String> universities = [
    'Vaal University of Technology',
    'North West University(vaal campus)',
  ];
  String selectedGender = '';
  List<String> gender = [
    'Male',
    'Female',
  ];

  @override
  void initState() {
    super.initState();
    selectedUniversity = 'Vaal University of Technology'; // Default value
  }

  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
            widget.isLandlord
                ? 'Landlord Registration(1/3)'
                : 'Student Registration(1/2)',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: !widget.isLandlord //This is for student
            ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    width: buttonWidth,
                    child: Column(children: [
                      Icon(
                        Icons.person_add,
                        size: 150,
                        color: Colors.blue,
                      ),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              hintText: 'Name'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: surnameController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              hintText: 'Surname'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              hintText: 'example.@gmail.com'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              hintText: 'Password'),
                          obscureText: _obscureText,
                          obscuringCharacter: '*',
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: contactDetails,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              hintText: 'Contact details'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: ExpansionTile(
                          title: Text('Select University Or College'),
                          children: universities.map((university) {
                            return RadioListTile<String>(
                              title: Text(university),
                              value: university,
                              groupValue: selectedUniversity,
                              onChanged: (value) {
                                setState(() {
                                  selectedUniversity = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: ExpansionTile(
                          title: Text('Select Gender',
                              style: TextStyle(
                                  color: selectedGender.isEmpty
                                      ? Colors.red
                                      : Colors.black)),
                          children: gender.map((paramgender) {
                            return RadioListTile<String>(
                              title: Text(paramgender),
                              value: paramgender,
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextButton(
                        onPressed: () async {
                          checkStudentValues();
                        },
                        child: Text(
                          widget.isLandlord ? 'Create account' : 'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(buttonWidth, 50))),
                      ),
                    ]),
                  ),
                ),
              )

            //User registering as a landlord
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Container(
                    width: buttonWidth,
                    child: Column(children: [
                      Icon(
                        Icons.maps_home_work_outlined,
                        size: 150,
                        color: Colors.blue,
                      ),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              hintText: 'Email'),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: buttonWidth,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              focusColor: Colors.blue,
                              fillColor: Color.fromARGB(255, 230, 230, 230),
                              filled: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              hintText: 'Password'),
                          obscureText: _obscureText,
                          obscuringCharacter: '*',
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: accomodationName,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.maps_home_work_outlined,
                              color: Colors.blue,
                            ),
                            hintText: 'Accomodation Name'),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: contactDetails,
                        decoration: InputDecoration(
                            focusColor: Colors.blue,
                            fillColor: Color.fromARGB(255, 230, 230, 230),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.phone_enabled_sharp,
                              color: Colors.blue,
                            ),
                            hintText: 'Contact details'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          checkLandlordValues();
                        },
                        child: Text(
                          widget.isLandlord ? 'Create account' : 'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue),
                            minimumSize: MaterialStatePropertyAll(
                                Size(buttonWidth, 50))),
                      )
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}
