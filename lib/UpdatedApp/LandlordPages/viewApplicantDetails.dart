// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

import 'package:api_com/UpdatedApp/LandlordPages/Tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    loadData();
  }

  bool isLoading = true;
  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 3));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
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

  void _showFeedback() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Container(
        height: 200,
        width: 250,
        child: AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text(
            'Successful Feedback',
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
                  'Your feedback have been sent successfully to ${widget.studentApplicationData['name']}.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
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
  }

  Future<void> _saveApplicationResponse() async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
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

      DateTime now = DateTime.now();
      Timestamp feedbackDate = Timestamp.fromDate(now);
      FirebaseFirestore.instance
          .collection('Students')
          .doc(widget.studentApplicationData['userId'] ?? '')
          .update({'applicationReviewed': true});
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
        'feedbackDate': feedbackDate
      });

      await sendEmail(
        _userData?['email'] ?? '',
        'Response sent successfully',
        'Hi ${_userData?['accomodationName']} landlord, \nYour feedback was sent successfully to ${widget.studentApplicationData['name']} ${widget.studentApplicationData['surname']}.\nBest Regards\nYour Accomate Team',
      );

      if (status == true) {
        await sendEmail(
          widget.studentApplicationData['email'],
          'Application Approved',
          'Hi ${widget.studentApplicationData['name']} , \nYour application from ${_userData?['accomodationName']} have been approved. Go to notification page in our app for more information.\nBest Regards\nYour Accomate Team',
        );
      } else {
        await sendEmail(
          widget.studentApplicationData['email'],
          'Application Rejected',
          'Hi ${widget.studentApplicationData['name']} , \nYour application from ${_userData?['accomodationName']} have been rejected due to some reasons. Go to notification page in our app for more information.\nBest Regards\nYour Accomate Team',
        );
      }

      // Dismiss the progress indicator
      Navigator.of(context).pop();

      // Show feedback dialog
      _showFeedback();
    } catch (e) {
      // Dismiss the progress indicator in case of error
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  minimumSize:
                      MaterialStatePropertyAll(Size(double.infinity, 50)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

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
        body: isLoading
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
            : Container(
                color: Colors.blue[100],
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tables(
                            columnName: 'Name',
                            columnValue:
                                widget.studentApplicationData['name'] ?? ''),
                        Tables(
                            columnName: 'Surname',
                            columnValue:
                                widget.studentApplicationData['surname'] ?? ''),
                        Tables(
                            columnName: 'Cellphone Number',
                            columnValue: widget
                                    .studentApplicationData['contactDetails'] ??
                                ''),
                        Tables(
                            columnName: 'Email Address',
                            columnValue:
                                widget.studentApplicationData['email'] ?? ''),
                        Tables(
                            columnName: 'Enrolled University',
                            columnValue:
                                widget.studentApplicationData['university'] ??
                                    ''),
                        Tables(
                            columnName: 'Type of room',
                            columnValue:
                                widget.studentApplicationData['roomType'] ??
                                    ''),
                        Tables(
                            columnName: 'Period of study',
                            columnValue:
                                widget.studentApplicationData['fieldOfStudy'] ??
                                    ''),
                        Tables(
                            columnName: 'Year of study',
                            columnValue: widget
                                    .studentApplicationData['periodOfStudy'] ??
                                ''),
                        Tables(
                            columnName: 'Application Date & Time',
                            columnValue: DateFormat('yyyy-MM-dd HH:mm').format(
                                widget.studentApplicationData['appliedDate']
                                    .toDate())),
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
                                    fillColor:
                                        MaterialStatePropertyAll(Colors.green),
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
                                    fillColor:
                                        MaterialStatePropertyAll(Colors.red),
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
                                  'Please provide the reason a student is rejected & let the student know that they can reApply if their prefered room is not available or the problem can be resolved.'),
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
                        ElevatedButton.icon(
                          onPressed: () {
                            _saveApplicationResponse();
                          },
                          icon: Icon(
                            Icons.feedback_outlined,
                            color: Colors.white,
                          ),
                          label: Text('Send Response'),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  status == true
                                      ? Colors.green
                                      : Colors.red[300]),
                              minimumSize: MaterialStatePropertyAll(
                                  Size(buttonWidth, 50))),
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
