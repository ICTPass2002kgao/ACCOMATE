// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, sort_child_properties_last, unnecessary_brace_in_string_interps
// onPressed: () async {
//   // Implement registration logic here using FirebaseAuth
//   // You need to validate inputs and handle registration accordingly
//   // For example:
//   try {
//     UserCredential userCredential =
//         await _auth.createUserWithEmailAndPassword(
//       email: emailController.text,
//       password: passwordController.text,
//     );
//     if (!widget.isLandlord) {
//       // If registering as a student, show AlertDialog and navigate to the next page
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Account Created Successfully'),
//             content: Text(
//                 'You can now continue with additional student information.'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .pop(); // Close the AlertDialog
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               StudentRegistration2(
//                                 userType: widget.isLandlord
//                                     ? 'landlord'
//                                     : 'student',
//                                 email: emailController.text,
//                                 password:
//                                     passwordController.text,
//                                 name: nameController.text,
//                                 surname: surnameController.text,
//                               )),
//                     );
//                   },
//                   child: Text(
//                     'Continue',
//                   )),
//             ],
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Account Created Successfully'),
//             content: Text(
//                 'You can now continue with additional accomodation information.'),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     // Close the AlertDialog

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => LandlordPage()),
//                     );
//                   },
//                   child: Text(
//                     'Continue',
//                   )),
//             ],
//           );
//         },
//       );
//       // If registering as a landlord, no need for AlertDialog, just navigate to the next page
//     }

//     print('User registered: ${userCredential.user?.email}');
//   } catch (e) {
//     _showLogoutConfirmationDialog(context, e);
//   }
// },
// TextField(
//   controller: nameController,
//   decoration: InputDecoration(
//       focusColor: Colors.blue,
//       fillColor: Color.fromARGB(255, 230, 230, 230),
//       filled: true,
//       prefixIcon: Icon(
//         Icons.person,
//         color: Colors.blue,
//       ),
//       hintText: 'Name'),
// ),
// SizedBox(height: 16),
// TextField(
//   controller: surnameController,
//   decoration: InputDecoration(
//       focusColor: Colors.blue,
//       fillColor: Color.fromARGB(255, 230, 230, 230),
//       filled: true,
//       prefixIcon: Icon(
//         Icons.person,
//         color: Colors.blue,
//       ),
//       hintText: 'Surname'),
// ),
import 'dart:math';

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/UpdatedApp/landlordFurntherRegistration.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentOrLandlord extends StatefulWidget {
  const StudentOrLandlord({super.key, required this.isLandlord});
  final bool isLandlord;

  @override
  State<StudentOrLandlord> createState() => _StudentOrLandlordState();
}

class _StudentOrLandlordState extends State<StudentOrLandlord> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactDetails = TextEditingController();
  final TextEditingController accomodationName = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();
  late String selectedUniversity;

  @override
  void initState() {
    super.initState();
    selectedUniversity = 'Vaal University of Technology'; // Default value
  }

  String verificationCode = _generateRandomCode();
  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context, val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Invalid Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Container(
                        width: 190,
                        child: Text(
                          '${val}',
                        )),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Retry!!'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Default value

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
            widget.isLandlord
                ? 'Landlord Registration'
                : 'Student Registration',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: buttonWidth,
            child: SingleChildScrollView(
              child: !widget.isLandlord //This is for student
                  ? Center(
                      child: Container(
                        width: buttonWidth,
                        child: Column(children: [
                          Icon(
                            Icons.person_add,
                            size: 150,
                            color: Colors.blue,
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                hintText: 'Name'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: surnameController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                hintText: 'Surname'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue,
                                ),
                                hintText: 'example.@gmail.com'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.blue,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                                hintText: 'Password'),
                            obscureText: true,
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: contactDetails,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                hintText: 'Contact details'),
                            obscureText: true,
                          ),
                          SizedBox(height: 5),
                          UniversitySelectionTile(
                            initialValue: selectedUniversity,
                            onSelected: (String value) {
                              setState(() {
                                selectedUniversity = value;
                              });
                              _expansionTileController.collapse();
                            },
                            expansionTileController: _expansionTileController,
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              String email = emailController.text;
                              String password = passwordController.text;
                              String university = selectedUniversity;
                              String name = nameController.text;
                              String surname = surnameController.text;

                              try {
                                // Create a user in Firebase Auth
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                // Get the user ID
                                String userId = userCredential.user!.uid;

                                // Send email verification
                                await userCredential.user!
                                    .sendEmailVerification();

                                // Save user data to Firestore
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .set({
                                  'name': name,
                                  'surname': surname,
                                  'email': email,
                                  'role': !widget.isLandlord,
                                  'university': university,

                                  'verificationCode': verificationCode
                                  // Add more user data as needed
                                });

                                // Inform the user to check their email for verification
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Verification Email Sent'),
                                    content: Text(
                                        'Hi $name, \nA verification email has been sent to $email. Please check your email and verify your account.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Optionally, you can navigate to the login screen or do other actions
                                          if (!widget.isLandlord) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentPage(),
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
                            child: Text(
                              widget.isLandlord ? 'Create account' : 'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize: MaterialStatePropertyAll(
                                    Size(buttonWidth, 50))),
                          ),
                        ]),
                      ),
                    )

                  //User registering as a landlord
                  : Center(
                      child: Container(
                        width: buttonWidth,
                        child: Column(children: [
                          Icon(
                            Icons.maps_home_work_outlined,
                            size: 150,
                            color: Colors.blue,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.blue,
                                ),
                                hintText: 'Email'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.blue,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue,
                                ),
                                hintText: 'Password'),
                            obscureText: true,
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: accomodationName,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.maps_home_work_outlined,
                                  color: Colors.blue,
                                ),
                                hintText: 'Accomodation Name'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: distanceController,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.location_pin,
                                  color: Colors.blue,
                                ),
                                hintText: 'Distance to Campus e.g 4km'),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: contactDetails,
                            decoration: InputDecoration(
                                focusColor: Colors.blue,
                                fillColor: Color.fromARGB(255, 230, 230, 230),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.phone_enabled_sharp,
                                  color: Colors.blue,
                                ),
                                hintText: 'Contact details'),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            LandlordFurtherRegistration(
                                              password: passwordController.text,
                                              contactDetails:
                                                  contactDetails.hashCode,
                                              isLandlord: widget.isLandlord,
                                              distance: distanceController.text,
                                              accomodationName:
                                                  accomodationName.text,
                                              landlordEmail:
                                                  emailController.text,
                                            ))));
                                print(
                                  widget.isLandlord,
                                );
                              });
                            },
                            child: Text(
                              widget.isLandlord ? 'Create account' : 'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                minimumSize: MaterialStatePropertyAll(
                                    Size(buttonWidth, 50))),
                          )
                        ]),
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
  final String initialValue;
  final void Function(String) onSelected;
  final ExpansionTileController expansionTileController;

  UniversitySelectionTile({
    required this.initialValue,
    required this.onSelected,
    required this.expansionTileController,
  });

  @override
  _UniversitySelectionTileState createState() =>
      _UniversitySelectionTileState();
}

class _UniversitySelectionTileState extends State<UniversitySelectionTile> {
  String selectedUniversity = '';

  @override
  void initState() {
    super.initState();
    selectedUniversity = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Color.fromARGB(255, 230, 230, 230),
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      title: Text(
        selectedUniversity.isNotEmpty
            ? selectedUniversity
            : 'Select University',
      ),
      onExpansionChanged: (bool isExpanded) {
        if (isExpanded) {
          widget.expansionTileController.collapse();
        }
      },
      children: <Widget>[
        ListTile(
          title: Text('Vaal University of Technology'),
          onTap: () => selectUniversity('Vaal University of Technology'),
        ),
        ListTile(
          title: Text('University of Johannesburg'),
          onTap: () => selectUniversity('University of Johannesburg'),
        ),
        ListTile(
          title: Text('University of pretoria'),
          onTap: () => selectUniversity('University of pretoria'),
        ),
        ListTile(
          title: Text('University of the Witwatersrand'),
          onTap: () => selectUniversity('University of the Witwatersrand'),
        ),
        ListTile(
          title: Text('Cape Peninsula University of technology'),
          onTap: () =>
              selectUniversity('Cape Peninsula University of technology'),
        ),
        ListTile(
          title: Text('University of Cape Town'),
          onTap: () => selectUniversity('University of Cape Town'),
        ),
        ListTile(
          title: Text('University of Limpopo'),
          onTap: () => selectUniversity('University of Limpopo'),
        ),
        ListTile(
          title: Text('University of Freestate'),
          onTap: () => selectUniversity('University of Freestate'),
        ),
        ListTile(
          title: Text('University of Western Cape'),
          onTap: () => selectUniversity('University of Western Cape'),
        ),
        ListTile(
          title: Text('North West University'),
          onTap: () => selectUniversity('North West University'),
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
