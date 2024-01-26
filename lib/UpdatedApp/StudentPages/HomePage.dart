// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  List<Map<String, dynamic>> _landlordsData = [];
  late TabController _tabController;

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLandlordData();
    loadData();
  }

  Future<void> _loadLandlordData() async {
    Future.delayed(Duration(seconds: 2));
    QuerySnapshot landlordSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'role',
          isEqualTo: true,
        )
        .get();

    List<Map<String, dynamic>> landlordsData = [];

    for (QueryDocumentSnapshot documentSnapshot in landlordSnapshot.docs) {
      Map<String, dynamic> landlordData =
          documentSnapshot.data() as Map<String, dynamic>;
      landlordsData.add(landlordData);
    }

    setState(() {
      _landlordsData = landlordsData;
    });
  }

  Future<void> _handleRefresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    indicatorColor: Colors.blue,
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Accommodations'),
                      Tab(text: 'Houses'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: LiquidPullToRefresh(
                            onRefresh: _handleRefresh,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ))
                                      : SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Display Transport Accommodation
                                              if (_landlordsData.any((landlord) =>
                                                  landlord[
                                                          'transport availability'] ==
                                                      true &&
                                                  landlord[
                                                          'accomodationType'] ==
                                                      false &&
                                                  landlord[
                                                          'accomodationStatus'] ==
                                                      true))
                                                SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Transport Accommodation',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 10),
                                                            for (Map<String,
                                                                    dynamic> landlordData
                                                                in _landlordsData)
                                                              if (landlordData[
                                                                          'transport availability'] ==
                                                                      true &&
                                                                  landlordData[
                                                                          'accomodationType'] ==
                                                                      false &&
                                                                  landlordData[
                                                                          'accomodationStatus'] ==
                                                                      true)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AccomodationPage(
                                                                          landlordData:
                                                                              landlordData,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: buildLandlordCard(
                                                                      landlordData),
                                                                ),
                                                            SizedBox(
                                                              width: 10,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              // Display Non-Transport Accommodation
                                              if (_landlordsData.any((landlord) =>
                                                  landlord['transport availability'] == false &&
                                                  landlord[
                                                          'accomodationType'] ==
                                                      false &&
                                                  landlord[
                                                          'accomodationStatus'] ==
                                                      true))
                                                SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'Non-Transport Accommodation',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(width: 10),
                                                            for (Map<String,
                                                                    dynamic> landlordData
                                                                in _landlordsData)
                                                              if (landlordData['transport availability'] == false &&
                                                                  landlordData[
                                                                          'accomodationType'] ==
                                                                      false &&
                                                                  landlordData[
                                                                          'accomodationStatus'] ==
                                                                      true)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AccomodationPage(
                                                                          landlordData:
                                                                              landlordData,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: buildLandlordCard(
                                                                      landlordData),
                                                                ),
                                                            SizedBox(width: 10)
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                ]),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display Transport Accommodation
                              if (_landlordsData.any((landlord) =>
                                  landlord['transport availability'] == true &&
                                  landlord['accomodationType'] == true &&
                                  landlord['accomodationStatus'] == true))
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Transport Houses',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 10),
                                            for (Map<String,
                                                    dynamic> landlordData
                                                in _landlordsData)
                                              if (landlordData['transport availability'] == true &&
                                                  landlordData[
                                                          'accomodationType'] ==
                                                      true &&
                                                  landlordData[
                                                          'accomodationStatus'] ==
                                                      true)
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AccomodationPage(
                                                          landlordData:
                                                              landlordData,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: buildLandlordCard(
                                                      landlordData),
                                                ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Display Non-Transport Accommodation
                              if (_landlordsData.any((landlord) =>
                                  landlord['transport availability'] == false &&
                                  landlord['accomodationType'] == true &&
                                  landlord['accomodationStatus'] == true))
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      'Non-Transport Houses',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (Map<String, dynamic> landlordData
                                              in _landlordsData)
                                            if (landlordData[
                                                        'transport availability'] ==
                                                    false &&
                                                landlordData[
                                                        'accomodationType'] ==
                                                    true &&
                                                landlordData[
                                                        'accomodationStatus'] ==
                                                    true)
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccomodationPage(
                                                        landlordData:
                                                            landlordData,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: buildLandlordCard(
                                                    landlordData),
                                              ),
                                          SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget buildLandlordCard(Map<String, dynamic> landlordData) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 290,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                landlordData['profilePicture'],
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  ' ${landlordData['accomodationName'] ?? 'N/A'}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.verified,
                  color: Colors.blue[900],
                  size: 14,
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Text(
              'Available Now',
              style: TextStyle(color: Colors.green),
            ),
          ],
        ),
      ),
    ),
  );
}
