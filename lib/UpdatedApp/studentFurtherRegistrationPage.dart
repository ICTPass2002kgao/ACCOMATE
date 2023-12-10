// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

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

  TextEditingController proofOfRegistrationPath = TextEditingController();
  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  String _pdfDownloadPORURL = '';
  String _pdfPorDocumentPath = '';
  bool isFileChosen = false;

  Future<void> _pickProofOfRegistrationPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File pdfFile = File(result.files.single.path!);
        setState(() {
          _pdfPorDocumentPath = pdfFile.path;
          isFileChosen = true; // Set the flag to true when a file is chosen
        });

        String? downloadURL = await _uploadPickProofOfRegistration(pdfFile);

        if (downloadURL != null) {
          setState(() {
            _pdfDownloadPORURL = downloadURL;
          });
        }
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<String?> _uploadPickProofOfRegistration(File pdfFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('contracts')
          .child('$fileName.pdf');

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } catch (e) {
      _showErrorDialog(e.toString());
      return null;
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error Occurred',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }

  bool isFileIdChosen = false;
  String _pdfIdDocumentPath = '';
  String _pdfDownloadIDURL = '';
  Future<void> _pickIdDocumentPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File pdfFile = File(result.files.single.path!);
        setState(() {
          _pdfIdDocumentPath = pdfFile.path;
          isFileChosen = true; // Set the flag to true when a file is chosen
        });

        String? downloadURL = await _uploadIdDocumentPDFFile(pdfFile);

        if (downloadURL != null) {
          setState(() {
            _pdfDownloadIDURL = downloadURL;
          });
        }
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<String?> _uploadIdDocumentPDFFile(File pdfFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('contracts')
          .child('$fileName.pdf');

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } catch (e) {
      _showErrorDialog(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration Page'),
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
              child: Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.person_add_alt_rounded,
                      size: 150,
                      color: Colors.blue,
                    ),
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
                  ),
                  SizedBox(height: 5),
                  TextField(
                    cursorWidth: buttonWidth,
                    controller: studentNumberController,
                    decoration: InputDecoration(
                        focusColor: Colors.blue,
                        
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'Student Number'),
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
                              _pickIdDocumentPDFFile();
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
                                  text: '$_pdfIdDocumentPath'),
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
                              _pickProofOfRegistrationPDFFile();
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
                                  text: '$_pdfPorDocumentPath'),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(),
                                focusColor: Color.fromARGB(255, 230, 230, 230),
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                hintText: 'Your Idenification Document',
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String gender = widget.gender;
                      String email = widget.email;
                      String password = widget.password;
                      String university = widget.university;
                      String name = widget.name;
                      String surname = widget.surname;
                      String contact = widget.contactDetails;
                      String studentId = studentIdController.text;
                      String studentNumber = studentNumberController.text;

                      try {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent user from dismissing the dialog
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        );
                        // Create a user in Firebase Auth
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Get the user ID
                        String userId = userCredential.user!.uid;

                        // Send email verification
                        await userCredential.user!.sendEmailVerification();

                        // Save user data to Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .set({
                          'name': name,
                          'surname': surname,
                          'email': email,
                          'role': widget.isLandlord,
                          'university': university,
                          'contactDetails': contact,
                          'verificationCode': verificationCode,
                          'userId': userId,
                          'gender': gender,
                          'ProofOfRegistration': _pdfDownloadPORURL,
                          'IdDocument': _pdfDownloadIDURL,
                          'studentNumber': studentNumber,
                          'studentId': studentId,
                          // Add more user data as needed
                        });

                        // Inform the user to check their email for verification
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Verification Email Sent',
                              style: TextStyle(fontSize: 15),
                            ),
                            content: Text(
                                'Hi $name, \nA verification email has been sent to $email. Please check your email and verify your account.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Optionally, you can navigate to the login screen or do other actions
                                  if (!widget.isLandlord) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentPage(),
                                        ));
                                  }
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Unexpected Error',
                              style: TextStyle(fontSize: 15),
                            ),
                            content: Text(e.toString()),
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
                        print('Error during user registration: $e');
                        // Handle registration error
                      }
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
