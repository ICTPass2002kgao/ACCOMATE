// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:api_com/advanced_details.dart';
import 'package:api_com/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentRegistration2 extends StatefulWidget {
  const StudentRegistration2(
      {super.key,
      required this.name,
      required this.surname,
      required this.email,
      required this.password,
      required this.userType});
  final String name;
  final String surname;
  final String email;
  final String password;
  final String userType;

  @override
  State<StudentRegistration2> createState() => _StudentRegistration2State();
}

class _StudentRegistration2State extends State<StudentRegistration2> {
  String? pdfPath;
  final TextEditingController txtCellNumber = TextEditingController();
  final TextEditingController txtStudentNumber = TextEditingController();
  final TextEditingController txtIdNumber = TextEditingController();
  late final RegistrationService registrationService;
  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfPath = result.files.single.path;
      });
    }
  }

  File? userImage;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        userImage = File(pickedFile.path);
      });
    }
  }

  Widget _imageWidget(String imagePath) {
    if (imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        height: 50,
        width: 50,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 5));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 600 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          "Personal Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              Center(
                child: Container(
                  width: buttonWidth,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Icon(Icons.lock_person,
                          size: 150, color: Colors.blue),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: txtIdNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusColor: Colors.blue,
                          fillColor: Color.fromARGB(255, 230, 230, 230),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_3_outlined,
                            color: Colors.blue,
                          ),
                          hintText: 'Enter your ID Number'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: txtStudentNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusColor: Colors.blue,
                          fillColor: Color.fromARGB(255, 230, 230, 230),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: Colors.blue,
                          ),
                          hintText: 'Enter your Student Number'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txtCellNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          focusColor: Colors.blue,
                          fillColor: Color.fromARGB(255, 230, 230, 230),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.numbers,
                            color: Colors.blue,
                          ),
                          labelText: 'Cellphone No'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      width: buttonWidth,
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _pickPDF,
                            child: Text('Proof of Registration',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(100, 50))),
                          ),
                          SizedBox(width: 5),
                          if (pdfPath != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Selected PDF: $pdfPath'),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 230, 230, 230),
                      width: buttonWidth,
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              // ignore: await_only_futures
                              await _getImage();
                            },
                            icon: Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.white),
                            label: Text(
                              'Add Image',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(100, 50))),
                          ),
                          if (userImage != null)
                            Image.file(
                              File(userImage.toString()),
                              height: 50,
                              width: 50,
                            )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        // Implement registration logic using all details
                        String name = widget.name;
                        String surname = widget.surname;
                        String email = widget.email;
                        String password = widget.password;
                        String userType = widget.userType;
                        File? image = userImage;
                        String? pdf = pdfPath;
                        String studentNumber = txtStudentNumber.text;
                        String contactNumber = txtCellNumber.text;
                        String id = txtIdNumber.text;

                        // Call the registerUser function
                        try {
                          await StudentRegistrationService().registerUser(
                            userType: userType,
                            name: name,
                            surname: surname,
                            email: email,
                            password: password,
                            imagePath: image.toString(),
                            pdfPath: pdf.toString(),
                            studentNumber: studentNumber,
                            contact: contactNumber,
                            id: id,
                          );

                          // Navigate to the student page after successful registration
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentPage(),
                            ),
                          );
                        } catch (e) {
                          // Handle registration errors
                          // You might want to show an error message to the user
                          print('Registration failed: $e');
                        }
                      },
                      child: Text(
                        'Proceed',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 2),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          minimumSize: MaterialStatePropertyAll(
                              Size(double.infinity, 50))),
                    ),
                  ]),
                ),
              )
            ]),
          )),
    );
  }
}

// https://kotlinlang.org/docs/releases.html#release-details