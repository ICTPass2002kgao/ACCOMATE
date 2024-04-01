// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

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

  Map<String, dynamic>? _userData;
  // Make _userData nullable
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();

    FirebaseFirestore.instance
        .collection('Students')
        .doc(widget.studentApplicationData['userId'] ?? '')
        .update({'applicationReviewed': true});
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
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
          .collection('Students')
          .doc(studentUserId)
          .collection('applicationsResponse')
          .doc(landlordUserId)
          .set({
        'landlordMessage': messageController.text,
        'accomodationName': _userData?['accomodationName'] ?? '',

        'status': status,
        'userId': _userData?['userId'] ?? '',

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
            backgroundColor: Colors.blue[100],
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
                      child: Icon(Icons.done, color: Colors.white, size: 35),
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
              OutlinedButton(
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
                  Navigator.pushReplacementNamed(context, '/landlordPage');

                  print('email sent successfully');
                },
                child: Text('Continue'),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                ),
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

  // final HttpsCallable sendEmailCallable =
  //     FirebaseFunctions.instance.httpsCallable('sendEmail');

  Future<void> sendEmail(
    String recipientEmail,
    String subject,
    String body,
  ) async {
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
        body: Container(
          color: Colors.blue[100],
          height: double.infinity,
          child: SingleChildScrollView(
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(
                                    widget.studentApplicationData['name'] ??
                                        '')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('Surname',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(
                                    widget.studentApplicationData['surname'] ??
                                        'Mthimkhulu')),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('Cellphone Number',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(widget.studentApplicationData[
                                        'contactDetails'] ??
                                    '')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('Email Address',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(
                                    widget.studentApplicationData['email'] ??
                                        'Mthimkhulu')),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('University',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(widget
                                        .studentApplicationData['university'] ??
                                    '')),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('Type of room',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                          TableCell(
                            child: Center(
                                child: Text(
                                    widget.studentApplicationData['roomType'] ??
                                        '')),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text('Year of study',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                                child: Text(widget.studentApplicationData[
                                        'YearOfStudy'] ??
                                    '')),
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
                    height: 20,
                  ),

                  if (status == false)
                    Column(
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
          ),
        ));
  }
}
