// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

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
