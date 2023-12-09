// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
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

  void registerPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => RegistrationOption())));
    });
  }

  bool isLoading = true;
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
      // Send a password reset email
      await _auth.sendPasswordResetEmail(email: txtEmail.text);
      AlertDialog(
        title: Text('Password reset Successful'),
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
    } catch (e) {
      // Handle password reset failure
      AlertDialog(
        title: Text('Password reset failed'),
        content: Text(e.toString()),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'))
        ],
      );
      print('Password reset failed ${e.toString()}');
    }
  }

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
          : Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      width: buttonWidth,
                      child: Center(
                        child: Column(children: [
                          Column(
                            children: [
                              Icon(Icons.lock_person,
                                  size: 150, color: Colors.blue),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(0.0),
                                child: TextField(
                                  controller: txtEmail,
                                  decoration: InputDecoration(
                                      focusColor: Colors.blue,
                                      fillColor:
                                          Color.fromARGB(255, 230, 230, 230),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Enter your email'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0, top: 10),
                                child: TextField(
                                  controller: txtPassword,
                                  decoration: InputDecoration(
                                      focusColor: Colors.blue,
                                      fillColor:
                                          Color.fromARGB(255, 230, 230, 230),
                                      filled: true,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.blue,
                                      ),
                                      hintText: 'Password'),
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // Request a password reset email

                                      await _resetPassword();
                                    },
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15,
                                          decorationStyle:
                                              TextDecorationStyle.double),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () async {
                                  String email = txtEmail.text;
                                  String password = txtPassword.text;

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
                                      email: email,
                                      password: password,
                                    );

                                    // Fetch additional user information, including the role, from Firestore
                                    DocumentSnapshot userDoc =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .get();

                                    bool userRole = userDoc['role'];

                                    // Navigate based on the user's role
                                    if (userRole == false) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudentPage()),
                                      );
                                    } else if (userRole == true) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LandlordPage()),
                                      );
                                    } else {
                                      // Handle other roles if needed
                                    }
                                  } catch (e) {
                                    print('Error during login: $e');
                                    // Handle login error
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Login Error'),
                                        content: Text(
                                            'Failed to log in. Please check your email and password.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
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
                                height: 20,
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
                                height: 50,
                              ),
                              GestureDetector(
                                onTap: () {
                                  registerPage();
                                },
                                child: Text(
                                  "Create new Account here",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 18),
                                ),
                              )
                            ],
                          )
                        ]),
                      ),
                    ),
                  )),
            ),
    );
  }
}
/*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                ),   
                onPressed: (){}, 
                icon: Icon(Icons.favorite_border,
                color: Colors.white,), 
                label: Text('Add to Favorites',
                style: TextStyle(
                color: Colors.white,
                fontSize: 18),
                
                ), ),
                

              
                ],
              ) */