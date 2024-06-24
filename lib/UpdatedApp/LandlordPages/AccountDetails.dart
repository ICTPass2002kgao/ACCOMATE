// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:switcher_button/switcher_button.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late User? _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    loadData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  bool isLoading = true;
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  bool isFull = false;
  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Container(
                height: double.infinity,
                color: Colors.blue[100],
                width: buttonWidth,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              _userData?['displayedImages'][index],
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: _userData?['displayedImages'].length,
                          pagination:
                              SwiperPagination(builder: SwiperPagination.rect),
                          control: SwiperControl(
                              size: 20,
                              color: Colors.blue,
                              iconNext: Icons.navigate_next_outlined,
                              iconPrevious: Icons.navigate_before_rounded),
                          autoplay: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            _userData!['accomodationStatus'] == true
                                ? Row(
                                    children: [
                                      Text('Status:'),
                                      Text('Approved',
                                          style: TextStyle(color: Colors.green))
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text('Status:'),
                                      Text(
                                        'Pending..',
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                            Row(
                              children: [
                                Text('Address: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    _userData?['location'] ?? 'Loading...',
                                    maxLines:
                                        1, // Set the maximum number of lines
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text('Distance to campus: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(_userData?['distance'] ?? 'Loading...'),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  _userData?['email'] ?? '',
                                  maxLines:
                                      1, // Set the maximum number of lines
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text('Contact: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  _userData?['contactDetails'] ?? '',
                                  maxLines:
                                      1, // Set the maximum number of lines
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                            Text('Accommodated institutions',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            for (String university
                                in _userData?['selectedUniversity'].keys)
                              if (_userData?['selectedUniversity']
                                      ?[university] ??
                                  false)
                                Text('$university'),
                            SizedBox(height: 5),
                            Container(
                              width: buttonWidth,
                              child: ExpansionTile(
                                backgroundColor: Colors.blue[50],
                                title: Text('Residence is full?'),
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.green,
                                        fillColor: WidgetStatePropertyAll(
                                            Colors.green),
                                        value: false,
                                        groupValue: isFull,
                                        onChanged: (value) {
                                          setState(() {
                                            isFull = value!;
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
                                        activeColor: Colors.red,
                                        fillColor:
                                            WidgetStatePropertyAll(Colors.red),
                                        value: true,
                                        groupValue: isFull,
                                        onChanged: (value) {
                                          setState(() {
                                            isFull = value!;
                                          });
                                        },
                                      ),
                                      Text('Yes'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            isFull == true
                                ? TextButton(
                                    onPressed: () async {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            false, // user must tap button for close
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.blue[100],
                                            title: Text('Space Availability',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .warning_outlined,
                                                          color: Color.fromARGB(
                                                              255,
                                                              167,
                                                              156,
                                                              60),
                                                          size: 40),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                          child: Text(
                                                              'By updating this status, your residence will be considered as full and there will no longer be any applications from the students')),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  setState(() {});
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Yes'),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Landlords')
                                                      .doc(_user?.uid)
                                                      .update({
                                                    'isFull': true,
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Update'),
                                    style: ButtonStyle(
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        backgroundColor:
                                            WidgetStatePropertyAll(Colors.blue),
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.white),
                                        minimumSize: WidgetStatePropertyAll(
                                            Size(double.infinity, 50))),
                                  )
                                : Container(),
                            SizedBox(height: 5),
                            ExpansionTile(
                              title: Text('More details',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              children: [
                                ListTile(
                                  title: Text('Offered amities',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                for (String offers
                                    in _userData?['selectedOffers'].keys)
                                  if (_userData?['selectedOffers']?[offers] ??
                                      false)
                                    ListTile(
                                      title: Text(offers),
                                    ),
                                SizedBox(height: 5),
                                ListTile(
                                  title: Text('Payment Methods',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                for (String paymentMethods
                                    in _userData?['selectedPaymentsMethods']
                                        .keys)
                                  if (_userData?['selectedPaymentsMethods']
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
                                )),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
