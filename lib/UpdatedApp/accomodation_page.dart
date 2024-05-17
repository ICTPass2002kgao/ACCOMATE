// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:http/http.dart' as http;

class AccomodationPage extends StatefulWidget {
  final Map<String, dynamic> landlordData;
  const AccomodationPage({
    super.key,
    required this.landlordData,
    // required this.imageUrls,
  });

  @override
  State<AccomodationPage> createState() => _AccomodationPageState();
}

class _AccomodationPageState extends State<AccomodationPage> {
  List<String> roomType = [
    'Single room',
    'Sharing/double room',
    "Bachelor's room",
  ];

  String yearOfStudy = '';

  List<String> yearofStudy = ['6 Months', '10 Months'];
  late User _user;
  String selectedRoomsType = '';

  Map<String, dynamic>? _userData;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Make _userData nullable
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    yearOfStudy = 'Second year';
    // Initialize Firebase Messaging
    _initializeFirebaseMessaging();
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permission to show notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    String? fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    await _sendNotification('Lover text', 'Hello i love you', fcmToken);
  }

  Future<void> _sendNotification(String title, String body, token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://us-central1-com.example.api_com.cloudfunctions.net/sendNotification'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // Pass title and body as JSON data in the request body
        body: jsonEncode(<String, String>{
          'title': title,
          'body': body,
          'token': token,
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
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  void _appliedStudent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Container(
        height: 250,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(
            'Application Response',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.red[400],
                    width: 80,
                    height: 80,
                    child: Icon(Icons.cancel_outlined,
                        color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'You are already applied at this accomodation at ${_userData!['appliedAccomodation'] ?? ''}.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/studentPage');

                print('email sent successfully');
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveApplicationDetails() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
          Navigator.of(context).pop();
        },
      );

      String landlordUserId = widget.landlordData['userId'] ?? '';
      String studentUserId = _userData?['userId'] ?? '';
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(studentUserId)
          .update({
        'roomType': selectedRoomsType,
        'fieldOfStudy': yearOfStudy,
      });
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
        'roomType': _userData?['roomType'] ?? '',
        'fieldOfStudy': _userData?['fieldOfStudy'] ?? '',
        'applicationReviewed': false
      });

      sendEmail(
        widget.landlordData['email'] ?? '',
        'Application Received',
        'Hi ${widget.landlordData['accomodationName'] ?? ''} landlord, \nYou have a new application from a student at ${_userData?['university']}.\n\n\n\n\nBest regards\nYours Accomate',
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          height: 250,
          child: AlertDialog(
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              'Application Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 200,
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
                    'Your application was sent successfully. You will get further communication soon.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/studentPage');

                  await sendEmail(
                      _userData?['email'] ?? '', // Student's email
                      'Application sent successfully',
                      'Hi ${_userData?['name'] ?? ''} , \nYour application was sent successfully to ${widget.landlordData['accomodationName'] ?? ''}, You will get further communication soon.\n\n\n\n\nBest regards\nYours Accomate');

                  print('email sent successfully');
                },
                child: Text('Done'),
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
      print(e);
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
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.landlordData['accomodationName'] ?? '',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.blue[100],
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: buttonWidth,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          widget.landlordData['displayedImages'][index],
                          fit: BoxFit.cover,
                        );
                      },
                      itemCount: widget.landlordData['displayedImages'].length,
                      pagination: SwiperPagination(
                          margin: EdgeInsets.all(5),
                          builder: SwiperPagination.rect),
                      control: SwiperControl(
                          size: 20,
                          color: Colors.blue,
                          iconNext: Icons.navigate_next_outlined,
                          iconPrevious: Icons.navigate_before_rounded),
                      autoplay: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Address: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                widget.landlordData['location'] ?? 'Loading...',
                                maxLines: 1, // Set the maximum number of lines
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Distance to campus: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.landlordData['distance'] ??
                                'Loading...'),
                            Icon(
                              Icons.location_on_outlined,
                              size: 13,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text('For more information contact us via:'),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text('Email: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.landlordData['email'] ?? '',
                              maxLines: 1, // Set the maximum number of lines
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text('Contact: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.landlordData['contactDetails'] ?? '',
                              maxLines: 1, // Set the maximum number of lines
                              overflow: TextOverflow.clip,
                            ),
                          ],
                        ),
                        Text('Accommodated institutions',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        for (String university
                            in widget.landlordData['selectedUniversity'].keys)
                          if (widget.landlordData['selectedUniversity']
                                  ?[university] ??
                              false)
                            Text('$university'),
                        SizedBox(height: 5),
                        ExpansionTile(
                          title: Text('More details',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          children: [
                            ListTile(
                              title: Text('Offered amities',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            for (String offers
                                in widget.landlordData['selectedOffers'].keys)
                              if (widget.landlordData['selectedOffers']
                                      ?[offers] ??
                                  false)
                                ListTile(
                                  title: Text(offers),
                                ),
                            SizedBox(height: 5),
                            ListTile(
                              title: Text('Payment Methods',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            for (String paymentMethods in widget
                                .landlordData['selectedPaymentsMethods'].keys)
                              if (widget.landlordData['selectedPaymentsMethods']
                                      ?[paymentMethods] ??
                                  false)
                                ListTile(
                                  title: Text(paymentMethods),
                                ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        _userData?['registered'] == true
                            ? _appliedStudent()
                            : showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return AlertDialog(
                                      backgroundColor: Colors.blue[100],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      scrollable: true,
                                      title: Text('Confirm your details',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ... (your existing code)
                                          Text(
                                              'Hi ${_userData?['name']}, we are informing you that you are about to apply for ${widget.landlordData['accomodationName']} with the following details'),
                                          SizedBox(height: 16.0),
                                          Text(
                                              "Name: ${_userData?['name'] ?? 'Loading...'}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "Surname: ${_userData?['surname'] ?? 'Loading...'}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "Enrolled Institution: ${_userData?['university']}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "Email: ${_userData?['email'] ?? 'Loading...'}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "Gender: ${_userData?['gender'] ?? 'Loading...'}"),
                                          SizedBox(height: 10),
                                          Text(
                                              "Contact Details: ${_userData?['contactDetails'] ?? 'Loading...'}"),
                                          SizedBox(height: 10),

                                          ExpansionTile(
                                            title: Text(
                                              'Select type of a room',
                                            ),
                                            children:
                                                roomType.map((roomTypeNeeded) {
                                              return RadioListTile<String>(
                                                title: Text(roomTypeNeeded),
                                                value: roomTypeNeeded,
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
                                            title: Text('Select year of study',
                                                style: TextStyle(
                                                    color: yearofStudy.isEmpty
                                                        ? Colors.red
                                                        : Colors.black)),
                                            children:
                                                yearofStudy.map((fiedOfStudy) {
                                              return RadioListTile<String>(
                                                title: Text(fiedOfStudy),
                                                value: fiedOfStudy,
                                                groupValue: yearOfStudy,
                                                onChanged: (value) {
                                                  setState(() {
                                                    yearOfStudy = value!;
                                                  });
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: selectedRoomsType.isEmpty
                                              ? null
                                              : () => _saveApplicationDetails(),
                                          child: Text('Continue'),
                                          style: ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            foregroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.white),
                                            backgroundColor:
                                                selectedRoomsType.isEmpty
                                                    ? MaterialStatePropertyAll(
                                                        Color.fromARGB(
                                                            255, 211, 211, 211))
                                                    : MaterialStatePropertyAll(
                                                        Colors.blue),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );

                        // Implement the action when the user applies for accommodation

                        print('Apply for accommodation');
                      },
                      child: Text('Apply Accommodation'),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          minimumSize:
                              MaterialStatePropertyAll(Size(buttonWidth, 50))),
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget buildImagePageView(List<String> imageUrls) {
//   return PageView.builder(
//     itemCount: imageUrls.length,
//     itemBuilder: (context, index) {
//       return Center(
//         child: Image.network(
//           imageUrls[index],
//           fit: BoxFit.cover,
//         ),
//       );
//     },
//   );
// }
