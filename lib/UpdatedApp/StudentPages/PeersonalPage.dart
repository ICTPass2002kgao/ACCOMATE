import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  late User? _user;
  Map<String, dynamic>? _userData;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    loadData();
  }

  String registeredDate = '';
  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .get();

    // if (userDataSnapshot.exists) {
    //   Timestamp registeredTimestamp = userDataSnapshot['registeredDate'];
    //   DateTime registeredDateTime = registeredTimestamp.toDate();

    //   String formattedDate =
    //       DateFormat('yyyy-MM-dd HH:mm').format(registeredDateTime);

    //   print('User registered on: $formattedDate');

    setState(() {
      // registeredDate = formattedDate;
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
    // }
  }

  String verificationCode = _generateRandomCode();

  static String _generateRandomCode() {
    final random = Random();
    return '${random.nextInt(9999).toString().padLeft(4, '0')}';
  }

  bool isLoading = true;

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
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
            ? 'Hello Mr ${_userData?['surname'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: $verificationCode'
            : 'Hello Mrs ${_userData?['surname'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: $verificationCode');
    print(verificationCode);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.blue[50],
          title: Text(
            'Verification Code',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
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
                            maxLength: 1,
                            onChanged: (value) {
                              if (index < 3 && value.isNotEmpty) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: InputDecoration(
                              counterText: '',
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
                                    ? 'Hello Mr ${_userData?['email'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: $verificationCode'
                                    : 'Hello Mrs ${_userData?['email'] ?? 'Loading...'},,\nWe are aware that you are trying to update your email account on accomate App\nHere  is your verification code: $verificationCode');
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                Navigator.of(context).pop();
                String enteredCode =
                    otpControllers.map((controller) => controller.text).join();
                if (enteredCode == verificationCode) {
                  try {
                    await _user?.sendEmailVerification();
                    await _user?.verifyBeforeUpdateEmail(emailController.text);
                    print(
                        "Email updated successfully to ${emailController.text}");
                  } catch (e) {
                    Navigator.of(context).pop();
                    print("Error updating email: $e");
                    // Handle the error, e.g., display an error message to the user
                  }
                } else {
                  print('Verification code does not match');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final smtpServer = gmail('accomate33@gmail.com', 'nhle ndut leqq baho');
    final message = Message()
      ..from = Address('accomate33@gmail.com', 'Accomate')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..html = body;

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: Container(
                    width: 100,
                    height: 100,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text("Loading...")),
                        Center(
                            child: LinearProgressIndicator(color: Colors.blue)),
                      ],
                    ))))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                                      child: Image.asset('assets/icon.jpg',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fill),
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
                                              "${_userData?['email'] ?? 'NaN'}"),
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
                                              "${_userData?['name'] ?? 'NaN'}"),
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
                                              "${_userData?['surname'] ?? 'NaN'}"),
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
                                              "${_userData?['university'] ?? 'NaN'}"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (_user?.uid != null)
                                    Container(
                                      child: TextField(
                                        maxLines: 1,
                                        readOnly: true,
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: DateFormat(
                                                    'yyyy-MM-dd HH:mm')
                                                .format(
                                                    _userData?['registeredDate']
                                                            .toDate() ??
                                                        'NaN')),
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
                                        backgroundColor: WidgetStatePropertyAll(
                                            emailController.text.contains(
                                                        '@gmail.com') ||
                                                    emailController.text
                                                        .contains(
                                                            '@edu.vut.ac.za')
                                                ? Colors.blue
                                                : Colors.grey),
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.white),
                                        minimumSize: WidgetStatePropertyAll(
                                            Size(double.infinity, 50))),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
