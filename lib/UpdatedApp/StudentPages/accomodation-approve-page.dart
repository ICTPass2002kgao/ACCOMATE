import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class AccomodationApproval extends StatefulWidget {
  final Map<String, dynamic> landlordData;
  const AccomodationApproval({
    Key? key,
    required this.landlordData,
  });

  @override
  State<AccomodationApproval> createState() => AccomodationApprovalState();
}

class AccomodationApprovalState extends State<AccomodationApproval> {
  late User _user;
  bool accomodationStatus = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  TextEditingController messageController = TextEditingController();

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
          .collection('Landlords')
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
                  String? userEmail = await _user.email;
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

  Future<void> sendEmail(
      String recipientEmail, String subject, String body) async {
    if (!kIsWeb) {
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
    } else {
      try {
        final result = await sendEmailCallable.call({
          'to': recipientEmail,
          'subject': subject,
          'body': body,
        });
        print(result.data);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  final HttpsCallable sendEmailCallable =
      FirebaseFunctions.instance.httpsCallable('sendEmail');

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
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: buttonWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            widget.landlordData['displayedImages'][index],
                            fit: BoxFit.cover,
                          );
                        },
                        itemCount:
                            widget.landlordData['displayedImages']?.length ?? 0,
                        pagination:
                            SwiperPagination(builder: SwiperPagination.dots),
                        control: SwiperControl(
                            size: 20,
                            color: Colors.blue,
                            iconNext: Icons.navigate_next_outlined,
                            iconPrevious: Icons.navigate_before_rounded),
                        autoplay: false,
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
                        in widget.landlordData['selectedUniversity']?.keys ??
                            [])
                      if (widget.landlordData['selectedUniversity']
                              ?[university] ??
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
                            in widget.landlordData['selectedOffers']?.keys ??
                                [])
                          if (widget.landlordData['selectedOffers']?[offers] ??
                              false)
                            ListTile(
                              title: Text(offers),
                            ),
                        SizedBox(height: 5),
                        ListTile(
                          title: Text('Payment Methods',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        for (String paymentMethods in widget
                                .landlordData['selectedPaymentsMethods']
                                ?.keys ??
                            [])
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
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              accomodationStatus = true;
                            });
                            await _saveAccomodationApproval();
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green),
                              minimumSize: WidgetStatePropertyAll(
                                  Size(buttonWidth, 55))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.approval_rounded, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Approve',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: buttonWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              accomodationStatus = false;
                            });
                            await _saveAccomodationApproval();
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red),
                              minimumSize: WidgetStatePropertyAll(
                                  Size(buttonWidth, 55))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cancel, color: Colors.white),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Reject',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
