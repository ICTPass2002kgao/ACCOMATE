import 'dart:convert';

import 'package:api_com/UpdatedApp/LandlordPages/Tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ApplyAccomodation extends StatefulWidget {
  final Map<String, dynamic> landlordData;
  const ApplyAccomodation({super.key, required this.landlordData});

  @override
  State<ApplyAccomodation> createState() => _ApplyAccomodationState();
}

class _ApplyAccomodationState extends State<ApplyAccomodation> {
  String selectedRoomsType = '';
  String periodOfStudy = '';
  String yearOfStudy = '';
  List<String> _yearsOfStudy = [
    "First Year",
    "Second Year",
    "Third Year",
    "Fourth Year"
  ];

  List<String> _periodOfStudy = [
    "First Semester",
    "Second Semester",
    "Full Year"
  ];
  late User? _user;

  Map<String, dynamic>? _userData;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _sendNotification(
      String title, String body, String? token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-accomodationapp-9d851.cloudfunctions.net/sendNotification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'body': body,
          'token': token!,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final smtpServer = gmail('accomate33@gmail.com', 'nhle ndut leqq baho');
    final message = Message()
      ..from = Address('accomate33@gmail.com', 'Accomate Team')
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

  void _appliedStudent() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Container(
        height: 250,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.blue[50],
          title: Text(
            'Application Response',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    color: const Color.fromRGBO(239, 83, 80, 1),
                    width: 100,
                    height: 100,
                    child: Icon(Icons.cancel_outlined,
                        color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Please note that an application cannot be duplicated, You have already applied to this accommodation.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                print('email sent successfully');
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red[300]),
              ),
              child: Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 30), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, '/studentPage');
          }
        });

        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.blue[50],
            ),
            height: 360,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.network(
                      repeat: false,
                      'https://lottie.host/7b0dcc73-3274-41ef-a3f3-5879cade8ffa/zCbLIAPAww.json',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            height: 100,
                            width: 100,
                            color: Colors.green,
                            child: Center(
                              child: Icon(
                                Icons.done,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Submitted successfully',
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, '/studentPage');
                        String? fcmToken = await _firebaseMessaging.getToken();
                        _sendNotification(
                            'Successful Application',
                            'Hello, ${_userData?['name'] ?? ''}, your application was sent successfully.',
                            fcmToken);
                      },
                      child: Text('Done'),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          minimumSize: WidgetStatePropertyAll(Size(200, 50))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveApplicationDetails() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      String landlordUserId = widget.landlordData['userId'] ?? '';
      String studentUserId = _userData?['userId'] ?? '';

      DocumentSnapshot applicationSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(landlordUserId)
          .collection('applications')
          .doc(studentUserId)
          .get();

      if (applicationSnapshot.exists) {
        Navigator.of(context).pop();
        _appliedStudent();

        return;
      }

      DateTime now = DateTime.now();
      Timestamp appliedDate = Timestamp.fromDate(now);
      await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(landlordUserId)
          .collection('applications')
          .doc(studentUserId)
          .set({
        'name': _userData?['name'] ?? '',
        'surname': _userData?['surname'] ?? '',
        'university': _userData?['university'] ?? '',
        'email': _userData?['email'] ?? '',
        'contactDetails': _userData?['contactDetails'] ?? '',
        'gender': _userData?['gender'] ?? '',
        'userId': _userData?['userId'] ?? '',
        'roomType': selectedRoomsType,
        'fieldOfStudy': yearOfStudy,
        'periodOfStudy': periodOfStudy,
        'applicationReviewed': false,
        'appliedDate': appliedDate,
      });
      sendEmail(
        widget.landlordData['email'] ?? '',
        'Application Received',
        'Hi ${widget.landlordData['accomodationName'] ?? ''} landlord, \nYou have a new application from a student at ${_userData?['university']}.\nName & Surname:${_userData?['name']} ${_userData?['surname']} \nBest Regards\nYour Accomate Team',
      );

      await sendEmail(
          _userData?['email'] ?? '',
          'Application sent successfully',
          'Hi ${_userData?['name'] ?? ''} , \nYour application was sent successfully to ${widget.landlordData['accomodationName'] ?? ''}, You will get further communication soon.\n\nBest Regards\nYour Accomate Team');

      String? fcmToken = await _firebaseMessaging.getToken();
      _sendNotification(
          'Successful Application',
          'Hello, ${_userData?['name'] ?? ''}, your application was sent successfully.',
          fcmToken);

      Navigator.of(context).pop();
      showLoadingDialog(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Apply Accomodation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Hi ${_userData?['name']}, we are informing you that you are about to apply for ${widget.landlordData['accomodationName']} with the following details'),
              SizedBox(height: 16.0),
              Tables(columnName: 'Name', columnValue: _userData?['name'] ?? ''),
              Tables(
                  columnName: 'Surname',
                  columnValue: _userData?['surname'] ?? ''),
              Tables(
                  columnName: 'University',
                  columnValue: _userData?['university'] ?? ''),
              Tables(
                  columnName: 'Email', columnValue: _userData?['email'] ?? ''),
              Tables(
                  columnName: 'Gender',
                  columnValue: _userData?['gender'] ?? ''),
              Tables(
                  columnName: 'Phone Number',
                  columnValue: _userData?['contactDetails'] ?? ''),
              ExpansionTile(
                title: Text('Select type of a room'),
                children: widget.landlordData['roomType'].keys
                    .map<Widget>((roomType) {
                  return RadioListTile<String>(
                    title: Text(roomType),
                    value: roomType,
                    groupValue: selectedRoomsType,
                    onChanged: (value) {
                      setState(() {
                        selectedRoomsType = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              ExpansionTile(
                title: Text('Select period of study',
                    style: TextStyle(
                        color: _periodOfStudy.isEmpty
                            ? Colors.red
                            : Colors.black)),
                children: _periodOfStudy.map((StudyDurationStudy) {
                  return RadioListTile<String>(
                    title: Text(StudyDurationStudy),
                    value: StudyDurationStudy,
                    groupValue: periodOfStudy,
                    onChanged: (value) {
                      setState(() {
                        periodOfStudy = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              ExpansionTile(
                title: Text('Select year of study',
                    style: TextStyle(
                        color:
                            yearOfStudy.isEmpty ? Colors.red : Colors.black)),
                children: _yearsOfStudy.map((year) {
                  return RadioListTile<String>(
                    title: Text(year),
                    value: year,
                    groupValue: yearOfStudy,
                    onChanged: (value) {
                      setState(() {
                        yearOfStudy = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: selectedRoomsType.isEmpty ||
                        periodOfStudy.isEmpty ||
                        yearOfStudy.isEmpty
                    ? null
                    : () => _saveApplicationDetails(),
                child: Text('Submit Application'),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  minimumSize: WidgetStatePropertyAll(Size(buttonWidth, 50)),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  backgroundColor: WidgetStateProperty.all(
                      selectedRoomsType.isEmpty ||
                              periodOfStudy.isEmpty ||
                              yearOfStudy.isEmpty
                          ? Colors.grey
                          : Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
