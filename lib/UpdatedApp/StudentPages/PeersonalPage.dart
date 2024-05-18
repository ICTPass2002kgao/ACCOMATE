// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(9999).toString().padLeft(4, '0')}';
  }

  void _confirmUpdate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );
    sendEmail(
        _userData?['email'] ?? 'Loading...', // Student's email
        'Verification Code',
        _userData?['gender'] == 'Male'
            ? 'Hello Mr ${_userData?['surname'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: ${verificationCode}'
            : 'Hello Mrs ${_userData?['surname'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: ${verificationCode}');

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          title: Text('Verification Code',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: [
                    Text(
                        "We've sent verification Code to ${_userData?['email'] ?? 'Loading...'},Please verify to update your email."),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: 50,
                          child: TextField(
                            controller: otpControllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            // Hide the entered digits
                            maxLength: 1,
                            onChanged: (value) {
                              // Handle OTP input
                              if (index < 3 && value.isNotEmpty) {
                                FocusScope.of(context)
                                    .nextFocus(); // Move focus to the next TextField
                              }
                            },
                            decoration: InputDecoration(
                              counterText:
                                  '', // Hide the default character counter
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            sendEmail(
                                _userData?['email'] ??
                                    'Loading...', // Student's email
                                'Verification Code',
                                _userData?['email'] ?? 'Loading..' == 'Male'
                                    ? 'Hello Mr ${_userData?['email'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: ${verificationCode}'
                                    : 'Hello Mrs ${_userData?['email'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: ${verificationCode}');
                          },
                          child: Text(
                            'Resend code',
                            style: TextStyle(
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                                color: Colors.blue[900]),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {});

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                Navigator.pop(context);
                if (otpControllers == verificationCode) {
                  _updateStudentDetails();
                }
                // navigate to login page
              },
            ),
          ],
        );
      },
    );
  }

  final HttpsCallable sendEmailCallable =
      FirebaseFunctions.instance.httpsCallable('sendEmail');

  Future<void> sendEmail(String to, String subject, String body) async {
    try {
      final result = await sendEmailCallable.call({
        'to': to,
        'subject': subject,
        'body': body,
      });
      print(result.data);
    } catch (e) {
      print('Error  $e');
    }
  }

  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  Future<void> _updateStudentDetails() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );
    print('ongoing');

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.verifyBeforeUpdateEmail(emailController.text);
        print("Email updated successfully to ${emailController.text}");
      } else {
        print("User not signed in");
        // Handle the case where the user is not signed in
      }
    } catch (e) {
      print("Error updating email: $e");
      // Handle the error, e.g., display an error message to the user
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                'Successful Update',
                style: TextStyle(fontSize: 15),
              ),
              content:
                  Text('Your email account have been updated successfully'),
              actions: <Widget>[
                TextButton(
                    onPressed: () async {
                      // Close the dialog

                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                        minimumSize: MaterialStatePropertyAll(
                            Size(double.infinity, 50))),
                    child: Text('Done')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(78),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color.fromARGB(
                                            255, 187, 222, 251),
                                        Colors.blue,
                                        const Color.fromARGB(255, 15, 76, 167)
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(75),
                                      child: Image.asset(
                                        'assets/icon.jpg',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: TextField(
                                      maxLines: 1,
                                      controller: emailController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText:
                                              "${_userData?['email'] ?? ''}"),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: TextField(
                                      maxLines: 1,
                                      readOnly: true,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText:
                                              "${_userData?['name'] ?? ''}"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: TextField(
                                      readOnly: true,
                                      maxLines: 1,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText:
                                              "${_userData?['surname'] ?? ''}"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: TextField(
                                      maxLines: 1,
                                      readOnly: true,
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText:
                                              "${_userData?['university'] ?? ''}"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () => emailController.text
                                                .contains('@gmail.com') ||
                                            emailController.text
                                                .contains('@edu.vut.ac.za')
                                        ? _confirmUpdate()
                                        : null,
                                    child: Text('Update'),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                emailController.text.contains(
                                                            '@gmail.com') ||
                                                        emailController.text
                                                            .contains(
                                                                '@edu.vut.ac.za')
                                                    ? Colors.blue
                                                    : Colors.grey),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white),
                                        minimumSize: MaterialStatePropertyAll(
                                            Size(double.infinity, 50))),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
