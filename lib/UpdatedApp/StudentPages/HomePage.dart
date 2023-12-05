// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int isSelected = 0;

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> _landlordsData = [];

  @override
  void initState() {
    super.initState();
    _loadLandlordData();
  }

  Future<void> _loadLandlordData() async {
    QuerySnapshot landlordSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> landlordsData = [];

    for (QueryDocumentSnapshot documentSnapshot in landlordSnapshot.docs) {
      Map<String, dynamic> landlordData =
          documentSnapshot.data() as Map<String, dynamic>;
      landlordsData.add(landlordData);
    }

    setState(() {
      _landlordsData = landlordsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while data is being fetched
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display landlord details
                Text(
                  'Transport Accomodation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (Map<String, dynamic> landlordData in _landlordsData)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccomodationPage(
                                  landlordData: landlordData,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        landlordData['profilePicture'],
                                        width: 250.0,
                                        height: 250.0,
                                        fit: BoxFit.cover,
                                      )),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(
                                          ' ${landlordData['accomodationName'] ?? 'N/A'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.blue[900],
                                        size: 14,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Available Now',
                                    style: TextStyle(color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Non-Transport Accomodation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    ));
  }
}
//  4