// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

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

  @override
  Widget build(BuildContext context) {
    // double buttonWidth =
    //     MediaQuery.of(context).size.width < 550 ? double.infinity : 400;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                color: const Color.fromARGB(179, 231, 231, 231),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Container(
                                width: 500,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 500,
                                      child: Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.network(
                                                        _userData?[
                                                                'profilePicture'] ??
                                                            'Loading...',
                                                        width: double.infinity,
                                                        height: 300.0,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Text('Location: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                      _userData?['location'] ??
                                                          'Loading...',
                                                      maxLines:
                                                          1, // Set the maximum number of lines
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Text('Distance to campus: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(_userData?[
                                                            'distance'] ??
                                                        'Loading...'),
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 13,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                    'Accommodated institutions',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 5),
                                                for (String university
                                                    in _userData?[
                                                            'selectedUniversity']
                                                        .keys)
                                                  if (_userData?[
                                                              'selectedUniversity']
                                                          ?[university] ??
                                                      false)
                                                    Text('$university'),
                                                SizedBox(height: 5),
                                                ExpansionTile(
                                                  title: Text('More details',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                          'Offered amities',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    for (String offers
                                                        in _userData?[
                                                                'selectedOffers']
                                                            .keys)
                                                      if (_userData?[
                                                                  'selectedOffers']
                                                              ?[offers] ??
                                                          false)
                                                        ListTile(
                                                          title: Text(offers),
                                                        ),
                                                    SizedBox(height: 5),
                                                    ListTile(
                                                      title: Text(
                                                          'Payment Methods',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    for (String paymentMethods
                                                        in _userData?[
                                                                'selectedPaymentsMethods']
                                                            .keys)
                                                      if (_userData?[
                                                                  'selectedPaymentsMethods']
                                                              ?[
                                                              paymentMethods] ??
                                                          false)
                                                        ListTile(
                                                          title: Text(
                                                              paymentMethods),
                                                        ),
                                                    SizedBox(height: 5),
                                                    ListTile(
                                                        title: Text(
                                                      'Nsfas Accredited',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ])))));
  }
}
