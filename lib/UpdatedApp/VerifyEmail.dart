// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:math';

import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CodeVerificationPage extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String surname;
  final String gender;
  final String university;
  final String contactDetails;
  final bool isLandlord;
  final String verificationCode;

  const CodeVerificationPage({
    super.key,
    required this.isLandlord,
    required this.email,
    required this.verificationCode,
    required this.name,
    required this.password,
    required this.surname,
    required this.gender,
    required this.university,
    required this.contactDetails,
  });

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  bool isLandlord = false;
  void checkStudentValues() async {
    try {
      // Show loading indicator
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

      // Create a user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Upload files asynchronously

      String? user = FirebaseAuth.instance.currentUser!.email;
      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('Students').doc(userId).set({
        'name': widget.name,
        'surname': widget.surname,
        'email': user,
        'university': widget.university,
        'contactDetails': widget.contactDetails,
        'userId': userId,
        'gender': widget.gender,
        'roomType': '',
        'fieldOfStudy': '',
        'appliedAccomodation': false,
        'applicationReviewed': false,
        'role': 'student'
        // Add more user data as needed
      });
      sendEmail(
          widget.email, // Student's email
          'Successful account',
          widget.gender == 'Male'
              ? 'Hello Mr ${widget.surname},\nYou account have been registered successfully proceed to login.\n\n\n\nBest Regards\nYours Accomate'
              : 'Hello Mrs ${widget.surname},\nYou account have been registered successfully proceed to login.\n\n\n\nBest Regards\nYours Accomate');
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.blue[100],
                title: Text(
                  'Successful Registration',
                  style: TextStyle(fontSize: 15),
                ),
                content: Text(
                    'Your account was registered successfully. You can now proceed to login'),
                actions: <Widget>[
                  OutlinedButton(
                      onPressed: () async {
                        // Close the dialog

                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginPage(
                                      userRole: 'Student',
                                    ))));
                      },
                      child: Text('Proceed'),
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        backgroundColor: MaterialStatePropertyAll(Colors.green),
                      )),
                ],
              ));
      // Show success dialog
    } on FirebaseException catch (e) {
      Navigator.pop(context); // Dismiss loading indicator
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text('Registration Error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text(e.message.toString()),
          actions: [
            OutlinedButton(
                onPressed: () async {
                  // Close the dialog

                  Navigator.of(context).pop();
                },
                child: Text('Retry'),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                )),
          ],
        ),
      );
    }
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
    } catch (e) {}
  }

  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 450;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page(2/2)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blue[100],
        width: buttonWidth,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              const Color.fromARGB(255, 187, 222, 251),
                              Colors.blue,
                              const Color.fromARGB(255, 15, 76, 167)
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
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
                          if (index < 5 && value.isNotEmpty) {
                            FocusScope.of(context)
                                .nextFocus(); // Move focus to the next TextField
                          }
                        },
                        decoration: InputDecoration(
                          counterText: '', // Hide the default character counter
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
                        String _generateRandomCode() {
                          final random = Random();
                          // Generate a random 6-digit code
                          return '${random.nextInt(999999).toString().padLeft(6, '0')}';
                        }

                        String verificationCode = _generateRandomCode();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.blue,
                            content: Text('Verification code sent',
                                style: TextStyle(color: Colors.white))));
                        sendEmail(
                            widget.email, // Student's email
                            'Verification Code',
                            widget.gender == 'Male'
                                ? 'Hello Mr ${widget.surname},\nWe are aware that you are trying to register your account on accomate App\nHere  is your verification code: ${verificationCode}'
                                : 'Hello Mrs ${widget.surname},\nWe are aware that you are trying to register your account on accomate App\nHere  is your verification code: ${verificationCode}');
                      },
                      child: Text(
                        'Resend code',
                        style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String enteredOTP = otpControllers
                        .map((controller) => controller.text)
                        .join('');

                    if (enteredOTP == widget.verificationCode) {
                      checkStudentValues();
                    } else {
                      // Show an error message or handle incorrect OTP
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content:
                              Text('Incorrect Verification. Please try again.'),
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
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      minimumSize:
                          MaterialStatePropertyAll(Size(buttonWidth, 50))),
                  child: Text(
                    'Confirm Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
