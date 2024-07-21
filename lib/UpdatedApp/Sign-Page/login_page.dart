// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:animated_card/animated_card.dart';
import 'package:api_com/UpdatedApp/Sign-up-Pages/CreateAnAccount.dart';
import 'package:api_com/UpdatedApp/Sign-Page/forgot_password.dart';
import 'package:api_com/UpdatedApp/Sign-up-Pages/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text_field_validation/text_field_validation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void registerPage() {
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => RegistrationOption())));
    });
  }

  bool isLoading = true;

  bool showError = false;
  // late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    // _googleSignIn = GoogleSignIn();
    // _auth = FirebaseAuth.instance;
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loginFunction() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: txtEmail.text,
        password: txtPassword.text,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot landlordSnapshot = await FirebaseFirestore.instance
            .collection('Landlords')
            .doc(user.uid)
            .get();
        DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
            .collection('Students')
            .doc(user.uid)
            .get();

        String? userRole;

        if (landlordSnapshot.exists) {
          userRole = landlordSnapshot['userRole'];
        } else if (studentSnapshot.exists) {
          userRole = studentSnapshot['userRole'];
        }

        Navigator.pop(context); // Dismiss the progress dialog

        if (userRole != null) {
          if (userRole == 'student') {
            Navigator.pushReplacementNamed(context, '/studentPage');
          } else if (userRole == 'landlord') {
            Navigator.pushReplacementNamed(context, '/landlordPage');
          } else {
            Navigator.pushReplacementNamed(context, '/adminPage');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            showCloseIcon: true,
            content: Text('User role not found.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss the progress dialog

      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Please check your email or register.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The entered email is invalid. Please try again.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'The user is disabled. Please try again.';
      } else {
        errorMessage = 'Something went wrong. Please try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
  }

  bool isLandlord = true;
  bool isStudent = true;
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    // bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: MediaQuery.of(context).size.width < 768
          ? Container(
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: AnimatedCard(
                              duration: Duration(seconds: 2), 
                              direction: AnimatedCardDirection.top,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(105),
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
                                            padding: const EdgeInsets.all(7.0),
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
                                ),
                                SizedBox(height: 6),
                                Form(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      AuthTextField(
                                        icon: Icons.person,
                                        placeholder: 'Email',
                                        controller: txtEmail,
                                        onValidate: (value) =>
                                            TextFieldValidation.email(value!),
                                      ),
                                      SizedBox(height: 8),
                                      AuthTextField(
                                        icon: Icons.password_rounded,
                                        visible: _obscureText,
                                        placeholder: 'Password',
                                        controller: txtPassword,
                                        onValidate: (value) =>
                                            TextFieldValidation.password(
                                                value!),
                                      ),
                                      // Padding(
                                      //   padding: EdgeInsets.only(left: 0, top: 5),
                                      //   child: TextField(
                                      //     controller: txtPassword,
                                      //     decoration: InputDecoration(
                                      //         border: OutlineInputBorder(
                                      //           borderSide:
                                      //               BorderSide(color: Colors.blue),
                                      //           borderRadius:
                                      //               BorderRadius.circular(10),
                                      //         ),
                                      //         focusedBorder: OutlineInputBorder(
                                      //           borderSide:
                                      //               BorderSide(color: Colors.blue),
                                      //           borderRadius:
                                      //               BorderRadius.circular(10),
                                      //         ),
                                      //         focusColor: Colors.blue,
                                      //         fillColor: Colors.blue[50],
                                      //         filled: true,
                                      //         suffixIcon: IconButton(
                                      //           icon: Icon(
                                      //             _obscureText
                                      //                 ? Icons.visibility
                                      //                 : Icons.visibility_off,
                                      //             color: Colors.blue,
                                      //           ),
                                      //           onPressed: () {
                                      //             setState(() {
                                      //               _obscureText = !_obscureText;
                                      //             });
                                      //           },
                                      //         ),
                                      //         prefixIcon: Icon(
                                      //           Icons.lock,
                                      //           color: Colors.blue,
                                      //         ),
                                      //         hintText: 'Password'),
                                      //     obscureText: _obscureText,
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              isLoading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.blue),
                                                      ),
                                                    )
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              ForgotPasswordPage())));
                                            },
                                            child: Text(
                                              'Forgot Password ?',
                                              style: TextStyle(
                                                  decorationColor:
                                                      Colors.blue,
                                                  decoration: TextDecoration
                                                      .underline,
                                                  color: Colors.blue,
                                                  decorationThickness: 0.5,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .solid,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) _loginFunction();
                                        },
                                        child: Text(
                                          'Sign-in',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        style: ButtonStyle(
                                            shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.blue),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.blue),
                                            minimumSize:
                                                WidgetStatePropertyAll(
                                                    Size(buttonWidth, 50))),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    FirebaseAuth.instance.signInAnonymously();
                                    Navigator.pushReplacementNamed(
                                        context, '/studentPage');
                                  },
                                  child: Text(
                                    'Proceed without Sign-in',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.white),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                                SizedBox(
                                  height: 10,
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
                                        'OR ',
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
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    RegistrationOption())));
                                  },
                                  child: Text(
                                    'Create new account',
                                    style: TextStyle(
                                        decorationColor: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        decorationThickness: 2,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    )),
              ),
            )
          : Center(
              child: Container(
                  height: double.infinity,
                  color: Colors.blue[100],
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            height: double.infinity,
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AnimatedCard(
                              duration: Duration(seconds: 2), 
                              direction: AnimatedCardDirection.top, 
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
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
                                              padding: const EdgeInsets.all(5.0),
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
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'You are Logging in as a Landlord',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700])),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: double.infinity,
                        color: Color.fromARGB(255, 173, 214, 248),
                        child: SingleChildScrollView(
                          child: Center(
                              child: Container(
                            width: buttonWidth,
                            child: Center(
                              child: Column(children: [
                                SizedBox(height: 100),
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
                                        isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
                                                ),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ForgotPasswordPage())));
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
                                    _loginFunction();
                                  },
                                  child: Text(
                                    'Sign-in',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.blue),
                                      minimumSize: WidgetStatePropertyAll(
                                          Size(buttonWidth, 50))),
                                ),
                                SizedBox(
                                  height: 60,
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
                                        'OR ',
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
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    RegistrationOption())));
                                  },
                                  child: Text(
                                    'Create new account',
                                    style: TextStyle(
                                        decorationColor: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                        decorationThickness: 2,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 16),
                                  ),
                                ),
                              ]),
                            ),
                          )),
                        ),
                      ))
                    ],
                  )),
            ),
    );
  }
}
