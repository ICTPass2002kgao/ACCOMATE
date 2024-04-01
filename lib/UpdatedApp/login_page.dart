// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool _obscureText = true;

  void registerPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => RegistrationOption())));
    });
  }

  bool isLoading = true;

  bool showError = false; // Initialize the boolean variable
  late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();

    _auth = FirebaseAuth.instance;
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _resetPassword() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        },
      );
      // Send a password reset email

      await _auth.sendPasswordResetEmail(email: txtEmail.text);

      Navigator.pop(context);
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text('Password reset Successful',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text('Password reset email sent to ${txtEmail.text}'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'))
        ],
      );
      // Password reset email sent successfully
      print('Password reset email sent to $txtEmail');
    } on FirebaseAuthException catch (e) {
      // Handle login error
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text('Reset password error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text('Please provide your correct email\n ${e.message}'),
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
  }

  bool isLandlord = true;
  bool isStudent = true;

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )) // Show a loading indicator
          : Container(
              height: double.infinity,
              color: Colors.blue[100],
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Container(
                        width: buttonWidth,
                        child: Center(
                          child: Column(children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(105),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color.fromARGB(
                                                  255, 187, 222, 251),
                                              Colors.blue,
                                              const Color.fromARGB(
                                                  255, 15, 76, 167)
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                              'assets/icon.jpg',
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: TextField(
                                    controller: txtEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusColor: Colors.blue,
                                        fillColor: Colors.blue[50],
                                        filled: true,
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: Colors.blue,
                                        ),
                                        hintText: 'Enter your email'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 0, top: 5),
                                  child: TextField(
                                    controller: txtPassword,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusColor: Colors.blue,
                                        fillColor: Colors.blue[50],
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
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        // Request a password reset email

                                        isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                ),
                                              )
                                            : await _resetPassword();
                                      },
                                      child: Text(
                                        'Forgot Password ?',
                                        style: TextStyle(
                                            decorationColor: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                            decorationThickness: 2,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // Prevent user from dismissing the dialog
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                            ),
                                          );
                                        },
                                      );
                                      // Sign in with email and password
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: txtEmail.text,
                                        password: txtPassword.text,
                                      );

                                      if (txtEmail.text ==
                                              'accomate33@gmail.com' &&
                                          txtPassword.text == 'password') {
                                        Navigator.pushReplacementNamed(
                                            context, '/adminPage');
                                      }

                                      if (txtEmail.text ==
                                              'accomatehelpcenter@gmail.com' &&
                                          txtPassword.text == 'ICTPass2023@') {
                                        Navigator.pushReplacementNamed(
                                            context, '/helpCenter');
                                      }

                                      User? landlordId =
                                          FirebaseAuth.instance.currentUser;
                                      User? studentsId =
                                          FirebaseAuth.instance.currentUser;

                                      // Get user data from Firestore based on user's uid
                                      DocumentSnapshot landlordsData =
                                          await FirebaseFirestore.instance
                                              .collection('Landlords')
                                              .doc(landlordId!.uid)
                                              .get();
                                      DocumentSnapshot studentsData =
                                          await FirebaseFirestore.instance
                                              .collection('Students')
                                              .doc(studentsId!.uid)
                                              .get();

                                      // Check the role of student
                                      if (studentsData.exists) {
                                        String role = studentsData['role'];

                                        // Navigate based on the user's role
                                        if (role == 'student') {
                                          Navigator.pushReplacementNamed(
                                              context, '/studentPage');
                                        } else {
                                          // Unknown role
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text('Unknown user role.'),
                                          ));
                                        }
                                      }
                                      //check the role of a landlord

                                      if (landlordsData.exists) {
                                        String role = landlordsData['role'];

                                        // Navigate based on the user's role
                                        if (role == 'landlord') {
                                          Navigator.pushReplacementNamed(
                                              context, '/landlordPage');
                                        } else {
                                          // Unknown role
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text('Unknown user role.'),
                                          ));
                                        }
                                      }
                                      await Future.delayed(
                                          Duration(seconds: 2));
                                    } on FirebaseAuthException catch (e) {
                                      // Handle login error
                                      Navigator.pop(context);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text(e.message.toString())));
                                    }
                                  },
                                  child: Text(
                                    'Sign-in',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/studentPage');
                                  },
                                  child: Text(
                                    'Proceed without login',
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      backgroundColor: MaterialStatePropertyAll(
                                        Colors.blue[50],
                                      ),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Image.asset(
                                              'assets/google.png',
                                              height: 55,
                                              width: 55),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.apple,
                                            size: 77,
                                          )),
                                    ]),
                                GestureDetector(
                                  onTap: () {
                                    registerPage();
                                  },
                                  child: Text(
                                    "Create Account here",
                                    style: TextStyle(
                                        decorationColor: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        decorationThickness: 2,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            )
                          ]),
                        ),
                      ),
                    )),
              ),
            ),
    );
  }
}
