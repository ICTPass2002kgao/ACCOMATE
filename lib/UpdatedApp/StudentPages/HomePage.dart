// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:api_com/UpdatedApp/StudentPages/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleRefresh() async {
    // Since we are using StreamBuilder, the data is automatically refreshed,
    // so we can simply complete the refresh without any additional actions.
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          TabBar(
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            controller: _tabController,
            tabs: [
              Tab(
                iconMargin: const EdgeInsets.only(bottom: 1.0),
                text: 'Accommodations',
                icon: Icon(Icons.location_city, color: Colors.blue),
              ),
              Tab(
                iconMargin: const EdgeInsets.only(bottom: 1.0),
                text: 'Houses',
                icon: Icon(Icons.home_work, color: Colors.blue),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Landlords').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
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
                                  child: LinearProgressIndicator(
                                      color: Colors.blue)),
                            ],
                          ))));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> landlordsData = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      _buildAccommodationList(landlordsData, false),
                      _buildAccommodationList(landlordsData, true),
                    ],
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccommodationList(List<Map<String, dynamic>> landlordsData, bool isHouse) {
    List<Map<String, dynamic>> filteredList = landlordsData.where((landlord) {
      return landlord['accomodationType'] == isHouse && landlord['accomodationStatus'] == true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filteredList.isNotEmpty)
            _buildAccommodationSection('Nsfas Accredited', filteredList, true, isHouse),
          if (filteredList.isNotEmpty)
            _buildAccommodationSection('Not Nsfas Accredited', filteredList, false, isHouse),
        ],
      ),
    );
  }

  Widget _buildAccommodationSection(
      String title,
      List<Map<String, dynamic>> list,
      bool accrediationAvailability,
      bool isHouse) {
    String fullTitle = '$title ${isHouse ? 'Houses' : 'Accommodations'}';

    List<Map<String, dynamic>> sectionList = list
        .where((landlord) =>
            landlord['isNsfasAccredited'] == accrediationAvailability &&
            landlord['accomodationType'] == isHouse)
        .toList();

    // If there is no residence available for that particular funding
    if (sectionList.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            fullTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 10),
              for (Map<String, dynamic> landlordData in sectionList)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccomodationPage(landlordData: landlordData),
                      ),
                    );
                  },
                  child: buildLandlordCard(landlordData),
                ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLandlordCard(Map<String, dynamic> landlordData) {
    String? profilePictureUrl = landlordData['profilePicture'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        color: Colors.blue[50],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: profilePictureUrl != null
                      ? Image.network(
                          profilePictureUrl,
                          width: 249,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(), // Or replace with a placeholder image
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ' ${landlordData['accomodationName'] ?? 'N/A'}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.verified,
                      color: Colors.blue[900],
                      size: 14,
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      landlordData['isFull'] == false
                          ? 'Available Now'
                          : 'Unavailable due to space',
                      style: TextStyle(
                          color: landlordData['isFull'] == false
                              ? Colors.green
                              : Colors.red),
                    ),
                    Icon(
                        landlordData['isFull'] == false
                            ? Icons.lock_open
                            : Icons.lock_outline,
                        size: 16)
                  ],
                ),
                SizedBox(height: 5.0),
                Text(
                  landlordData['isNsfasAccredited'] == true ? 'Nsfas Accredited' : 'Not Nsfas accredited',
                  style: TextStyle(
                      color: landlordData['isNsfasAccredited'] == true
                          ? Colors.green
                          : Colors.red),
                ),
                Text(landlordData['Duration'] == "Half Year"
                    ? 'Six Months Allowed'
                    : landlordData['Duration'] == "Full Year"
                        ? 'Full Year Only'
                        : 'All Students Allowed'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
