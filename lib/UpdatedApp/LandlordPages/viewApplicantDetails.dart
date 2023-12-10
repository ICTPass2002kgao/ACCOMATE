// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewApplicantDetails extends StatefulWidget {
  final Map<String, dynamic> studentApplicationData;
  const ViewApplicantDetails({super.key, required this.studentApplicationData});

  @override
  State<ViewApplicantDetails> createState() => _ViewApplicantDetailsState();
}

class _ViewApplicantDetailsState extends State<ViewApplicantDetails> {
  TextEditingController messageController = TextEditingController();
  // Future<void> _showAddOffersDialog() async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'Appliation response',
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         content: TextField(
  //           maxLines: 4,
  //           controller: messageController,
  //           decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               labelText: "Any Other Information"),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 30.0, right: 30),
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 _saveApplicationResponse();
  //               },
  //               style: ButtonStyle(
  //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5))),
  //                   foregroundColor: MaterialStatePropertyAll(Colors.white),
  //                   backgroundColor: MaterialStatePropertyAll(Colors.green),
  //                   minimumSize:
  //                       MaterialStatePropertyAll(Size(double.infinity, 50))),
  //               child: Text('Sent response'),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
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

        // Add more details as needed
      });
      await confirmationEmail(
          _userData?['email'] ?? '', // Student's email
          'Application approved',
          'Hi ${widget.studentApplicationData['name']}, \nYour application was approved from ${_userData?['accomodationName'] ?? ''}, sign the following contract and return it. and sent whats required details by the landlord go to your notification for all the information');

      print('email sent successfully');

      showDialog(
        context: context,
        builder: (context) => Container(
          height: 200,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Successful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Column(
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
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/LandlordPage');
                  await confirmationEmail(
                      _userData?['email'] ?? '', // Student's email
                      'Response sent successfully',
                      'Hi ${_userData?['accomodationName']} landlord, \nYour application was sent successfully to ${widget.studentApplicationData['name']}');

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
      FirebaseFunctions.instance.httpsCallable('confirmationEmail');

  Future<void> confirmationEmail(String to, String subject, String body) async {
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
                child: Text('Submit'),
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
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
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

                                    downloadFile(downloadUrl);
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

                                    downloadFile(downloadUrl);
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
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: buttonWidth,
                  child: TextField(
                    maxLines: 4,
                    controller: messageController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            "Accepted Additional Information or Rejected reason"),
                  ),
                ),

                //Additional Message to student

                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveApplicationResponse();
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      label: Text('Accept'),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                          minimumSize: MaterialStatePropertyAll(Size(55, 50))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _saveApplicationResponse();
                      },
                      icon: Icon(
                        Icons.dnd_forwardslash_outlined,
                        color: Colors.white,
                      ),
                      label: Text('Reject'),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                          minimumSize: MaterialStatePropertyAll(Size(55, 50))),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

void downloadFile(String url) async {
  final html.AnchorElement anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'file_name_to_be_saved_as.pdf';

  // Trigger a click on the anchor element
  html.document.body!.append(anchor);
  anchor.click();

  // Wait for the file to be downloaded
  await Future.delayed(Duration(seconds: 2));

  // Remove the anchor element from the DOM
  anchor.remove();
}
