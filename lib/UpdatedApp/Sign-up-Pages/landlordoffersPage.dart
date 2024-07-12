// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, avoid_unnecessary_containers, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'dart:io';
import 'dart:math';

import 'package:api_com/UpdatedApp/Sign-Page/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encrypt/encrypt.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

// class EncryptionUtil {
//   static final _key = encrypt.Key.fromLength(32); // Generate a 32-byte key
//   static final _iv =  IV.fromLength(16);   // Generate a 16-byte IV

//   static String encrypt(String text) {
//     final encrypter = Encrypter(AES(_key));
//     final encrypted = encrypter.encrypt(text, iv: _iv);
//     return encrypted.base64;
//   }

//   static String decrypt(String encryptedText) {
//     final encrypter = Encrypter(AES(_key));
//     final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
//     return decrypted;
//   }
// }

class OffersPage extends StatefulWidget {
  final String accomodationName;
  final String landlordEmail;
  final String password;
  final String distance;
  final String contactDetails;
  final bool isLandlord;
  final String location;
  final XFile? residenceLogo; 

  final Map<String, bool> selectedPaymentsMethods;
  const OffersPage({
    super.key,
    required this.selectedPaymentsMethods,
    required this.residenceLogo,
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
  String accountHolderName = '';
  String bankName = '';
  String accountNumber = '';
  String branchCode = '';

  Map<String, bool> selectedOffers = {
    'Uncapped/Unlimited Wifi': false,
    'Study room': false,
    'Swimming Pool': false,
    'Free Laundry': false,
    'Sports Ground': false,
    'Gym': false,
    'Power backup': false,
    'Braai Stands': false,
    'Transport to campus': false,
  };
  String _selectedDuration = '';
  List<String> _duration = ['Half Year', 'Full Year'];

  Map<String, bool> selectedRoomTypes = {
    'Single Rooms': false,
    'Sharing/double Rooms': false,
    "Bachelor's room": false,
  };

  Map<String, bool> selectedUniversity = {
    'Vaal University of Technology': false,
    'North West University(Vaal campus)': false,
  };

  // Map<String, bool> selectedMonths = {
  //   'Half Year': false,
  //   'Full Year': false,
  // };
  bool requireDeposit = true;
  bool isAccomodation = true;
  bool isNsfasAccredited = false;
  bool isFull = false;
  TextEditingController depositAmountController = TextEditingController();
  Future<void> _showAddOffersDialog(BuildContext context) async {
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
    if (images.length < 5) {}
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

      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // firebase_storage.Reference reference = firebase_storage
      //     .FirebaseStorage.instance
      //     .ref('Contracts')
      //     .child('${widget.accomodationName}($fileName).pdf');

      // await reference.putFile(widget.pdfContract!);
      // String downloadContractUrl = await reference.getDownloadURL();
      Reference storageReference = FirebaseStorage.instance
          .ref('Residence Logos')
          .child('${widget.accomodationName}(${DateTime.now().toString()})');
      UploadTask uploadTask =
          storageReference.putFile(File(widget.residenceLogo!.path));
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      List<String> downloadUrls = await uploadImagesToFirebaseStorage(images);

      String? userEmail = FirebaseAuth.instance.currentUser!.email;
      String userId = userCredential.user!.uid;

      DateTime now = DateTime.now();
      Timestamp registeredDate = Timestamp.fromDate(now);

      // String encryptedAccountHolderName =
      //     EncryptionUtil.encrypt(accountHolderName);
      // String encryptedBankName = EncryptionUtil.encrypt(bankName);
      // String encryptedAccountNumber = EncryptionUtil.encrypt(accountNumber);
      // String encryptedBranchCode = EncryptionUtil.encrypt(branchCode);
      // requireDeposit == true
      //     ? await FirebaseFirestore.instance
      //         .collection('Landlords')
      //         .doc(userId)
      //         .set({
      //         'accomodationStatus': false,
      //         'accomodationName': widget.accomodationName,
      //         'location': widget.location,
      //         'email': userEmail,
      //         'selectedOffers': selectedOffers,
      //         'selectedUniversity': selectedUniversity,
      //         'distance': widget.distance,
      //         'selectedPaymentsMethods': widget.selectedPaymentsMethods,
      //         'requireDeposit': requireDeposit,
      //         'contactDetails': widget.contactDetails,
      //         'accomodationType': isAccomodation,
      //         'profilePicture': downloadUrl,
      //         'userId': userId,
      //         'roomType': selectedRoomTypes,
      //         'displayedImages': downloadUrls,
      //         'isNsfasAccredited': isNsfasAccredited,
      //         'isFull': false,
      //         'registeredDate': registeredDate,
      //         'Duration': _selectedDuration,
      //         'contract': downloadContractUrl,
      //         'accountHolderName': encryptedAccountHolderName,
      //         'bankName': encryptedBankName,
      //         'accountNumber': encryptedAccountNumber,
      //         'branchCode': encryptedBranchCode,
      //       }):
      
      await FirebaseFirestore.instance.collection('Landlords').doc(userId).set({
        'accomodationStatus': false,
        'accomodationName': widget.accomodationName,
        'location': widget.location,
        'email': userEmail,
        'selectedOffers': selectedOffers,
        'selectedUniversity': selectedUniversity,
        'distance': widget.distance,
        'userRole':'landlord',
        // 'selectedPaymentsMethods': widget.selectedPaymentsMethods,
        'requireDeposit': requireDeposit,
        'contactDetails': widget.contactDetails,
        'accomodationType': isAccomodation,
        'profilePicture': downloadUrl,
        'userId': userId,
        'roomType': selectedRoomTypes,
        'displayedImages': downloadUrls,
        'isNsfasAccredited': isNsfasAccredited,
        'isFull': false,
        'registeredDate': registeredDate,
        'Duration': _selectedDuration,
        // 'contract': downloadContractUrl,
      });

      sendEmail('accomate33@gmail.com', 'Review Accommodation',
          '''Gooday Review officer, <br/>You have a new review request from ${widget.accomodationName}.<br/><br/><p>Best Regards<br/>Yours Accomate</p>''');

      sendEmail(userEmail!, 'Successful Account',
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

      Reference storageReference = FirebaseStorage.instance
          .ref('Residence Images')
          .child(
              '$accomodationName Images/${accomodationName} (${DateTime.now().toString()})');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot storageTaskSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

// void _saveToPDF() async {
//   final pdf = pw.Document();
//   final image = pw.MemoryImage(widget.residenceLogo!);

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.center,
//             children: [
//               pw.Image(image,height: 100,width: 100),

//              pw.Column(children: [
//               pw.SizedBox(height: 20),
//               pw.Text('Account Name: ${bankName}'),
//               pw.Text('Account Number: ${accountNumber}'),
//               pw.Text('Branch Code: ${branchCode}'),
//               pw.Text('Reference: Your Email Address'), ]
//              )
//             ],
//           ),
//         );
//       },
//     ),
//   );

//   final output = await getTemporaryDirectory();
//   final file = File("${output.path}/user_info.pdf");
//   await file.writeAsBytes(await pdf.save());

//   await _uploadToFirebase(file);
// }

// Future<void> _uploadToFirebase(File file) async {
//   final storageRef = FirebaseStorage.instance.ref();
//   final pdfRef = storageRef.child('user_pdfs/${basename(file.path)}');
//   await pdfRef.putFile(file);

//   final pdfUrl = await pdfRef.getDownloadURL();

// }
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
                    SizedBox(
                      height: 5,
                    ),
                    
                    SwitchListTile(
                        title: Text('Is Accomodation'),
                        value: isAccomodation,
                        onChanged: (value) {
                          setState(() {
                            isAccomodation = !value;
                            print(isAccomodation);
                          });
                        }),
                        SizedBox(
                      height: 5,
                    ),
                    SwitchListTile(
                        title: Text('Is Nsfas Accredited'),
                        value: isNsfasAccredited,
                        onChanged: (value) {
                          setState(() {
                            isNsfasAccredited = !value;
                            print(isNsfasAccredited);
                          });
                        }),
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
                          _showAddOffersDialog(context);
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
                    ElevatedButton.icon(
                        onPressed: () {
                          _showAddUniversityDialog();
                        },
                        icon: Icon(Icons.add),
                        label: Text('Others')),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionTile(
                      title: Text('Allowed accomodated Period',
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
                     SwitchListTile(
                        title: Text('Requires Deposit'),
                        value: requireDeposit,
                        onChanged: (value) {
                          setState(() {
                            requireDeposit = !value;
                            print(requireDeposit);
                          });
                        }), if (requireDeposit == true)
                      Column(
                        children: [
                          Text(
                              '*Please note that the student will be signing the contract only their payment will be made in contact.*'),
                          SizedBox(
                            height: 10,
                          ),
                        ],
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
                            '''<p>Hi ${widget.accomodationName} landlord, <br/>This is your verification codes:$verificationCode <br>please comfirm by entering it.<br/>Best Regards<br/>Yours Accomate Team</p>''');
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
