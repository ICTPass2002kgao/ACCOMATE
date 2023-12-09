// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          .collection('users')
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
        'ProofOfRegistration': _userData?['ProofOfRegistration'] ?? '',
        'IdDocument': _userData?['IdDocument'] ?? '',
        'studentId': _userData?['studentId'] ?? '',
        'studentNumber': _userData?['studentNumber'] ?? '',
        'roomType': selectedRoomsType,
        // Add more details as needed
      });
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          child: AlertDialog(
            title: Text(
              'Application Response',
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
                  'Your application was sent successfully. You will get further communication soon.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/studentPage');
                  // await confirmationEmail(
                  //     _userData?['email'] ?? '', // Student's email
                  //     'Application sent successfully',
                  //     'Hi ${_userData?['name']} , \nYour application was sent successfully to ${widget.landlordData['accomodationName']}, You will get further communication soon.');

                  // print('email sent successfully');
                },
                child: Text('Done'),
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
      print('Error sending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.landlordData['accomodationName'],
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Container(
            width: buttonWidth,
            child: Column(
              children: [
                Container(
                  width: 400,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  widget.landlordData['profilePicture'],
                                  width: double.infinity,
                                  height: 300.0,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Location: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                widget.landlordData['location'],
                                maxLines: 1, // Set the maximum number of lines
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Distance to campus: ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                widget.landlordData['distance'],
                              ),
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
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
                                if (widget.landlordData[
                                            'selectedPaymentsMethods']
                                        ?[paymentMethods] ??
                                    false)
                                  ListTile(
                                    title: Text(paymentMethods),
                                  ),
                              SizedBox(height: 5),
                              ListTile(
                                  title: Text(
                                'Nsfas Accredited',
                                style: TextStyle(color: Colors.green),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => Container(
                          height: 400,
                          width: 400,
                          child: AlertDialog(
                            scrollable: true,
                            title: Text('Confirm your details'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  title: Text('Select type of a room'),
                                  children: roomType.map((roomTypeNeeded) {
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
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await _saveApplicationDetails();
                                  await confirmationEmail(
                                      widget.landlordData[
                                          'email'], // Student's email
                                      'Application Received',
                                      'Hi ${widget.landlordData['accomodationName'] ?? ''} landlord, \nYou have new application from student from ${_userData?['university']}.');
                                  // Optionally, you can navigate to the login screen or do other actions
                                },
                                child: Text('Confirm'),
                              ),
                            ],
                          ),
                        ),
                      );
                      // Implement the action when the user applies for accommodation

                      print('Apply for accommodation');
                    },
                    child: Text('Apply Accommodation'),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        minimumSize:
                            MaterialStatePropertyAll(Size(buttonWidth, 50))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
