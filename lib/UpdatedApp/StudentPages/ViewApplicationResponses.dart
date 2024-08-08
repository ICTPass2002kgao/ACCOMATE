// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use, curly_braces_in_flow_control_structures

import 'dart:io';

// import 'package:api_com/DeactivatedFiles/ViewContract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
// import 'package:path/path.dart';

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

  // String _pdfContractPath = '';
  File? pdfContractFile;
  void _appliedStudent(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Container(
        height: 250,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.blue[50],
          title: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    color: const Color.fromRGBO(239, 83, 80, 1),
                    width: 100,
                    height: 100,
                    child: Icon(Icons.cancel_outlined,
                        color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                print('email sent successfully');
              },
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                backgroundColor: WidgetStatePropertyAll(Colors.red[300]),
              ),
              child: Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }

  late User _user;

  Map<String, dynamic>? _userData;
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
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 400;

    double containerWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 650;
    bool isLargeScreen = MediaQuery.of(context).size.width > 650;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
            '${widget.studentApplicationData['accomodationName'] ?? 'n/a'}'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: isLargeScreen ? Colors.blue : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10)),
          width: containerWidth,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                                    widget.studentApplicationData['status'] ==
                                            true
                                        ? 'Approved'
                                        : 'Rejected',
                                    style: TextStyle(
                                        color: widget.studentApplicationData[
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
                      ),
                    ]),
                    widget.studentApplicationData['status'] == false
                        ? Column(
                            children: [
                              Container(
                                  width: buttonWidth,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Hi, ${_userData?['surname'] ?? 'N/A'} ${_userData?['name'] ?? 'N/A'}, we regret to inform you that your application have been rejected due to the following reasons:\n*${widget.studentApplicationData['landlordMessage']}*',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hi, ${_userData?['surname'] ?? 'N/A'} ${_userData?['name'] ?? ''}, your application have been approved you have 3 days limited for you to register otherwise your application will be considered as failed.',
                                        maxLines: 100,
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Text(
                                      //   'Instructions:',
                                      //   style: TextStyle(
                                      //       fontSize: 20,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                      Text(
                                        '${widget.studentApplicationData['landlordMessage']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  )),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              // ElevatedButton(
                              // onPressed: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               ViewContract(
                              //                 studentApplicationData: widget
                              //                     .studentApplicationData,
                              //               )));
                              // },
                              // child: Text('View Contract'),
                              // style: ButtonStyle(
                              //     shape: MaterialStatePropertyAll(
                              //         RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(5))),
                              //     foregroundColor:
                              //         MaterialStatePropertyAll(
                              //             Colors.blue),
                              //     backgroundColor:
                              //         MaterialStatePropertyAll(
                              //             Colors.blue[50]),
                              //     minimumSize: MaterialStatePropertyAll(
                              //         Size(double.infinity, 50))),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              // // Container(
                              // //   color: Colors.blue[50],
                              // //   width: buttonWidth,
                              // //   height: 50,
                              // //   child: Row(
                              // //     children: [
                              // //       TextButton.icon(
                              // //         onPressed: () {
                              // //           _userData?['isRegistered']==false?
                              // //           _pickSignedContract(context):_appliedStudent(context,'Please be aware that you can not register in more than one residence.','');
                              // //         },
                              // //         icon: Icon(
                              // //             Icons
                              // //                 .add_photo_alternate_outlined,
                              // //             color: Colors.blue),
                              // //         label: Text(
                              // //           'Upload Contract',
                              // //           style: TextStyle(fontSize: 18),
                              // //         ),
                              // //         style: ButtonStyle(
                              // //             shape: WidgetStatePropertyAll(
                              // //                 RoundedRectangleBorder(
                              // //                     borderRadius:
                              // //                         BorderRadius.circular(
                              // //                             5))),
                              // //             foregroundColor:
                              // //                 WidgetStatePropertyAll(
                              // //                     Colors.blue),
                              // //             backgroundColor:
                              // //                 WidgetStatePropertyAll(
                              // //                     Colors.white),
                              // //             minimumSize:
                              // //                 WidgetStatePropertyAll(
                              // //                     Size(130, 50))),
                              // //       ),
                              // //       SizedBox(width: 5),
                              // //       Text(basename(_pdfContractPath))
                              // //     ],
                              // //   ),
                              // // ),
                              // // SizedBox(height: 10),
                              // ElevatedButton.icon(
                              //   icon: Icon(Icons.send),
                              //   onPressed: ()  {

                              //     _uploadSignedContract(context);
                              //   },
                              //   label: Text('Submit'),
                              //   style: ButtonStyle(
                              //       shape: MaterialStatePropertyAll(
                              //           RoundedRectangleBorder(
                              //               borderRadius:
                              //                   BorderRadius.circular(5))),
                              //       foregroundColor:
                              //           MaterialStatePropertyAll(
                              //               Colors.blue[50]),
                              //       backgroundColor:
                              //           MaterialStatePropertyAll(
                              //               Colors.green),
                              //       minimumSize: MaterialStatePropertyAll(
                              //           Size(double.infinity, 50))),
                              // )
                            ],
                          ),
                  ]),
            ),
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
// Future<void> _pickSignedContract(BuildContext context) async {
//   try {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: [
//         'pdf',
//       ],
//     );
//     if (result != null) {
//       pdfContractFile = File(result.files.single.path!);
//       setState(() {
//         _pdfContractPath = pdfContractFile!.path;
//       });
//     }
//   } catch (e) {
//     _showErrorDialog(e.toString(), context);
//   }
// }
