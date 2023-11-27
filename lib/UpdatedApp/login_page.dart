// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/Student_Registration_page2.dart';
import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:api_com/advanced_details.dart';
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

  void loginFunction() {
    setState(() {
      if (txtEmail.text == 'student@gmail.com' &&
          txtPassword.text == 'student') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentPage(),
            ));
      } else if (txtEmail.text == 'landlord@gmail.com' &&
          txtPassword.text == 'landlord') {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LandlordPage(),
            ));
      }
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context, val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Login Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Container(width: 180, child: Text(val)),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                // Perform logout logic here
                // ...
                Navigator.of(context).pop(); // Close the dialog

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void registerPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => RegistrationOption())));
    });
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // Future<void> _signIn() async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: txtEmail.text,
  //       password: txtPassword.text,
  //     );
  //     print('User signed in: ${userCredential.user!.email}');
  //     // Add navigation or other actions after successful login
  //   } catch (e) {
  //     print('Login failed: $e');
  //     // Handle login failure, show error message, etc.
  //   }
  // }
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )) // Show a loading indicator
          : Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: SingleChildScrollView(
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
                                  fillColor: Color.fromARGB(255, 230, 230, 230),
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
                                  fillColor: Color.fromARGB(255, 230, 230, 230),
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
                              Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    decorationStyle: TextDecorationStyle.solid),
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
                                if (userRole == true) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentPage()),
                                  );
                                } else if (userRole == false) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LandlordPage()),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize: MaterialStatePropertyAll(
                                    Size(double.infinity, 50))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Or sign-in with',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Divider(
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: isLoading
                                ? Center(
                                    child:
                                        CircularProgressIndicator()) // Show a loading indicator
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            print('Apple');
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator()) // Show a loading indicator
                                                : Image.asset(
                                                    'assets/apple_logo.png',
                                                    width: 70,
                                                  ),
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            print('Google');
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              'assets/Google_icon.png',
                                              width: 70,
                                            ),
                                          )),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              registerPage();
                            },
                            child: Text(
                              "Create Account here",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
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