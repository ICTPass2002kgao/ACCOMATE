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
    loadData();
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
                child: SingleChildScrollView(
                  child: Container(
                    width: buttonWidth,
                    child: Column(
                      children: [
                        Center(
                          child: Card(
                            color: Colors.blue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height:
                                            270, // Provide a fixed height or adjust based on your needs
                                        child: Expanded(
                                          child: PageView.builder(
                                            itemCount: _userData?[
                                                            'displayedImages']
                                                        .length ==
                                                    0
                                                ? 1 // If the list is empty, show only the default image
                                                : _userData?['displayedImages']
                                                        .length +
                                                    1,
                                            itemBuilder: (context, index) {
                                              if (index == 0) {
                                                // Display the desired default image for the first item
                                                return Image.network(
                                                  _userData?[
                                                          'profilePicture'] ??
                                                      'Loading...', // Replace with your desired image URL
                                                  fit: BoxFit.cover,
                                                  width: 300,
                                                  height: 250,
                                                );
                                              } else {
                                                // Display images from the list for subsequent items
                                                return Image.network(
                                                  _userData!['displayedImages']
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
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  _userData!['accomodationStatus'] == true
                                      ? Row(
                                          children: [
                                            Text('Status:'),
                                            Text('Approved',
                                                style: TextStyle(
                                                    color: Colors.green))
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text('Status:'),
                                            Text(
                                              'Pending..',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
                                  Row(
                                    children: [
                                      Text('Address: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(
                                          _userData?['location'] ??
                                              'Loading...',
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(_userData?['distance'] ??
                                          'Loading...'),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        _userData?['contactDetails'] ?? '',
                                        maxLines:
                                            1, // Set the maximum number of lines
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                  Text('Accommodated institutions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      ListTile(
                                        title: Text('Offered amities',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      for (String offers
                                          in _userData?['selectedOffers'].keys)
                                        if (_userData?['selectedOffers']
                                                ?[offers] ??
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
                                      for (String paymentMethods in _userData?[
                                              'selectedPaymentsMethods']
                                          .keys)
                                        if (_userData?[
                                                    'selectedPaymentsMethods']
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
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
