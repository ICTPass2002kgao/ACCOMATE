// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/LandlordPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  final List<XFile>? selectedWepAppImages;
  final List<XFile> bringSelectedImages;
  final Map<String, bool> selectedPaymentsMethods;

  // final bool paymentMethods;

  const OffersPage(
      {super.key,
      required this.selectedWepAppImages,
      required this.selectedPaymentsMethods,
      required this.bringSelectedImages,
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
  // List<String> selectedProducts = [];
  // List<String> availableProducts = [
  //   'Wifi',
  //   'Swimming Pool',
  //   'Study room',
  //   'Braai Stands',
  // ];
  bool usesTransport = true;
  bool isAccomodation = true;

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Registration response',
          ),
          content: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue[800],
                  child: Center(
                      child: Icon(
                    Icons.info_sharp,
                    color: Colors.white,
                    size: 30,
                  )),
                ),
              ),
              Text(
                  'Please know that your accomodation will\n be refered to as pending until the registration\n fee is paid!'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await registerUserInFirestore(
                  isAccomodation: isAccomodation,
                  email: widget.landlordEmail,
                  password: widget.password,
                  accomodationName: widget.accomodationName,
                  location: widget.location,
                  images: widget.bringSelectedImages,
                  isLandlord: widget.isLandlord,
                  distance: widget.distance,
                  contactDetails: widget.contactDetails,
                  selectedOffers: selectedOffers,
                  selectedUniversity: selectedUniversity,
                  selectedPaymentsMethods: widget.selectedPaymentsMethods,
                  usesTransport: usesTransport,
                );
                // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

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

  Future<void> _showVerificationCodeDialog() async {
    TextEditingController verificationCodeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Please verify you account',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            controller: verificationCodeController,
            decoration: InputDecoration(labelText: 'Provide codes'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                String verifiedCode = verificationCodeController.text;
                verifiedCode == verificationCode
                    ? widget.isLandlord
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LandlordPage(),
                            ),
                          )
                        : print('the user is not a landlord')
                    : print('incorrect code');
              },
              child: Text('Verify'),
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

  Future<String> uploadImageToFirestoreStorage(File imageFile) async {
    try {
      // Get a reference to the Firebase Storage bucket
      var storage = FirebaseStorage.instance;

      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the location you want to upload the image
      var reference = storage.ref().child('images/$fileName.jpg');

      // Upload the image to Firebase Storage
      await reference.putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadURL = await reference.getDownloadURL();

      return downloadURL;
    } catch (error) {
      print('Error uploading image to Firestore Storage: $error');
      throw error;
    }
  }

  // Future<void> registerUserInFirestore(
  //     {}) async {
  //   try {

  //     // Create a document in the 'users' collection

  //     await FirebaseFirestore.instance.collection('users').add({
  //       'accomodationName': accomodationName,
  //       'location': location,
  //       'email': email,
  //       'role': !isLandlord,
  //       'selectedOffers': selectedOffers,
  //       'selectedUniversity': selectedUniversity,
  //       'selectedPaymentsMethods': selectedPaymentsMethods,
  //       'transport availabbility': usesTransport,
  //       'verificationCode': verificationCode,
  //     });
  //     // Send email verification

  //     // Upload each image and add its URL to the 'urls' subcollection
  //     for (XFile image in images) {
  //       String imageUrl = await uploadImageToFirestoreStorage(File(image.path));

  //       await documentReference.collection('urls').add({
  //         'url': imageUrl,
  //       });
  //     }

  //     // Inform the user to check their email for verification
  //   } catch (error) {
  //     print('Error during user registration: $error');
  //     // Handle registration error
  //   }
  // }

  Future<void> registerUserInFirestore(
      // ... existing parameters ...
      {required String email,
      required String password,
      required String accomodationName,
      required String location,
      required List<XFile> images,
      required bool isLandlord,
      required String distance,
      required int contactDetails,
      required Map<String, bool> selectedOffers,
      required Map<String, bool> selectedUniversity,
      required Map<String, bool> selectedPaymentsMethods,
      required bool usesTransport,
      required bool isAccomodation}) async {
    try {
      // Create a user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Verification Email Sent'),
          content: Text(
            'Hi, $accomodationName landlord\n A verification email has been \nsent to $email. Please check your email and verify your account.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                widget.isLandlord
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LandlordPage(),
                        ),
                      )
                    : print('the user is not a landlord');
              },
              child: Text('Verify'),
            ),
          ],
        ),
      );

      // Create a document in the 'users' collection
      DocumentReference userDocRef =
          await FirebaseFirestore.instance.collection('users').add({
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
        'verificationCode': verificationCode,
        'profilePicture': '', // Placeholder for the profile picture URL
      });

      // Get the ID of the added document
      String userId = userDocRef.id;

      // ... existing code ...

      // Upload each image and add its URL to the 'urls' subcollection
      for (int i = 0; i < images.length; i++) {
        String imageUrl =
            await uploadImageToFirestoreStorage(File(images[i].path));

        // Update the 'profilePicture' field with the URL of the first image
        if (i == 0) {
          await userDocRef.update({
            'profilePicture': imageUrl,
          });
        }
        // Create a document in the 'images' collection
        DocumentReference documentReference =
            await FirebaseFirestore.instance.collection('images').add({
          'timestamp': FieldValue.serverTimestamp(),
          'userId': userCredential.user!.uid,
        });

        // Add the image URL to the 'urls' subcollection
        await documentReference.collection('urls').add({
          'url': imageUrl,
        });
      }

      // ... existing code ...
    } catch (error) {
      print('Error during user registration: $error');
      // Handle registration error
    }
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
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Residence Type:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ), //usesTransport
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
                    SizedBox(
                      height: 5,
                    ),

                    // OffersSelectionTile(
                    //   onSelected: (String value) {
                    //     setState(() {});
                    //     _expansionTileController.collapse();
                    //   },
                    //   expansionTileController: _expansionTileController,
                    // ),
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
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        _showAddProductDialog();
                      },
                      child: Text('Register Accomodaton'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.blue),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          minimumSize: MaterialStatePropertyAll(
                              Size(containerWidth, 50))),
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
