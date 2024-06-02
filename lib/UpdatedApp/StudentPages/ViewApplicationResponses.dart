// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

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

  // String _pdfDownloadSignedContractURL = '';
  // String _pdfSignedContractPath = '';
  // bool isFileChosen = false;
  // File? pdfSignedContractFile;
  // Future<void> _pickSignedContract(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf'],
  //     );

  //     if (result != null) {
  //       pdfSignedContractFile = File(result.files.single.path!);
  //       setState(() {
  //         _pdfSignedContractPath = pdfSignedContractFile!.path;
  //         isFileChosen = true; // Set the flag to true when a file is chosen
  //       });
  //     } else {
  //       // No file chosen
  //       setState(() {
  //         isFileChosen = false;
  //       });
  //     }
  //   } catch (e) {
  //     _showErrorDialog(e.toString(), context);
  //   }
  // }

  // Future<String?> _uploadSignedContact(
  //     File pdfFile, BuildContext context) async {
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     firebase_storage.Reference reference = firebase_storage
  //         .FirebaseStorage.instance
  //         .ref('signedContracts')
  //         .child('$fileName.pdf');

  //     await reference.putFile(pdfFile);

  //     return await reference.getDownloadURL();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.toString()),
  //       ),
  //     );
  //     return null;
  //   }
  // }

  // void _showErrorDialog(String errorMessage, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       title: Text(
  //         'Error Occurred',
  //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //       ),
  //       content: Text(
  //         errorMessage,
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('OK'),
  //           style: ButtonStyle(
  //             shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(5),
  //             )),
  //             foregroundColor: MaterialStateProperty.all(Colors.white),
  //             backgroundColor: MaterialStateProperty.all(Colors.blue),
  //             minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  late User _user;

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
        .collection('Students')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    final smtpServer = gmail('accomate33@gmail.com', 'nhle ndut leqq baho');
    final message = Message()
      ..from = Address('accomate33@gmail.com', 'Accomate Team')
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

  bool isLoading = true;
  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 3));

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
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
            '${widget.studentApplicationData['accomodationName'] ?? 'n/a'}'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(
              child: Container(
                  width: 100,
                  height: 100,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Text("Loading...")),
                      Center(
                          child: LinearProgressIndicator(
                        color: Colors.blue,
                      )),
                    ],
                  ))))
          : Container(
              color: Colors.blue[100],
              height: double.infinity,
              child: SingleChildScrollView(
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
                                    child: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ),
                              TableCell(
                                child: Center(
                                    child: Text(
                                        // ignore: unrelated_type_equality_checks
                                        widget.studentApplicationData[
                                                    'status'] ==
                                                true
                                            ? 'Accepted'
                                            : 'Rejected',
                                        style: TextStyle(
                                            color:
                                                widget.studentApplicationData[
                                                            'status'] ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red))),
                              ),
                            ],
                          ),
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
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(widget.studentApplicationData[
                                          'accomodationName'] ??
                                      'N/A'),
                                )),
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
                                            'Hi, ${_userData?['name'] ?? 'N/A'} Your Application have been rejected due to the following reasons:\n${widget.studentApplicationData['landlordMessage']}',
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
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
                                            'Hi, ${_userData?['name'] ?? ''} Your application have been approved you have 3 days limited for you to register otherwise your application will be considered as failed.',
                                            maxLines: 100,
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.blue[300]),
                                        minimumSize: MaterialStatePropertyAll(
                                            Size(double.infinity, 50))),
                                  )
                                ],
                              ),
                      ]),
                ),
              ),
            ),
    );
  }

//   Future<void> downloadFile(BuildContext context, String downloadUrl) async {
//     try {
//       // Check for storage permission
//       var status = await Permission.storage.status;
//       if (!status.isGranted) {
//         await Permission.storage.request();
//       }
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Colors.blue,
//         content: Text('Downloading...', style: TextStyle(color: Colors.white)),
//         duration: Duration(seconds: 2),
//       ));
//       // Get the application documents directory
//       // Get the Downloads directory
//       Directory? downloadsDirectory = await getDownloadsDirectory();

//       if (downloadsDirectory != null) {
//         String savePath =
//             "${downloadsDirectory.path}/${widget.studentApplicationData['accomodationName']}'s Contract.pdf";

//         // Create a reference to the Firebase Storage file
//         Reference storageReference =
//             FirebaseStorage.instance.ref().child(downloadUrl);

//         // Download the file to the device
//         await Dio().download(storageReference.fullPath, savePath);
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.green,
//           content: Text('File downloaded successfully!',
//               style: TextStyle(color: Colors.white)),
//         ),
//       );
//     } catch (e) {
//       print('Error downloading file: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(e.toString()),
//         ),
//       );
//     }
//   }
}
