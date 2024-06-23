// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, avoid_unnecessary_containers, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class OffersPage extends StatefulWidget {
  final String accomodationName;
  final String landlordEmail;
  final String password;
  final String distance;
  final String contactDetails;
  final bool isLandlord;
  final String location;
  final XFile? imageFile;

  final Map<String, bool> selectedPaymentsMethods;
  const OffersPage({
    super.key,
    required this.selectedPaymentsMethods,
    required this.imageFile,
    required this.location,
    required this.password,
    required this.accomodationName,
    required this.contactDetails,
    required this.landlordEmail,
    required this.distance,
    required this.isLandlord,
  });

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  Map<String, bool> selectedOffers = {
    'Uncapped/Unlimited Wifi': false,
    'Study room': false,
    'Swimming Pool': false,
    'Free Laundry': false,
    'Sports Ground': false,
    'Gym': false,
    'Power backup': false,
    'Braai Stands': false,
  };
  String _selectedDuration = '';
  List<String> _duration = ['Half Year', 'Full Year', 'Both'];

  Map<String, bool> selectedRoomTypes = {
    'Single Rooms': false,
    'Sharing/double Rooms': false,
    "Bachelor's room": false,
  };

  Map<String, bool> selectedUniversity = {
    'Vaal University of Technology': false,
    'North West University(Vaal campus)': false,
  };

  Map<String, bool> selectedMonths = {
    'Half Year': false,
    'Full Year': false,
  };
  bool usesTransport = true;
  bool isAccomodation = true;
  bool isNsfasAccredited = false;
  bool isFull = false;

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
          backgroundColor: Colors.blue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(
            'Account Verification',
            style: TextStyle(fontSize: 15),
          ),
          content: TextField(
            keyboardType: TextInputType.number,
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
            OutlinedButton(
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
                                    Navigator.of(context).pop();
                                    sendEmail(
                                        widget.landlordEmail,
                                        'Verification Code',
                                        'Gooday ${widget.accomodationName} landlord, \nThis is your verification codes: ${verificationCode} please verify it on the app.');
                                    _verifyEmail();
                                  },
                                  child: Text('Resend'),
                                ),
                              ],
                            ));
              },
              child: Text('Verify'),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  static String _generateRandomCode() {
    final random = Random();
    return '${random.nextInt(999999).toString().padLeft(6, '0')}';
  }

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
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

  final String verificationCode = _generateRandomCode();
  bool isLandlord = true;
  bool status = false;

  List<String> durationOptions = ['Half Year', 'Full Year'];

  void _registerUserToFirebase() async {
    List<String> images = pickedImages.map((file) => file.path).toList();
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

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.landlordEmail,
        password: widget.password,
      );

      Reference storageReference = FirebaseStorage.instance.ref().child(
          'Accommodation Images/${widget.accomodationName}(${DateTime.now().toString()})');
      UploadTask uploadTask =
          storageReference.putFile(File(widget.imageFile!.path));
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      List<String> downloadUrls = await uploadImagesToFirebaseStorage(images);

      String? userEmail = FirebaseAuth.instance.currentUser!.email;
      String userId = userCredential.user!.uid;

      DateTime now = DateTime.now();
      Timestamp registeredDate = Timestamp.fromDate(now);
      await FirebaseFirestore.instance.collection('Landlords').doc(userId).set({
        'accomodationStatus': false,
        'accomodationName': widget.accomodationName,
        'location': widget.location,
        'email': userEmail,
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
        'displayedImages': downloadUrls,
        'isNsfasAccredited': isNsfasAccredited,
        'isFull': false,
        'registeredDate': registeredDate,
        'Duration': _selectedDuration,
      });

      sendEmail('accomate33@gmail.com', 'Review Accommodation',
          'Gooday Review officer, \nYou have a new review request from ${widget.accomodationName}.\n\n\n\n\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

      sendEmail(widget.landlordEmail, 'Successful Account',
          '''<p>Good day ${widget.accomodationName} landlord,</p>
          
          <p>Your account has been registered successfully. Please note that your accommodation will undergo a review for verification. You will receive further communication soon.</p>
          
           
          <p>Best Regards,<br/>Yours Accomate</p>''');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.blue[100],
                title: Text(
                  'Successful Registration',
                  style: TextStyle(fontSize: 15),
                ),
                content: Text(
                    'The account was registered successfully. You can now proceed to login.'),
                actions: <Widget>[
                  OutlinedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LoginPage(
                                  guest: false,
                                      userRole: 'Landlord',
                                    ))));
                      },
                      child: Text('Proceed'),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      )),
                ],
              ));

      print(
          'Registration successful. Please check your email for verification.');
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Error occurred',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text('Retry'),
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  )),
            ],
          ),
        ),
      );
    }
  }

  List<XFile> pickedImages = [];

  final ImagePicker _imagePicker = ImagePicker();
  Future<void> pickImages() async {
    List<XFile>? pickedFiles = await _imagePicker.pickMultiImage(
      limit: 5,
    );

    setState(() {
      pickedImages = pickedFiles;
    });
  }

  String duration = '';
  Future<List<String>> uploadImagesToFirebaseStorage(
      List<String> imagePaths) async {
    String accomodationName = widget.accomodationName;
    List<String> downloadUrls = [];

    for (var imagePath in imagePaths) {
      File file = File(imagePath);

      Reference storageReference = FirebaseStorage.instance.ref().child(
          '$accomodationName profile_images/${accomodationName} image(${DateTime.now().toString()})');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

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
      body: Container(
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                width: containerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(105),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color.fromARGB(255, 187, 222, 251),
                                  Colors.blue,
                                  const Color.fromARGB(255, 15, 76, 167)
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  'assets/icon.jpg',
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        'Available Transport',
                      ),
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
                      title: Text('Select Accrediation state'),
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: false,
                              groupValue: isNsfasAccredited,
                              onChanged: (value) {
                                setState(() {
                                  isNsfasAccredited = value!;
                                });
                              },
                            ),
                            Text('Nsfas Accredited'),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.blue,
                              value: true,
                              groupValue: isNsfasAccredited,
                              onChanged: (value) {
                                setState(() {
                                  isNsfasAccredited = value!;
                                });
                              },
                            ),
                            Text('Not Nsfas Accredited'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionTile(
                      title: Text('Select Room types',
                          style: TextStyle(
                              color: selectedRoomTypes.isEmpty
                                  ? Colors.red
                                  : Colors.black)),
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
                      title: Text('Select accomodation offers',
                          style: TextStyle(
                              color: selectedOffers.isEmpty
                                  ? Colors.red
                                  : Colors.black)),
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
                      title: Text('Select accomodated University',
                          style: TextStyle(
                              color: selectedUniversity.isEmpty
                                  ? Colors.red
                                  : Colors.black)),
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
                    ExpansionTile(
                      title: Text('Accomodated Months',
                          style: TextStyle(color: Colors.black)),
                      children: _duration.map((parDuration) {
                        return RadioListTile<String>(
                          title: Text(parDuration),
                          value: parDuration,
                          groupValue: _selectedDuration,
                          onChanged: (value) {
                            setState(() {
                              _selectedDuration = value!;
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
                      height: 55,
                      width: containerWidth,
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              await pickImages();
                            },
                            icon: Icon(Icons.add_photo_alternate_outlined,
                                color: Colors.white),
                            label: Text(
                              'Add Images',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blue),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                minimumSize:
                                    WidgetStatePropertyAll(Size(100, 50))),
                          ),
                          for (int index = 0;
                              index < pickedImages.length;
                              index++)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    color: Color.fromARGB(255, 233, 231, 231),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            child: Image.file(
                                                File(pickedImages[index].path),
                                                height: 45,
                                                width: 50,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        sendEmail(widget.landlordEmail, 'Verification Code',
                            '''Hi ${widget.accomodationName} landlord, \nThis is your verification codes:<a href="">$verificationCode</a> <br>please comfirm by entering it.\n\n\n\n\nBest Regards\nYours Accomate''');
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.blue[100],
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
                                          color: Colors.white, size: 35),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Hi, ${widget.accomodationName} landlord\n A verification email has been sent to ${widget.landlordEmail}.Please verify by Clicking on the link provided',
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              OutlinedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    _verifyEmail();
                                  },
                                  child: Text('Verify'),
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue),
                                  )),
                            ],
                          ),
                        );
                      },
                      child: Text('Create account'),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          minimumSize:
                              WidgetStatePropertyAll(Size(containerWidth, 50))),
                    )
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
