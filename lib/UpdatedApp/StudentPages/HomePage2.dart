import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  State<Homepage2> createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _landlordsData = [];
  late TabController _tabController;
  late Future<void> _fetchData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData = _loadLandlordData();
    loadData();
  }

  bool isLoading = true;
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadLandlordData() async {
    QuerySnapshot landlordSnapshot =
        await FirebaseFirestore.instance.collection('Landlords').get();

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
    await _loadLandlordData();
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
            child: FutureBuilder(
              future: _fetchData,
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
                } else {
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      _buildAccommodationList(false),
                      _buildAccommodationList(true)
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccommodationList(bool isHouse) {
    List<Map<String, dynamic>> filteredList = _landlordsData.where((landlord) {
      return landlord['accomodationType'] == isHouse &&
          landlord['accomodationStatus'] == true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccommodationSection(
              'Nsfas Accredited', filteredList, true, isHouse),
          _buildAccommodationSection(
              'Not Nsfas Accredited', filteredList, false, isHouse),
        ],
      ),
    );
  }

  Widget _buildAccommodationSection(
      String title,
      List<Map<String, dynamic>> list,
      bool accrediationAvailability,
      bool isHouse) {
    List<Map<String, dynamic>> filteredList = list
        .where((landlord) =>
            landlord['isNsfasAccredited'] == accrediationAvailability)
        .toList();

    // if (filteredList.isEmpty) {
    //   return Container(
    //     height: 200,
    //     color: Colors.red,
    //     child: Center(child: Text('')),
    //   );
    // }
    if (filteredList.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            '$title ${isHouse ? 'Houses' : 'Accommodations'}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 10),
              for (Map<String, dynamic> landlordData in filteredList)
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
                  landlordData['isNsfasAccredited'] == true
                      ? 'Nsfas Accredited'
                      : 'Not Nsfas accredited',
                  style: TextStyle(
                      color: landlordData['isNsfasAccredited'] == true
                          ? Colors.green
                          : Colors.red),
                ),
                Text(landlordData['Duration'] == "Half Year"
                    ? '6 Months students allowed'
                    : landlordData['Duration'] == "Full Year"
                        ? 'Only 10 months students'
                        : 'All students Allowed including 6 months'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
