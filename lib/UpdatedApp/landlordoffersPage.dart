// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, avoid_unnecessary_containers, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:api_com/UpdatedApp/student_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OffersPage extends StatefulWidget {
  final String accomodationName;
  final String landlordEmail;
  final String password;
  final String distance;
  final int contactDetails;
  final bool isLandlord;
  final String location;
  final XFile? imageFile;
  final Map<String, bool> selectedPaymentsMethods;
  final String contract;
  final String contractPath;

  const OffersPage(
      {super.key,
      required this.selectedPaymentsMethods,
      required this.imageFile,
      required this.location,
      required this.password,
      required this.accomodationName,
      required this.contactDetails,
      required this.landlordEmail,
      required this.distance,
      required this.isLandlord,
      required this.contract,
      required this.contractPath});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final String verificationCode = _generateRandomCode();

  static String _generateRandomCode() {
    final random = Random();
    // Generate a random 6-digit code
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Map<String, bool> selectedOffers = {
    'Uncapped/Unlimited Wifi': false,
    'Study room': false,
    'swimmingPool': false,
    'Free Laundry': false,
    'Sports Ground': false,
    'Gym': false,
    'Power backup': false,
    'Braai Stands': false,

    // Add more amenities as needed
  };
  Map<String, bool> selectedRoomTypes = {
    'Single Rooms': false,
    'Sharing/double Rooms': false,
    "Bachelor's room": false,

    // Add more amenities as needed
  };

  Map<String, bool> selectedUniversity = {
    'Vaal University of Technology': false,
    'University of Johannesburg': false,
    'University of pretoria': false,
    'University of the Witwatersrand': false,
    'Cape Peninsula University of technology': false,
    'University of Cape Town': false,
    'North West University(vaal campus)': false,
    'University of Freestate': false,
    'University of Western Cape': false,
    'University of Kwa-zulu Natal': false,
    'Tshwane University of Technology': false,
    'Stellenbosch University': false,
    'Durban University of Technology': false,
    'North West University': false
  };

  bool usesTransport = true;
  bool isAccomodation = true;

  Future<void> _showAddOffersDialog() async {
    TextEditingController offerController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add other offers',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            controller: offerController,
            decoration: InputDecoration(labelText: "Offer's Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String offers = offerController.text.trim();
                if (offers.isNotEmpty) {
                  setState(() {
                    selectedOffers[offers] = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddUniversityDialog() async {
    TextEditingController universityController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add accomodated university or college',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            controller: universityController,
            decoration: InputDecoration(labelText: 'College/University name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String university = universityController.text.trim();
                if (university.isNotEmpty) {
                  setState(() {
                    selectedUniversity[university] = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _verifyEmail() async {
    TextEditingController verifyEmailController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Account Verification',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            controller: verifyEmailController,
            decoration: InputDecoration(labelText: 'Enter Verification Codes'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String verifyCodes = verifyEmailController.text;

                Navigator.of(context).pop();
                verifyCodes == verificationCode
                    ? _registerUserToFirebase()
                    : showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                'Incorrect Verification',
                              ),
                              content: Text('Incorrect verification codes'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    // Close the dialog

                                    Navigator.of(context).pop();
                                    sendEmail(
                                        widget.landlordEmail, // Student's email
                                        'Verification Code',
                                        'Goodday ${widget.landlordEmail} landlord, \nThis is your verification codes: ${verificationCode} please verify it on the app.');
                                    _verifyEmail();
                                  },
                                  child: Text('Resend'),
                                ),
                              ],
                            ));
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
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

  void _registerUserToFirebase() async {
    List<String> images = pickedImages.map((file) => file.path).toList();
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      // Step 2: Upload the image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().toString()}');
      UploadTask uploadTask =
          storageReference.putFile(File(widget.imageFile!.path));
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      List<String> downloadUrls = await uploadImagesToFirebaseStorage(images);

      // Step 3: Create user account using Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.landlordEmail,
        password: widget.password, // Set your desired password
      );
      // Step 4: Send verification email

      String userId = userCredential.user!.uid;
      // Step 5: Store additional user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'accomodationName': widget.accomodationName,
        'location': widget.location,
        'email': widget.landlordEmail,
        'role': widget.isLandlord,
        'selectedOffers': selectedOffers,
        'selectedUniversity': selectedUniversity,
        'distance': widget.distance,
        'selectedPaymentsMethods': widget.selectedPaymentsMethods,
        'transport availability': usesTransport,
        'contactDetails': widget.contactDetails,
        'accomodationType': isAccomodation,
        'verificationCode': verificationCode,
        'profilePicture': downloadUrl,
        'userId': userId,
        'roomType': selectedRoomTypes,
        'contract': widget.contract,
        'displayedImages': downloadUrls
      });

      // Registration successful, notify the user to check their email for verification
      // You might want to show a success message or navigate to a different screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LoginPage(),
      //   ),
      // );
      Navigator.pushReplacementNamed(context, '/login');

      print(
          'Registration successful. Please check your email for verification.');

      // You can also navigate to a different screen if needed
      // For example, you can navigate to a home screen:
    } catch (e) {
      // Handle registration errors
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Error occured',
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
      // You might want to show an error message to the user
    }
  }

  List<XFile> pickedImages = [];

  final ImagePicker _imagePicker = ImagePicker();
  Future<void> pickImages() async {
    List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        pickedImages = pickedFiles;
      });
    }
  }

  Future<List<String>> uploadImagesToFirebaseStorage(
      List<String> imagePaths) async {
    List<String> downloadUrls = [];

    for (var imagePath in imagePaths) {
      File file = File(imagePath);

      // Step 1: Upload image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      // Step 2: Save download URL to the list
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth =
        MediaQuery.of(context).size.width < 450 ? double.infinity : 400;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: Text('Accomodation Offers(3/3)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: containerWidth,
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
                  //usesTransport

                  ExpansionTile(
                    title: Text('Available Transport'),
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            value: false,
                            groupValue: usesTransport,
                            onChanged: (value) {
                              setState(() {
                                usesTransport = value!;
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
                                usesTransport = value!;
                              });
                            },
                          ),
                          Text('Yes'),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  ExpansionTile(
                    title: Text('Select residence type'),
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            value: false,
                            groupValue: isAccomodation,
                            onChanged: (value) {
                              setState(() {
                                isAccomodation = value!;
                              });
                            },
                          ),
                          Text('Accomodation'),
                        ],
                      ),
                      SizedBox(width: 10),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.blue,
                            value: true,
                            groupValue: isAccomodation,
                            onChanged: (value) {
                              setState(() {
                                isAccomodation = value!;
                              });
                            },
                          ),
                          Text('House'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),

                  ExpansionTile(
                    title: Text('Select Room types'),
                    children: selectedRoomTypes.keys.map((roomTypes) {
                      return CheckboxListTile(
                        title: Text(roomTypes),
                        value: selectedRoomTypes[roomTypes] ?? false,
                        onChanged: (value) {
                          setState(() {
                            selectedRoomTypes[roomTypes] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  ExpansionTile(
                    title: Text('Select accomodation offers'),
                    children: selectedOffers.keys.map((offers) {
                      return CheckboxListTile(
                        title: Text(offers),
                        value: selectedOffers[offers] ?? false,
                        onChanged: (value) {
                          setState(() {
                            selectedOffers[offers] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _showAddOffersDialog();
                      },
                      icon: Icon(Icons.add),
                      label: Text('Others')),
                  SizedBox(
                    height: 5,
                  ),
                  ExpansionTile(
                    title: Text('Select accomodated University/College'),
                    children: selectedUniversity.keys.map((university) {
                      return CheckboxListTile(
                        title: Text(university),
                        value: selectedUniversity[university] ?? false,
                        onChanged: (value) {
                          setState(() {
                            selectedUniversity[university] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _showAddUniversityDialog();
                      },
                      icon: Icon(Icons.add),
                      label: Text('Others')),
                  SizedBox(
                    height: 5,
                  ),

                  Container(
                    height: 50,
                    width: containerWidth,
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            await pickImages(); // Call method to pick images
                          },
                          icon: Icon(Icons.add_photo_alternate_outlined,
                              color: Colors.white),
                          label: Text(
                            'Add Images',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              minimumSize:
                                  MaterialStatePropertyAll(Size(100, 50))),
                        ),
                        for (int index = 0;
                            index < pickedImages.length;
                            index++)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              child: Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Image.file(File(pickedImages[index].path),
                                        height: 45,
                                        width: 50,
                                        fit: BoxFit.cover),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      sendEmail(
                          widget.landlordEmail, // Student's email
                          'Verification Code',
                          'Hi ${widget.accomodationName} landlord, \n this is your verification codes: $verificationCode please comfirm by entering it.');
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Verification Email Sent',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          content: Container(
                            width: 300,
                            height: 280,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    color: Colors.green,
                                    width: 80,
                                    height: 80,
                                    child: Icon(Icons.done,
                                        color: Colors.white, size: 30),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Hi, ${widget.accomodationName} landlord\n A verification email has been sent to ${widget.landlordEmail}. please verify by providing the verification codes',
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();

                                _verifyEmail();
                                print('the user is not a landlord');
                              },
                              child: Text('Verify'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Register Accomodaton'),
                    style: ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        minimumSize:
                            MaterialStatePropertyAll(Size(containerWidth, 50))),
                  ) //21h24b
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
