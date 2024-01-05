// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ViewApplicantDetails extends StatefulWidget {
  final Map<String, dynamic> studentApplicationData;
  const ViewApplicantDetails({super.key, required this.studentApplicationData});

  @override
  State<ViewApplicantDetails> createState() => _ViewApplicantDetailsState();
}

class _ViewApplicantDetailsState extends State<ViewApplicantDetails> {
  TextEditingController messageController = TextEditingController();

  bool status = true;
  late User _user;
  String selectedRoomsType = '';

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

  Future<void> _saveApplicationResponse() async {
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

      String studentUserId = widget.studentApplicationData['userId'] ?? '';
      String landlordUserId = _userData?['userId'] ?? '';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(studentUserId)
          .collection('applicationsResponse')
          .doc(landlordUserId)
          .set({
        'landlordMessage': messageController.text,
        'accomodationName': _userData?['accomodationName'] ?? '',
        'path': _userData?['contractPath'] ?? '',
        'contract': _userData?['contract'] ?? '',
        'status': status,
        'userId': _userData?['userId'] ?? '',
        'registrationPreference': selectedregistrationPreference,

        // Add more details as needed
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
                    'Your response have been sent successfully to ${widget.studentApplicationData['name']}.',
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
                        'Hi ${_userData?['accomodationName']} landlord, \nYour application was sent successfully to ${widget.studentApplicationData['name']}');
                    await sendEmail(
                        widget
                            .studentApplicationData['email'], // Student's email
                        'Approved Application',
                        'Hi ${widget.studentApplicationData['name']} , \nYour application from ${_userData?['accomodationName']} have been approved and accepted');
                  } else {
                    await sendEmail(
                        _userData?['email'] ?? '', // Student's email
                        'Response sent successfully',
                        'Hi ${_userData?['accomodationName']} landlord, \nYour application was sent successfully to ${widget.studentApplicationData['name']}');
                    await sendEmail(
                        widget
                            .studentApplicationData['email'], // Student's email
                        'Rejected Application',
                        'Hi ${widget.studentApplicationData['name']} , \nYour application from ${_userData?['accomodationName']} have been rejected due to some reasons');
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
                child: Text('Okay'),
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

  String selectedregistrationPreference = '';
  List<String> registrationPreference = [
    'Contact Registration',
    'Online Registration',
  ];
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 600;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.studentApplicationData['name']} Application details'),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                              child: Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Surname',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Gender',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Cell No',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Email Address',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('University',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Proof Of Registration',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Id Document',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Identification Number',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Student Number',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Room Type',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text('Year of study',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['name'] ??
                                      'Kgaogelo')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['surname'] ??
                                      'Mthimkhulu')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['gender'] ??
                                      'male')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(widget.studentApplicationData[
                                      'contactDetails'] ??
                                  'null')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['email'] ??
                                      'null')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['university'] ??
                                      'yyyy')),
                        ),
                        TableCell(
                          child: Center(
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final String downloadUrl =
                                        widget.studentApplicationData[
                                                'ProofOfRegistration'] ??
                                            '';

                                    downloadFile(context, downloadUrl,
                                        "${widget.studentApplicationData['name'] ?? ''}'s Proof of registration");
                                  },
                                  icon:
                                      Icon(Icons.download, color: Colors.blue),
                                  label: Text(''))),
                        ),
                        TableCell(
                          child: Center(
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final String downloadUrl =
                                        widget.studentApplicationData[
                                                'IdDocument'] ??
                                            '';

                                    downloadFile(context, downloadUrl,
                                        "${widget.studentApplicationData['name'] ?? ''}'s Id document");
                                  },
                                  icon:
                                      Icon(Icons.download, color: Colors.blue),
                                  label: Text(''))),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['studentId'] ??
                                      'yyyy')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(widget.studentApplicationData[
                                      'studentNumber'] ??
                                  'yyyy')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(
                                  widget.studentApplicationData['roomType'] ??
                                      'yyyy')),
                        ),
                        TableCell(
                          child: Center(
                              child: Text(widget
                                      .studentApplicationData['fieldOfStudy'] ??
                                  'yyyy')),
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
                          Text('Accept applicant'),
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
                          Text('Reject applicant'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: buttonWidth,
                  child: ExpansionTile(
                    title: Text('Select registration preference',
                        style: TextStyle(
                            color: selectedregistrationPreference.isEmpty
                                ? Colors.red
                                : Colors.black)),
                    children: registrationPreference
                        .map((paramRegistrationPreference) {
                      return RadioListTile<String>(
                        title: Text(paramRegistrationPreference),
                        value: paramRegistrationPreference,
                        groupValue: selectedregistrationPreference,
                        onChanged: (value) {
                          setState(() {
                            selectedregistrationPreference = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                status == true
                    ? Column(
                        children: [
                          selectedregistrationPreference ==
                                  'Online Registration'
                              ? Text(
                                  'Alert student on how to register and all the field they should sign from the contract.')
                              : Text(
                                  'Please note that student have 2days to come for contact registration, \n\nThank you!!'),
                          selectedregistrationPreference ==
                                  'Online Registration'
                              ? Container(
                                  width: buttonWidth,
                                  child: TextField(
                                    maxLines: 4,
                                    controller: messageController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Registration Instructions"),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                              'Please provide the reason a student is rejected & let the student know that they can reApply if their prefered room is not available'),
                          Container(
                            width: buttonWidth,
                            child: TextField(
                              maxLines: 4,
                              controller: messageController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Rejected reason"),
                            ),
                          ),
                        ],
                      ),

                SizedBox(
                  height: 10,
                ),

                //Additional Message to student

                ElevatedButton.icon(
                  onPressed: () {
                    _saveApplicationResponse();
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
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
        ));
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
