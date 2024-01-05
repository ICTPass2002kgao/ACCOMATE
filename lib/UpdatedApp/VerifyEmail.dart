// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:api_com/advanced_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

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
  final File? studentIdDoc;
  final File? studentPor;

  final String studentId;
  final String studentNumber;

  const CodeVerificationPage(
      {super.key,
      required this.isLandlord,
      required this.email,
      required this.verificationCode,
      required this.name,
      required this.password,
      required this.surname,
      required this.gender,
      required this.university,
      required this.contactDetails,
      this.studentIdDoc,
      this.studentPor,
      required this.studentId,
      required this.studentNumber});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  Future<String?> _uploadPickProofOfRegistration(
      File pdfFile, BuildContext context) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('Proof of registrations')
          .child(
              "${widget.name} ${widget.surname}'s Proof of registration($fileName).pdf");

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> _uploadIdDocumentPDFFile(
      File pdfFile, BuildContext context) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('Students IDs')
          .child("${widget.name} ${widget.surname}'s Id($fileName).pdf");

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } on firebase_storage.FirebaseException catch (e) {
      // Handle login error
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text('Upload Error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Text(e.message.toString()),
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
      return null;
    }
  }

  bool isLandlord = false;
  String _pdfPorDocument = '';
  String _pdfIdDocument = '';
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

      //Uploading proof of registration Document
      String? downloadPORURL =
          await _uploadPickProofOfRegistration(widget.studentPor!, context);
      if (downloadPORURL != null) {
        setState(() {
          _pdfPorDocument = downloadPORURL;
        });
      }
      //Uploading Id Document
      String? downloadIDURL =
          await _uploadIdDocumentPDFFile(widget.studentIdDoc!, context);
      if (downloadIDURL != null) {
        setState(() {
          _pdfIdDocument = downloadIDURL;
        });
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc("${widget.name}'s Unique ID(${userId})")
          .set({
        'name': widget.name,
        'surname': widget.surname,
        'email': widget.email,
        'role': isLandlord,
        'university': widget.university,
        'contactDetails': widget.contactDetails,
        'verificationCode': widget.verificationCode,
        'userId': userId,
        'gender': widget.gender,
        'ProofOfRegistration': _pdfPorDocument,
        'IdDocument': _pdfIdDocument,
        'studentNumber': widget.studentNumber,
        'studentId': widget.studentId,
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
                title: Text(
                  'Successful Registration',
                  style: TextStyle(fontSize: 15),
                ),
                content: Text(
                    'Your account was registered successfully. You can now proceed to login'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        // Close the dialog

                        Navigator.of(context).pop();

                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                          minimumSize: MaterialStatePropertyAll(
                              Size(double.infinity, 50))),
                      child: Text('Proceed')),
                ],
              ));
      // Show success dialog
    } on FirebaseException catch (e) {
      // Handle registration error
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
                  minimumSize: MaterialStatePropertyAll(Size(300, 50))),
              child: Text('Retry'),
            ),
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
    } catch (e) {
      print('Error  $e');
    }
  }

  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page(3/3)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child:
                    Icon(Icons.verified_user, color: Colors.blue, size: 130)),
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
                    sendEmail(
                        widget.email, // Student's email
                        'Verification Code',
                        widget.gender == 'Male'
                            ? 'Hello Mr ${widget.surname},\nWe are aware that you are trying to register your account on accomate App\nHere  is your verification code: ${widget.verificationCode}'
                            : 'Hello Mrs ${widget.surname},\nWe are aware that you are trying to register your account on accomate App\nHere  is your verification code: ${widget.verificationCode}');
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
                  foregroundColor: MaterialStatePropertyAll(Colors.blue),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  minimumSize: MaterialStatePropertyAll(Size(buttonWidth, 50))),
              child: Text(
                'Confirm Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
