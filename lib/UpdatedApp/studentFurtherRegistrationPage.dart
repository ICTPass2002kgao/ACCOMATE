// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/VerifyEmail.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class StudentFurtherRegister extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String surname;
  final String gender;
  final String university;
  final String contactDetails;
  final bool isLandlord;

  const StudentFurtherRegister(
      {super.key,
      required this.email,
      required this.name,
      required this.password,
      required this.surname,
      required this.gender,
      required this.university,
      required this.contactDetails,
      required this.isLandlord});

  @override
  State<StudentFurtherRegister> createState() => _StudentFurtherRegisterState();
}

class _StudentFurtherRegisterState extends State<StudentFurtherRegister> {
  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentNumberController = TextEditingController();

  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  void showError(String val, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text('Missing information',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text(val),
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
                minimumSize:
                    MaterialStatePropertyAll(Size(double.infinity, 50))),
          ),
        ],
      ),
    );
  }

  checkValues(BuildContext context) {
    String id = studentIdController.text;
    if (studentIdController.text == '') {
      showError('Please make sure you fill in all the details', context);
    } else if (studentNumberController.text == '') {
      showError('Please make sure you fill in all the details', context);
    } else if (id.length != 13) {
      showError('Please make sure you provide an existing Id(Identification)',
          context);
    } else if (_pdfIdDocumentPath == '') {
      showError('Please make sure you provide  the missing details', context);
    } else if (_pdfPorDocumentPath == '') {
      showError('Please make sure you provide  the missing details', context);
    } else {
      sendEmail(
          widget.email, // Student's email
          'Verification Code',
          widget.gender == 'Male'
              ? 'Hello Mr ${widget.surname},\nWe are aware that you are trying to register your account with accomate\nHere  is your verification code: $verificationCode\n\n\n\n\n\n\n\nBest Regards\nYours Accomate'
              : 'Hello Mrs ${widget.surname},\nWe are aware that you are trying to register your account with accomate\nHere  is your verification code: $verificationCode\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Verification Email Sent',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: 300,
            height: 280,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.green,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.done, color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(widget.gender == 'Male'
                    ? 'Hello Mr ${widget.surname},\nA verification code have been sent to ${widget.email} provide the codes to proceed'
                    : 'Hello Mrs ${widget.surname},\nA verification code have been sent to ${widget.email} provide the codes to proceed'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => CodeVerificationPage(
                              email: widget.email,
                              verificationCode: verificationCode,
                              name: widget.name,
                              surname: widget.surname,
                              university: widget.university,
                              gender: widget.gender,
                              studentId: studentIdController.text,
                              studentNumber: studentNumberController.text,
                              password: widget.password,
                              contactDetails: widget.contactDetails,
                              isLandlord: widget.isLandlord,
                              studentIdDoc: pdfIDFile,
                              studentPor: pdfPORFile,
                            ))));
              },
              child: Text('Verify'),
            ),
          ],
        ),
      );
    }
  }

  String _pdfPorDocumentPath = '';
  bool isFileChosen = false;
  File? pdfPORFile;
  Future<void> _pickProofOfRegistrationPDFFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfPORFile = File(result.files.single.path!);
        setState(() {
          _pdfPorDocumentPath = pdfPORFile.toString();
          isFileChosen = true; // Set the flag to true when a file is chosen
        });
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool isFileIdChosen = false;
  String _pdfIdDocumentPath = '';
  File? pdfIDFile;
  Future<void> _pickIdDocumentPDFFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfIDFile = File(result.files.single.path!);
        setState(() {
          _pdfIdDocumentPath = pdfIDFile.toString();
          isFileChosen = true; // Set the flag to true when a file is chosen
        });
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } on firebase_storage.FirebaseException catch (e) {
      // Handle login error
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page(2/3)'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: buttonWidth,
              child: Column(
                children: [
                  Center(
                    child: Image.asset('assets/icon.jpg',
                        height: 150, width: double.infinity),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: studentIdController,
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        fillColor: Color.fromARGB(255, 230, 230, 230),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'Id Number'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: studentNumberController,
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        fillColor: Color.fromARGB(255, 230, 230, 230),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'Student Number'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 5),
                  Container(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: buttonWidth,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pickIdDocumentPDFFile(context);
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(60, 50))),
                            child: Text('Choose file'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true, // Prevent manual editing
                              controller: TextEditingController(
                                  text: basename('$_pdfIdDocumentPath')),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(),
                                focusColor: Color.fromARGB(255, 230, 230, 230),
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                hintText: 'Your proof of registration',
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 5),
                  Container(
                      color: Colors.white70,
                      width: buttonWidth,
                      height: 50,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pickProofOfRegistrationPDFFile(context);
                            },
                            style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(60, 50))),
                            child: Text('Choose file'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true, // Prevent manual editing
                              controller: TextEditingController(
                                  text: basename('$_pdfPorDocumentPath')),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(),
                                focusColor: Color.fromARGB(255, 230, 230, 230),
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                hintText: 'Your Identification Document',
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      checkValues(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        foregroundColor: MaterialStatePropertyAll(Colors.blue),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        minimumSize:
                            MaterialStatePropertyAll(Size(buttonWidth, 50))),
                    child: Text(
                      'Register Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
