// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps

import 'package:api_com/LandlordPage.dart';
import 'package:api_com/Student_Registration_page2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentOrLandlord extends StatefulWidget {
  const StudentOrLandlord({super.key, required this.isLandlord});
  final bool isLandlord;

  @override
  State<StudentOrLandlord> createState() => _StudentOrLandlordState();
}

class _StudentOrLandlordState extends State<StudentOrLandlord> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  Future<void> _showLogoutConfirmationDialog(BuildContext context, val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Invalid Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 190,
                        child: Text(
                          '${val}',
                        )),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Retry!!'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 600 ? double.infinity : 400;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
            widget.isLandlord
                ? 'Landlord Registration'
                : 'Student Registration',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: buttonWidth,
          child: SingleChildScrollView(
            child: Column(children: [
              Icon(
                Icons.person_add,
                size: 150,
                color: Colors.blue,
              ),
              if (!widget.isLandlord)
                Column(
                  children: [
                    TextField(
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
                    SizedBox(height: 16),
                    TextField(
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
                  ],
                ),
              SizedBox(height: 16),
              TextField(
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
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    focusColor: Colors.blue,
                    fillColor: Color.fromARGB(255, 230, 230, 230),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    hintText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    focusColor: Colors.blue,
                    fillColor: Color.fromARGB(255, 230, 230, 230),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    hintText: 'Confirm password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Implement registration logic here using FirebaseAuth
                  // You need to validate inputs and handle registration accordingly
                  // For example:
                  try {
                    UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    if (!widget.isLandlord) {
                      // If registering as a student, show AlertDialog and navigate to the next page
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Account Created Successfully'),
                            content: Text(
                                'You can now continue with additional student information.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the AlertDialog
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StudentRegistration2(
                                                userType: widget.isLandlord
                                                    ? 'landlord'
                                                    : 'student',
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                                name: nameController.text,
                                                surname: surnameController.text,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'Continue',
                                  )),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Account Created Successfully'),
                            content: Text(
                                'You can now continue with additional accomodation information.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    // Close the AlertDialog

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LandlordPage()),
                                    );
                                  },
                                  child: Text(
                                    'Continue',
                                  )),
                            ],
                          );
                        },
                      );
                      // If registering as a landlord, no need for AlertDialog, just navigate to the next page
                    }

                    print('User registered: ${userCredential.user?.email}');
                  } catch (e) {
                    _showLogoutConfirmationDialog(context, e);
                  }
                },
                child: Text(
                  widget.isLandlord ? 'Register' : 'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    minimumSize:
                        MaterialStatePropertyAll(Size(buttonWidth, 50))),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
