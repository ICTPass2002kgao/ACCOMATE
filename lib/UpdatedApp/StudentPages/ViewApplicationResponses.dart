// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewApplicationResponses extends StatefulWidget {
  final Map<String, dynamic> studentApplicationData;
  const ViewApplicationResponses(
      {super.key, required this.studentApplicationData});

  @override
  State<ViewApplicationResponses> createState() =>
      _ViewApplicationResponsesState();
}

class _ViewApplicationResponsesState extends State<ViewApplicationResponses> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> _studentApplications = [];

  String _pdfDownloadSignedContractURL = '';
  String _pdfSignedContractPath = '';
  bool isFileChosen = false;
  File? pdfSignedContractFile;
  Future<void> _pickSignedContract(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        pdfSignedContractFile = File(result.files.single.path!);
        setState(() {
          _pdfSignedContractPath = pdfSignedContractFile!.path;
          isFileChosen = true; // Set the flag to true when a file is chosen
        });
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString(), context);
    }
  }

  Future<String?> _uploadSignedContact(
      File pdfFile, BuildContext context) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('signedContracts')
          .child('$fileName.pdf');

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return null;
    }
  }

  void _showErrorDialog(String errorMessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          'Error Occurred',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }

  late User _user;

  Map<String, dynamic>? _userData;
  // Make _userData nullable
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
    _loadStudentApplications();
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

  Future<void> _loadStudentApplications() async {
    try {
      // Assuming there is a specific landlord ID (replace 'your_landlord_id' with the actual ID)
      String landlordUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('applications')
          .get();

      List<Map<String, dynamic>> studentApplications = [];

      for (QueryDocumentSnapshot documentSnapshot
          in applicationsSnapshot.docs) {
        Map<String, dynamic> applicationData =
            documentSnapshot.data() as Map<String, dynamic>;
        studentApplications.add(applicationData);
      }

      setState(() {
        _studentApplications = studentApplications;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
  }

  Future<void> _sentSignedContract(BuildContext context) async {
    try {
      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Extract necessary data
      String landlordUserId = widget.studentApplicationData['userId'] ?? '';
      String studentUserId = _userData?['userId'] ?? '';
      String? downloadURL =
          await _uploadSignedContact(pdfSignedContractFile!, context);

      if (downloadURL != null) {
        setState(() {
          _pdfDownloadSignedContractURL = downloadURL;
        });
      }
      Map<String, dynamic> userDataMap = {
        'signedContract': _pdfDownloadSignedContractURL,
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
        'roomType': _userData?['roomType'] ?? '',
        'fieldOfStudy': _userData?['fieldOfStudy'] ?? '',
        // Add more details as needed
      };

      // Create a document reference for the landlord's collectio
      DocumentReference landlordRef = FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registeredStudents')
          .doc(studentUserId);
      await landlordRef.set(userDataMap);

      // Create a map with user details and set it in the document

      // Send an email to the student
      await sendEmail(
        _userData?['email'] ?? '', // Student's email
        'Contract signed',
        'Hi ${widget.studentApplicationData['accomodationName'] ?? ''}, landlord \nyou have a new signed contract from  ${_userData?['name'] ?? ''}\n\n\n\nBest Regards\nYours Accomate',
      );

      print('Email sent successfully');

      // Show a success dialog
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 200,
          width: 250,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              'Successful Response',
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
                      child: Icon(Icons.done, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Your contract has been sent successfully to ${widget.studentApplicationData['accomodationName'] ?? ''} landlord',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/studentPage');
                  await sendEmail(
                    _userData?['email'] ?? '', // Student's email
                    'Response sent successfully',
                    'Hi ${_userData?['name'] ?? ''} , \nYour contract was sent successfully to ${widget.studentApplicationData['accomodationName']}\n\n\n\nBest Regards\nYours Accomate',
                  );

                  print('Email sent successfully');
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // Handle errors
      print(e.toString());
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
      );
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
    } catch (e) {}
  }

  bool isLoading = true;
  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.studentApplicationData['accomodationName'] ?? 'n/a'}'),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(border: TableBorder.all(), children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                  child: Text('Residence Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ),
                            TableCell(
                              child: Center(
                                  child: Text('Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(widget.studentApplicationData[
                                        'accomodationName'] ??
                                    'N/A'),
                              )),
                            ),
                            TableCell(
                              child: Center(
                                  child: Text(
                                      // ignore: unrelated_type_equality_checks
                                      widget.studentApplicationData['status'] ==
                                              true
                                          ? 'Accepted'
                                          : 'Rejected',
                                      style: TextStyle(
                                          color: widget.studentApplicationData[
                                                      'status'] ==
                                                  true
                                              ? Colors.green
                                              : Colors.red))),
                            ),
                          ],
                        )
                      ]),
                      widget.studentApplicationData['status'] == false
                          ? Column(
                              children: [
                                Container(
                                    width: buttonWidth,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Hi, ${_userData?['name'] ?? 'N/A'} Your Application have been rejected due to the following reasons ${widget.studentApplicationData['landlordMessage']}',
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/studentPage');
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  ),
                                  label: Text('Back'),
                                  style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.red[300]),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(double.infinity, 50))),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                    width: buttonWidth,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Hi, ${_userData?['name'] ?? ''} Your application have been accepted you can now register by downloading the contract on the received email and sign all the required field. \n\n\n\nRegistration Instructions: ${widget.studentApplicationData['landlordMessage']}',
                                          maxLines: 100,
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                if (_userData?['registered'] == false)
                                  Column(
                                    children: [
                                      Container(
                                        width: buttonWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                _pickSignedContract(context);
                                              },
                                              style: ButtonStyle(
                                                  shape:
                                                      MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                  foregroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.white),
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Colors.blue),
                                                  minimumSize:
                                                      MaterialStatePropertyAll(
                                                          Size(60, 50))),
                                              child: Text('Choose file'),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                readOnly:
                                                    true, // Prevent manual editing
                                                controller: TextEditingController(
                                                    text: basename(
                                                        _pdfSignedContractPath)),
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                      OutlineInputBorder(),
                                                  focusColor: Color.fromARGB(
                                                      255, 230, 230, 230),
                                                  fillColor: Color.fromARGB(
                                                      255, 230, 230, 230),
                                                  filled: true,
                                                  hintText:
                                                      'Upload your signed contract',
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          await _sentSignedContract(context);
                                        },
                                        icon: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        ),
                                        label: Text('Register'),
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
                                                MaterialStatePropertyAll(
                                                    Colors.blue),
                                            minimumSize:
                                                MaterialStatePropertyAll(
                                                    Size(double.infinity, 50))),
                                      )
                                    ],
                                  ),
                              ],
                            )
                    ],
                  ),
                ),
              ));
  }

  Future<void> downloadFile(BuildContext context, String downloadUrl) async {
    try {
      // Check for storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Downloading...', style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ));
      // Get the application documents directory
      // Get the Downloads directory
      Directory? downloadsDirectory = await getDownloadsDirectory();

      if (downloadsDirectory != null) {
        String savePath =
            "${downloadsDirectory.path}/${widget.studentApplicationData['accomodationName']}'s Contract.pdf";

        // Create a reference to the Firebase Storage file
        Reference storageReference =
            FirebaseStorage.instance.ref().child(downloadUrl);

        // Download the file to the device
        await Dio().download(storageReference.fullPath, savePath);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('File downloaded successfully!',
              style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
