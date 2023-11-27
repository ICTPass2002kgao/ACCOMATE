// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OffersPage extends StatefulWidget {
  final String accomodationName;
  final String landlordEmail;
  final String password;
  final String distance;
  final int contactDetails;
  final bool isLandlord;
  final String location;
  const OffersPage(
      {super.key,
      required this.location,
      required this.password,
      required this.accomodationName,
      required this.contactDetails,
      required this.landlordEmail,
      required this.distance,
      required this.isLandlord});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();
  late String selectedUniversity;

  List<String> selectedProducts = [];
  List<String> availableProducts = [
    'Wifi',
    'Swimming Pool',
    'Study room',
    'Braai Stands',
  ];
  bool usesTransport = true;

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text('Registered successfully', style: TextStyle(fontSize: 15)),
          content: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.green,
                  child: Center(
                      child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 30,
                  )),
                ),
              ),
              Text(
                  'Please know that you accomodation was registered successfully!'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: Text('Accomodation Offers'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: containerWidth,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.home_work_rounded,
                        size: 150,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Transport Available',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ), //usesTransport
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: false,
                          groupValue: usesTransport,
                          onChanged: (value) {
                            setState(() {
                              usesTransport = false;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.blue,
                          value: true,
                          groupValue: usesTransport,
                          onChanged: (value) {
                            setState(() {
                              usesTransport = true;
                            });
                          },
                        ),
                        Text('Yes'),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    UniversitySelectionTile(
                      onSelected: (String value) {
                        setState(() {});
                        _expansionTileController.collapse();
                      },
                      expansionTileController: _expansionTileController,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          _showAddProductDialog();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add more')),
                    SizedBox(
                      height: 20,
                    ),

                    TextButton(
                      onPressed: () async {
                        _showAddProductDialog();
                        //accomodatonName
                        //email
                        //distance to campus
                        //contact details
                        //location
                        //payment methods
                        //images
                        //transport availability(either true or false)
                        //accomodation offers
                        //
                        //

                        String email = widget.landlordEmail;
                        String password = widget.password;
                        String university = selectedUniversity;
                        String accomodationName = widget.accomodationName;
                        String location = widget.location;
                        // File images =

                        try {
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
                            'accomodationName': accomodationName,
                            'location': location,
                            'email': email,
                            'role': !widget.isLandlord,
                            'university': university,

                            // Add more user data as needed
                          });

                          // Inform the user to check their email for verification
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Verification Email Sent'),
                              content: Text(
                                  'Hi verification email has been sent to $email. Please check your email and verify your account.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Optionally, you can navigate to the login screen or do other actions
                                    if (widget.isLandlord) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LandlordPage(),
                                          ));
                                    }
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          print('Error during user registration: $e');
                          // Handle registration error
                        }
                      },
                      child: Text('Register Accomodaton'),
                    ) //21h24b
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UniversitySelectionTile extends StatefulWidget {
  final void Function(String) onSelected;
  final ExpansionTileController expansionTileController;

  UniversitySelectionTile({
    required this.onSelected,
    required this.expansionTileController,
  });

  @override
  _UniversitySelectionTileState createState() =>
      _UniversitySelectionTileState();
}

class _UniversitySelectionTileState extends State<UniversitySelectionTile> {
  String selectedUniversity = 'hi';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      title: Text(
        'Select Accomodation offers ',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      onExpansionChanged: (bool isExpanded) {
        if (isExpanded) {
          widget.expansionTileController.collapse();
        }
      },
      children: <Widget>[
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Unlimited wifi/Uncapped wifi'),
          tileColor: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Study room'),
          tileColor: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Free Laundry'),
          tileColor: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Power backup'),
          tileColor: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Gym'),
          tileColor: Colors.white,
        ),
        SizedBox(
          height: 5,
        ),
        CheckboxListTile(
          activeColor: Colors.blue,
          value: true,
          onChanged: (value) {
            setState(() {});
          },
          title: Text('Sports ground'),
          tileColor: Colors.white,
        ),

        // Add more universities as needed
      ],
    );
  }

  void selectUniversity(String university) {
    setState(() {
      selectedUniversity = university;
    });
    widget.onSelected(university);
  }
}
