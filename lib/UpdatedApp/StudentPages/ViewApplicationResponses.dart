// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

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

  String _pdfDownloadSignedContractURL = '';
  String _pdfSignedContractPath = '';
  bool isFileChosen = false;

  Future<void> _pickSignedContract() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File pdfFile = File(result.files.single.path!);
        setState(() {
          _pdfSignedContractPath = pdfFile.path;
          isFileChosen = true; // Set the flag to true when a file is chosen
        });

        String? downloadURL = await _uploadSignedContact(pdfFile);

        if (downloadURL != null) {
          setState(() {
            _pdfDownloadSignedContractURL = downloadURL;
          });
        }
      } else {
        // No file chosen
        setState(() {
          isFileChosen = false;
        });
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<String?> _uploadSignedContact(File pdfFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref('signedContracts')
          .child('$fileName.pdf');

      await reference.putFile(pdfFile);

      return await reference.getDownloadURL();
    } catch (e) {
      _showErrorDialog(e.toString());
      return null;
    }
  }

  void _showErrorDialog(String errorMessage) {
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
  String selectedRoomsType = '';

  Map<String, dynamic>? _userData;
  // Make _userData nullable
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
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

  Future<void> downloadFile(String url) async {
    final String downloadUrl = url;

    try {
      // Make an HTTP GET request to download the file
      final http.Response response = await http.get(Uri.parse(downloadUrl));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Convert the response body to a Uint8List
        final Uint8List bytes = response.bodyBytes;

        // Get the local storage directory
        final Directory appDocDir = Directory('Downloads');
        final String appDocPath = appDocDir.path;

        // Create a File instance with the local path and file name
        final File file = File('$appDocPath/contract.pdf');

        // Write the bytes to the file
        await file.writeAsBytes(bytes);

        print('File downloaded and saved locally: ${file.path}');
      } else {
        // Handle errors if the request was not successful
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (error) {
      print('Error downloading file: $error');
    }
  }

  Future<void> _sentSignedContract() async {
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

      String landlordUserId = widget.studentApplicationData['userId'] ?? '';
      String studentUserId = _userData?['userId'] ?? '';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .collection('registration')
          .doc(studentUserId)
          .set({
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
      });
      await sendEmail(
          _userData?['email'] ?? '', // Student's email
          'Contract signed',
          'Hi ${widget.studentApplicationData['accomodationName']},landlord \nyou have a new signed contract from  ${_userData?['name'] ?? ''}');

      print('email sent successfully');

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
                    'Your contract have been sent successfully to ${widget.studentApplicationData['accomodationName']} landlord',
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
                      'Hi ${_userData?['name']} , \nYour contract was sent successfully to ${widget.studentApplicationData['accomodationName']}');

                  print('email sent successfully');
                },
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 50))),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
            title: Text(
              'Successful Response',
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
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
            title: Text(
              'Successful Response',
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
    }
  }

  bool isLoading = true;
  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 4));

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
          title: Text('${widget.studentApplicationData['accomodationName']}'),
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
                            if (widget.studentApplicationData['status'] == true)
                              TableCell(
                                child: Center(
                                    child: Text('Contract',
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
                                  child: Text(widget.studentApplicationData[
                                          'accomodationName'] ??
                                      'Kgaogelo')),
                            ),
                            if (widget.studentApplicationData['status'] == true)
                              TableCell(
                                child: Center(
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          final String downloadUrl =
                                              widget.studentApplicationData[
                                                      'contract'] ??
                                                  '';

                                          downloadFile(downloadUrl);
                                        },
                                        icon: Icon(Icons.download,
                                            color: Colors.blue),
                                        label: Text(''))),
                              ),
                            TableCell(
                              child: Center(
                                  child: Text(
                                      // ignore: unrelated_type_equality_checks
                                      widget.studentApplicationData['status'] ==
                                              true
                                          ? 'Accepted'
                                          : 'Rejected')),
                            ),
                          ],
                        )
                      ]),
                      widget.studentApplicationData['status'] == true
                          ? Column(
                              children: [
                                Container(
                                    width: buttonWidth,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Hi, ${_userData?['name'] ?? ''} Your Application have been rejected due to the following reasons ${widget.studentApplicationData['landlordMessage']}',
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
                                        Text(
                                          'Hi, ${_userData?['name'] ?? ''} Your application have been accepted you can now register. \n${widget.studentApplicationData['landlordMessage']}',
                                          maxLines: 100,
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: buttonWidth,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _pickSignedContract();
                                        },
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
                                              text: _pdfSignedContractPath),
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
                                  onPressed: () {
                                    _sentSignedContract();
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
                                                  BorderRadius.circular(5))),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(55, 50))),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ));
  }
}
