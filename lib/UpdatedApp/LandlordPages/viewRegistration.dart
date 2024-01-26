// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewRegistrations extends StatefulWidget {
  final Map<String, dynamic> studentRegistrationData;
  const ViewRegistrations({super.key, required this.studentRegistrationData});

  @override
  State<ViewRegistrations> createState() => _ViewRegistrationsState();
}

class _ViewRegistrationsState extends State<ViewRegistrations> {
  TextEditingController messageController = TextEditingController();

  bool status = true;
  late User _user;

  Map<String, dynamic>? _userData;
  // Make _userData nullable
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _saveRegistrationResponse() async {
    try {
      showDialog(
        context: context, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      );

      String studentUserId = widget.studentRegistrationData['userId'] ?? '';
      String landlordUserId = _userData?['userId'] ?? '';
      if (status == true)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(landlordUserId)
            .collection('registeredStudents')
            .doc(studentUserId)
            .set({
          'name': widget.studentRegistrationData['name'],
          'surname': widget.studentRegistrationData['surname'],
          'email': widget.studentRegistrationData['email'],
          'studentNumber': widget.studentRegistrationData['studentNumber'],
          'userId': studentUserId,
        });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(studentUserId)
          .collection('registrationResponse')
          .doc(landlordUserId)
          .set({
        'landlordMessage': messageController.text,
        'accomodationName': _userData?['accomodationName'] ?? '',
        'status': status,
        'userId': _userData?['userId'] ?? '',
        'profile': _userData?['profilePicture'] ?? '',
      });

      print('email sent successfully');

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Container(
          height: 200,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Successful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 200,
              width: 250,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      color: Colors.green,
                      width: 80,
                      height: 80,
                      child: Icon(Icons.done, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your response have been sent successfully to ${widget.studentRegistrationData['name']}.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context, // Prevent user from dismissing the dialog
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    },
                  );

                  if (status == true) {
                    await sendEmail(
                        _userData?['email'] ?? '', // Student's email
                        'Response sent successfully',
                        'Hi ${_userData?['accomodationName']} landlord, \nYour registration response was sent successfully to ${widget.studentRegistrationData['name']}');
                    await sendEmail(
                        widget.studentRegistrationData[
                            'email'], // Student's email
                        'Successful registration',
                        'Hi ${widget.studentRegistrationData['name']} , \nYour registration from ${_userData?['accomodationName']} have been approved, you have right to go to your residence anytime.');
                  } else {
                    await sendEmail(
                        _userData?['email'] ?? '', // Student's email
                        'Response sent successfully',
                        'Hi ${_userData?['accomodationName']} landlord, \nYour registration response was sent successfully to ${widget.studentRegistrationData['name']}');
                    await sendEmail(
                        widget.studentRegistrationData[
                            'email'], // Student's email
                        'Unsuccessful registration',
                        'Hi ${widget.studentRegistrationData['name']} , \nYour registration from ${_userData?['accomodationName']} have been rejected due to some reasons');
                  }
                  Navigator.pushReplacementNamed(context, '/LandlordPage');

                  print('email sent successfully');
                },
                child: Text('Submit'),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Unsuccessful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop;
                },
                child: Text('Okay'),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.red[400]),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
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
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Successful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop;
                },
                child: Text('okay'),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Student'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                            child: Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Surname',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Gender',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Cell No',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Email Address',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('University',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Proof Of Registration',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Id Document',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Identification Number',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Student Number',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Room Type',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Year of study',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        child: Center(
                            child: Text('Signed Contract',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['name'] ??
                                    'Kgaogelo')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['surname'] ??
                                    'Mthimkhulu')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['gender'] ??
                                    'male')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(widget.studentRegistrationData[
                                    'contactDetails'] ??
                                'null')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['email'] ??
                                    'null')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['university'] ??
                                    'yyyy')),
                      ),
                      TableCell(
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            final String downloadUrl =
                                widget.studentRegistrationData[
                                        'ProofOfRegistration'] ??
                                    '';

                            downloadFile(context, downloadUrl,
                                "${widget.studentRegistrationData['name'] ?? ''}'s Proof of registration");
                          },
                          icon: Icon(Icons.download, color: Colors.blue),
                        )),
                      ),
                      TableCell(
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            final String downloadUrl =
                                widget.studentRegistrationData['IdDocument'] ??
                                    '';

                            downloadFile(context, downloadUrl,
                                "${widget.studentRegistrationData['name'] ?? ''}'s Id document");
                          },
                          icon: Icon(Icons.download, color: Colors.blue),
                        )),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['studentId'] ??
                                    'yyyy')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(widget
                                    .studentRegistrationData['studentNumber'] ??
                                'yyyy')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(
                                widget.studentRegistrationData['roomType'] ??
                                    'yyyy')),
                      ),
                      TableCell(
                        child: Center(
                            child: Text(widget
                                    .studentRegistrationData['fieldOfStudy'] ??
                                'yyyy')),
                      ),
                      TableCell(
                        child: Center(
                            child: IconButton(
                          onPressed: () async {
                            final String downloadUrl =
                                widget.studentRegistrationData[
                                        'signedContract'] ??
                                    '';

                            downloadFile(context, downloadUrl,
                                "${widget.studentRegistrationData['name'] ?? ''}'s signed Contract");
                          },
                          icon: Icon(Icons.download, color: Colors.blue),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: buttonWidth,
                child: ExpansionTile(
                  title: Text('Choose Status'),
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.green,
                          fillColor: MaterialStatePropertyAll(Colors.green),
                          value: true,
                          groupValue: status,
                          onChanged: (value) {
                            setState(() {
                              status = value!;
                            });
                          },
                        ),
                        Text('Approve Registration'),
                      ],
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.red,
                          fillColor: MaterialStatePropertyAll(Colors.red),
                          value: false,
                          groupValue: status,
                          onChanged: (value) {
                            setState(() {
                              status = value!;
                            });
                          },
                        ),
                        Text('Reject Registration'),
                      ],
                    ),
                  ],
                ),
              ),
              if (status == false)
                Column(
                  children: [
                    Text(
                        'Please provide the reason why the registration of a student is declined & let the student know that they can resend their contract'),
                    Container(
                      width: buttonWidth,
                      child: TextField(
                        maxLines: 4,
                        controller: messageController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Declined reason"),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  status == true
                      ? await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.studentRegistrationData['userId'])
                          .update({
                          'registered': true,
                          'registeredAccomodation':
                              _userData!['accomodationName'] ?? ''
                        })
                      : await FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.studentRegistrationData['userId'])
                          .update({'registered': false});

                  _saveRegistrationResponse();
                },
                icon: Icon(
                  status == true ? Icons.done : Icons.delete,
                  color: Colors.white,
                ),
                label: Text('Send Response'),
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(
                        status == true ? Colors.green : Colors.red[300]),
                    minimumSize:
                        MaterialStatePropertyAll(Size(buttonWidth, 50))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(
      BuildContext context, String downloadUrl, String fileName) async {
    try {
      // Check for storage permission
      // var status = await Permission.storage.status;
      // if (!status.isGranted) {
      //   await Permission.storage.request();
      // }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Downloading...', style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ));
      // Get the application documents directory
      // Get the Downloads directory
      Directory? downloadsDirectory = await getDownloadsDirectory();

      if (downloadsDirectory != null) {
        String savePath = '${downloadsDirectory.path}/${fileName}.pdf';

        // Create a reference to the Firebase Storage file
        Reference storageReference =
            FirebaseStorage.instance.ref().child(downloadUrl);

        // Download the file to the device
        await Dio().download(storageReference.fullPath, savePath);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('File downloaded successfully!',
              style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file'),
        ),
      );
    }
  }
}
