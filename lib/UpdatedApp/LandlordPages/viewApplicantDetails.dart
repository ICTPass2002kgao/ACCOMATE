// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, deprecated_member_use

// import 'package:api_com/UpdatedApp/DocumentViewer.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Tables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class ViewApplicantDetails extends StatefulWidget {
  final Map<String, dynamic> studentApplicationData;
  const ViewApplicantDetails({super.key, required this.studentApplicationData});

  @override
  State<ViewApplicantDetails> createState() => _ViewApplicantDetailsState();
}

class _ViewApplicantDetailsState extends State<ViewApplicantDetails> {
  TextEditingController messageController = TextEditingController();

  bool status = true;
  late User _user;

  Map<String, dynamic>? _userData;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
    loadData();
  }

  bool isLoading = true;
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  void _showFeedback() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Container(
        height: 200,
        width: 250,
        child: AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text(
            'Successful Feedback',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 200,
            width: 250,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: Colors.green,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.done, color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Your feedback have been sent successfully to ${widget.studentApplicationData['name']}.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/landlordPage');

                print('email sent successfully');
              },
              child: Text('Continue'),
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Future<void> _saveApplicationResponse() async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      );

      String studentUserId = widget.studentApplicationData['userId'] ?? '';
      String landlordUserId = _userData?['userId'] ?? '';
      DocumentSnapshot applicationSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(landlordUserId)
          .collection('applicationsResponse')
          .doc(studentUserId)
          .get();

      if (applicationSnapshot.exists) {
        Navigator.of(context).pop();
        _appliedStudent(
            context,
            'You already sent a feedback to ${widget.studentApplicationData['name']} ${widget.studentApplicationData['surname']}',
            'Feedback Duplication');

        return;
      }
      DateTime now = DateTime.now();
      Timestamp feedbackDate = Timestamp.fromDate(now);

      await FirebaseFirestore.instance
          .collection('Students')
          .doc(studentUserId)
          .collection('applicationsResponse')
          .doc(landlordUserId)
          .set({
        'landlordMessage': messageController.text,
        'accomodationName': _userData?['accomodationName'] ?? '',
        'status': status,
        'userId': _userData?['userId'] ?? '',
        'feedbackDate': feedbackDate,
        'read': false,
        'email': _userData?['email'] ?? '',
        'location': _userData?['location'] ?? '',
        // 'contract': _userData?['contract'],
        // 'profilePicture': _userData?['profilePicture'] ?? '',
        // 'accomodationStatus': false,
        // 'selectedOffers': _userData?['selectedOffers'] ?? '',
        // 'selectedUniversity': _userData?['selectedUniversity'] ?? '',
        // 'distance': _userData?['distance'] ?? '',
        // 'selectedPaymentsMethods': _userData?['selectedPaymentsMethods'] ?? '',
        // 'requireDeposit': _userData?['requireDeposit'] ?? '',
        // 'contactDetails': _userData?['contactDetails'] ?? '',
        // 'accomodationType': _userData?['accomodationType'] ?? '',
        // 'roomType': _userData?['roomType'] ?? '',
        // 'displayedImages': _userData?['displayedImages'] ?? '',
        // 'isNsfasAccredited': _userData?['isNsfasAccredited'] ?? '',
        // 'isFull': false,
        // 'registeredDate': _userData?['registeredDate'] ?? '',
        // 'Duration': _userData?['Duration'] ?? '',
      });

      await sendEmail(
        _userData?['email'] ?? '',
        'Response sent successfully',
        '''<p>Hi ${_userData?['accomodationName']} landlord, <br/>Your feedback was sent successfully to ${widget.studentApplicationData['name']} ${widget.studentApplicationData['surname']}.<br/>Best Regards<br/>Your Accomate Team</p>''',
      );

      if (status == true) {
        await sendEmail(
          widget.studentApplicationData['email'],
          'Application Approved',
          '''<p>Hi ${widget.studentApplicationData['name']} , <br/>Your application from ${_userData?['accomodationName']} have been approved. Go to notification page in our app for more information.<br/>Best Regards<br/>Your Accomate Team</p>''',
        );
      } else {
        await sendEmail(
          widget.studentApplicationData['email'],
          'Application Rejected',
          '''<p>Hi ${widget.studentApplicationData['name']} , <br/>Your application from ${_userData?['accomodationName']} have been rejected due to some reasons. Go to notification page in our app for more information.<br/>Best Regards<br/>Your Accomate Team</p>''',
        );
      }
      
      Navigator.of(context).pop();

      _showFeedback();
    } catch (e) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  minimumSize:
                      MaterialStatePropertyAll(Size(double.infinity, 50)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> sendEmail(
    String recipientEmail,
    String subject,
    String body,
  ) async {
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

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 600;
    return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.studentApplicationData['name']} Application details'),
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
                            child: LinearProgressIndicator(color: Colors.blue)),
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
                        Tables(
                            columnName: 'Name',
                            columnValue:
                                widget.studentApplicationData['name'] ?? ''),
                        Tables(
                            columnName: 'Surname',
                            columnValue:
                                widget.studentApplicationData['surname'] ?? ''),
                        Tables(
                            columnName: 'Cellphone Number',
                            columnValue: widget
                                    .studentApplicationData['contactDetails'] ??
                                ''),
                        Tables(
                            columnName: 'Email Address',
                            columnValue:
                                widget.studentApplicationData['email'] ?? ''),
                        Tables(
                            columnName: 'Enrolled University',
                            columnValue:
                                widget.studentApplicationData['university'] ??
                                    ''),
                        Tables(
                            columnName: 'Type of room',
                            columnValue:
                                widget.studentApplicationData['roomType'] ??
                                    ''),
                        Tables(
                            columnName: 'Period of study',
                            columnValue:
                                widget.studentApplicationData['fieldOfStudy'] ??
                                    ''),
                        Tables(
                            columnName: 'Year of study',
                            columnValue: widget
                                    .studentApplicationData['periodOfStudy'] ??
                                ''),
                        Tables(
                            columnName: 'Application Date & Time',
                            columnValue: DateFormat('yyyy-MM-dd HH:mm').format(
                                widget.studentApplicationData['appliedDate']
                                    .toDate())),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: buttonWidth,
                            child: ExpansionTile(
                              title: Text('Choose Status'),
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      activeColor: Colors.green,
                                      fillColor: MaterialStatePropertyAll(
                                          Colors.green),
                                      value: true,
                                      groupValue: status,
                                      onChanged: (value) {
                                        setState(() {
                                          status = value!;
                                        });
                                      },
                                    ),
                                    Text('Accept applicant'),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Row(
                                  children: [
                                    Radio(
                                      activeColor: Colors.red,
                                      fillColor:
                                          MaterialStatePropertyAll(Colors.red),
                                      value: false,
                                      groupValue: status,
                                      onChanged: (value) {
                                        setState(() {
                                          status = value!;
                                        });
                                      },
                                    ),
                                    Text('Reject applicant'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(status == false
                                ? 'Please provide the reason a student is rejected & let the student know that they can reApply if their prefered room is not available or the problem can be resolved.'
                                : 'Please give the student Instructions on how they can sign the contract.'),
                            SizedBox(
                              height: 20,
                            ),
                            // OutlinedButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => Documentviewer(
                            //                   userData: _userData,
                            //                 )));
                            //   },
                            //   child: Text(
                            //     'View Contract',
                            //   ),
                            //   style: ButtonStyle(
                            //       shape: WidgetStatePropertyAll(
                            //           RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(5))),
                            //       foregroundColor:
                            //           WidgetStatePropertyAll(Colors.blue),
                            //       backgroundColor:
                            //           WidgetStatePropertyAll(Colors.blue[50]),
                            //       minimumSize: WidgetStatePropertyAll(
                            //           Size(buttonWidth, 50))),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Container(
                              width: buttonWidth,
                              child: TextField(
                                maxLines: 4,
                                controller: messageController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: status == false
                                        ? "Rejected reason"
                                        : 'Registration Instructions'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _saveApplicationResponse();
                          },
                          child: Text('Send Response'),
                          style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              backgroundColor: MaterialStatePropertyAll(
                                  status == true
                                      ? Colors.green
                                      : Colors.red[300]),
                              minimumSize: MaterialStatePropertyAll(
                                  Size(buttonWidth, 50))),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
