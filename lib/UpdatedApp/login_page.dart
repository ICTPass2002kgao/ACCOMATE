// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:api_com/forgot_password.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final String userRole;
  final bool guest;
  const LoginPage({super.key, required this.userRole, required this.guest});

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

  bool showError = false;
  late FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn();
    _auth = FirebaseAuth.instance;
    loadData();
  }

  late GoogleSignIn _googleSignIn;
  Future<User?> _handleSignIn() async {
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

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        User? user = userCredential.user;

        if (user != null) {
          if (widget.userRole == 'Student') {
            Navigator.pushReplacementNamed(context, '/studentPage');
          } else if (widget.userRole == 'Landlord') {
            Navigator.pushReplacementNamed(context, '/landlordPage');
          } else if (widget.userRole == 'Admin') {
            Navigator.pushReplacementNamed(context, '/adminPage');
          }
        }
        return user;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Google Sign-In Failed'),
        ));
        return null;
      }
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.message.toString()),
      ));
      return null;
    } finally {
      Navigator.pop(context);
    }
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

      if (widget.userRole == 'Student' && _auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/studentPage');
      } else if (widget.userRole == 'Landlord' && _auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/landlordPage');
      } else if (widget.userRole == 'Admin' && _auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/adminPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          content: Text('Something went wrong! Please retry logging in'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), 
        ));
      }

      await Future.delayed(Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

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
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

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
                                  if (widget.userRole == 'Student')
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "You're Logging in as a Student",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700])),
                                      ),
                                    ),
                                  if (widget.userRole == 'Landlord')
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "You're Logging in as a Landlord",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700])),
                                      ),
                                    ),
                                  if (widget.userRole == 'Admin')
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "You're Logging in as a Admin",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700])),
                                      ),
                                    ),
                                  SizedBox(height: 0),
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
                                              decorationThickness: 0.5,
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
                                    onPressed: () {
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
                                    height: 10,
                                  ),
                                  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: <Widget>[
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding:
                                  //             const EdgeInsets.symmetric(
                                  //                 horizontal: 8.0),
                                  //         child: Text(
                                  //           'OR sign in with',
                                  //           style: TextStyle(
                                  //             color: Colors.black,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       Expanded(
                                  //         child: Divider(
                                  //           color: Colors.black,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // if (widget.userRole == 'Student')
                                  //   Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         ClipRRect(
                                  //           borderRadius:
                                  //               BorderRadius.circular(90),
                                  //           child: GestureDetector(
                                  //             onTap: () async {
                                  //               await _handleSignIn();
                                  //             },
                                  //             child: Image.asset(
                                  //                 'assets/google.png',
                                  //                 height: 55,
                                  //                 width: 55),
                                  //           ),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         if (isIOS)
                                  //           Padding(
                                  //             padding:
                                  //                 const EdgeInsets.only(
                                  //                     bottom: 10.0),
                                  //             child: GestureDetector(
                                  //               onTap: () {},
                                  //               child: Icon(
                                  //                 Icons.apple,
                                  //                 size: 77,
                                  //               ),
                                  //             ),
                                  //           )
                                  //       ]),
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
                                child: Column(
                                  children: [
                                    SizedBox(height: 100),
                                    Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: TextField(
                                        controller: txtEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue),
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
                                                      BorderRadius.circular(
                                                          5))),
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.blue),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.blue),
                                          minimumSize: WidgetStatePropertyAll(
                                              Size(buttonWidth, 50))),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: Divider(
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding:
                                    //           const EdgeInsets.symmetric(
                                    //               horizontal: 8.0),
                                    //       child: Text(
                                    //         'OR sign in with',
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Expanded(
                                    //       child: Divider(
                                    //         color: Colors.black,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
