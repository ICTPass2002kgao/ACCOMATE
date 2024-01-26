import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccomodationApproval extends StatefulWidget {
  final Map<String, dynamic> landlordData;
  const AccomodationApproval({
    Key? key,
    required this.landlordData,
    // required this.imageUrls,
  });

  @override
  State<AccomodationApproval> createState() => AccomodationApprovalState();
}

class AccomodationApprovalState extends State<AccomodationApproval> {
  late User _user;
  Map<String, dynamic>? _userData;
  bool accomodationStatus = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
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

  Future<void> _saveAccomodationApproval() async {
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

      String landlordUserId = widget.landlordData['userId'] ?? '';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(landlordUserId)
          .update({'accomodationStatus': accomodationStatus});

      sendEmail(
        widget.landlordData['email'],
        accomodationStatus == true ? 'Review Approved' : 'Review Rejected',
        accomodationStatus == true
            ? 'Dear ${widget.landlordData['accomodationName'] ?? ''} landlord, \nYour residence was approved and reviewed successfully .\n\n\n\n\nBest regards\nYours Accomate'
            : 'Dear ${widget.landlordData['accomodationName'] ?? ''} landlord, \nYour residence was rejected and reviewed unsuccessfully .\n\n\n\n\nBest regards\nYours Accomate',
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          height: 250,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              'Accomodation review Response',
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
                      child: Icon(Icons.done, color: Colors.white, size: 35),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your response was sent successfully.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, '/adminPage');
                  String? userEmail =
                      await FirebaseAuth.instance.currentUser!.email;
                  await sendEmail(
                    '${userEmail}',
                    'Response sent successfully',
                    'Hi Admin, \nYour response was sent successfully to ${widget.landlordData['accomodationName']}\n\n\n\n\nBest regards\nYours Accomate',
                  );

                  print('Email sent successfully');
                },
                child: Text('Done'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print(e);
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
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.landlordData['accomodationName'] ?? '',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          width: buttonWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 270,
                        child: Expanded(
                          child: PageView.builder(
                            itemCount:
                                widget.landlordData['displayedImages'].length ==
                                        0
                                    ? 1
                                    : widget.landlordData['displayedImages']
                                            .length +
                                        1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Image.network(
                                  widget.landlordData['profilePicture'] ??
                                      'Loading...',
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 250,
                                );
                              } else {
                                return Image.network(
                                  widget.landlordData['displayedImages']
                                      [index - 1],
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 250,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Address: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      widget.landlordData['location'] ?? 'Loading...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Distance to campus: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.landlordData['distance'] ?? 'Loading...'),
                  Icon(
                    Icons.location_on_outlined,
                    size: 13,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text('For more information contact us via:'),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('Email: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    widget.landlordData['email'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Contact: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    widget.landlordData['contactDetails'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              Text('Accommodated institutions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              for (String university
                  in widget.landlordData['selectedUniversity'].keys)
                if (widget.landlordData['selectedUniversity']?[university] ??
                    false)
                  Text('$university'),
              SizedBox(height: 5),
              ExpansionTile(
                title: Text('More details',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                children: [
                  ListTile(
                    title: Text('Offered amenities',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  for (String offers
                      in widget.landlordData['selectedOffers'].keys)
                    if (widget.landlordData['selectedOffers']?[offers] ?? false)
                      ListTile(
                        title: Text(offers),
                      ),
                  SizedBox(height: 5),
                  ListTile(
                    title: Text('Payment Methods',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  for (String paymentMethods
                      in widget.landlordData['selectedPaymentsMethods'].keys)
                    if (widget.landlordData['selectedPaymentsMethods']
                            ?[paymentMethods] ??
                        false)
                      ListTile(
                        title: Text(paymentMethods),
                      ),
                  SizedBox(height: 5),
                  ListTile(
                    title: Text(
                      'Nsfas Accredited',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: buttonWidth,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ExpansionTile(
                    title: Text('Choose Status'),
                    children: [
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.green,
                            fillColor: MaterialStateProperty.all(Colors.green),
                            value: true,
                            groupValue: accomodationStatus,
                            onChanged: (value) {
                              setState(() {
                                accomodationStatus = value!;
                              });
                            },
                          ),
                          Text('Approve Accommodation'),
                        ],
                      ),
                      SizedBox(width: 16),
                      Row(
                        children: [
                          Radio(
                            activeColor: Colors.red,
                            fillColor: MaterialStateProperty.all(Colors.red),
                            value: false,
                            groupValue: accomodationStatus,
                            onChanged: (value) {
                              setState(() {
                                accomodationStatus = value!;
                              });
                            },
                          ),
                          Text('Reject Accommodation'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                        height: 250,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Text(
                            'Accommodation review Response',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Container(
                            height: 200,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    color: accomodationStatus == true
                                        ? Colors.green
                                        : Colors.red[400],
                                    width: 80,
                                    height: 80,
                                    child: Icon(
                                      accomodationStatus == true
                                          ? Icons.done
                                          : Icons.cancel_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                accomodationStatus == true
                                    ? Text(
                                        'Hi Admin, This is to inform you that you are reviewing the ${widget.landlordData['accomodationName']} as approved.',
                                      )
                                    : Text(
                                        'Hi Admin, This is to inform you that you are reviewing the ${widget.landlordData['accomodationName']} as rejected.',
                                      ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await _saveAccomodationApproval();
                              },
                              child: Text('Continue'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Text(accomodationStatus == true
                      ? 'Approve accommodation'
                      : 'Reject accommodation'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      accomodationStatus == true
                          ? Colors.green
                          : Colors.red[400],
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    minimumSize: MaterialStateProperty.all(
                      Size(buttonWidth, 50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
