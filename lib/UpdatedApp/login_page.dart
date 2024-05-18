// ignore_for_file: unnecessary_const, prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final String userRole;
  const LoginPage({super.key, required this.userRole});

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
    try {
      Navigator.of(context);
      User? user;
      _auth = FirebaseAuth.instance;
      _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
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

      Navigator.pop(context);
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        user = (await _auth.signInWithCredential(credential)).user;

        if (widget.userRole == 'Student') {
          Navigator.pushReplacementNamed(context, '/studentPage');
        }

        if (widget.userRole == 'Landlord') {
          Navigator.pushReplacementNamed(context, '/landlordPage');
        }
        if (widget.userRole == 'Admin') {
          Navigator.pushReplacementNamed(context, '/adminPage');
        }
      }
      return user;
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('An error occurred. Please try again later.\n$e'),
      ));
      return null;
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

      if (widget.userRole == 'Student') {
        Navigator.pushReplacementNamed(context, '/studentPage');
      }

      if (widget.userRole == 'Landlord') {
        Navigator.pushReplacementNamed(context, '/landlordPage');
      }
      if (widget.userRole == 'Admin') {
        Navigator.pushReplacementNamed(context, '/adminPage');
      }

      await Future.delayed(Duration(seconds: 2));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blue, content: Text(e.message.toString())));
    }
  }

  Future<void> _resetPassword() async {
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

      print('Password reset email sent to $txtEmail');
    } on FirebaseAuthException catch (e) {
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )) // Show a loading indicator
            : MediaQuery.of(context).size.width < 768
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.asset(
                                                    'assets/icon.jpg',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
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
                                              'Effortless Accommodation Solution\nBridging the Gap Between Landlords and Students',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[700])),
                                        ),
                                      ),
                                      SizedBox(height: 0),
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
                                        padding:
                                            EdgeInsets.only(left: 0, top: 5),
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
                                                    _obscureText =
                                                        !_obscureText;
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
                                        onPressed: () {
                                          _loginFunction();
                                        },
                                        child: Text(
                                          'Sign-in',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            foregroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.blue),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.blue),
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size(buttonWidth, 50))),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
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
                                                        BorderRadius.circular(
                                                            5))),
                                            foregroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.blue),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Colors.blue[50],
                                            ),
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size(buttonWidth, 50))),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (widget.userRole == 'Student')
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Divider(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                'OR sign in with',
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
                                        height: 20,
                                      ),
                                      if (widget.userRole == 'Student')
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await _handleSignIn();
                                                  },
                                                  child: Image.asset(
                                                      'assets/google.png',
                                                      height: 55,
                                                      width: 55),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              if (isIOS)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10.0),
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Icon(
                                                      Icons.apple,
                                                      size: 77,
                                                    ),
                                                  ),
                                                )
                                            ]),
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
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
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
                                            'Effortless Accommodation Solutions Bridging the Gap Between Landlords and Students',
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                          padding:
                                              EdgeInsets.only(left: 0, top: 5),
                                          child: TextField(
                                            controller: txtPassword,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                      _obscureText =
                                                          !_obscureText;
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
                                                    : await _resetPassword();
                                              },
                                              child: Text(
                                                'Forgot Password ?',
                                                style: TextStyle(
                                                    decorationColor:
                                                        Colors.blue,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.blue,
                                                    decorationThickness: 2,
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
                                          onPressed: () async {
                                            _loginFunction;
                                          },
                                          child: Text(
                                            'Sign-in',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              foregroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue),
                                              minimumSize:
                                                  MaterialStatePropertyAll(
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
