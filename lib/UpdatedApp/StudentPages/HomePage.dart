import 'package:animate_ease/animate_ease.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
// import 'dart:math';
import 'package:page_transition/page_transition.dart';
import 'accomodation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleRefresh() async {
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 900;
    double containerWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 900;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
        child: Center(
          child: Container(
            width: containerWidth,
            decoration: BoxDecoration(
                border: Border.all(
                  color: isLargeScreen ? const Color.fromARGB(255, 223, 223, 223) : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(2)),
            child: Column(
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
                    stream: FirebaseFirestore.instance
                        .collection('Landlords')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading data'));
                      } else if (snapshot.hasData) {
                        List<Map<String, dynamic>> landlordsData = snapshot
                            .data!.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .toList();
                        return TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            isLargeScreen
                                ? _buildFlexibleGrid(landlordsData, true)
                                : _buildAccommodationList(landlordsData, true),
                            isLargeScreen
                                ? _buildFlexibleGrid(landlordsData, false)
                                : _buildAccommodationList(landlordsData, false),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: ColorfulCircularProgressIndicator(
                          colors: [
                            Colors.blue,
                            Colors.red,
                            Colors.purple,
                            Colors.green,
                            Colors.grey
                          ],
                          strokeWidth: 5,
                          indicatorHeight: 40,
                          indicatorWidth: 40,
                        ));
                      } else {
                        return Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlexibleGrid(
      List<Map<String, dynamic>> landlordsData, bool isAccomodation) {
    List<Map<String, dynamic>> filteredList = landlordsData.where((landlord) {
      return landlord['accomodationType'] == isAccomodation &&
          landlord['accomodationStatus'] == true;
    }).toList();

    return FlexibleGridView(
      children: List.generate(
        filteredList.length,
        (index) => GestureDetector(
          onTap: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AccomodationPage(landlordData: filteredList[index],)));
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         AccomodationPage(landlordData: filteredList[index]),
            //   ),
            // );
          },
          child: buildLandlordCard(filteredList[index]),
        ),
      ),
      axisCount: GridLayoutEnum.threeElementsInRow,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
    );
  }

  Widget _buildAccommodationList(
      List<Map<String, dynamic>> landlordsData, bool isAccomodation) {
    List<Map<String, dynamic>> filteredList = landlordsData.where((landlord) {
      return landlord['accomodationType'] == isAccomodation &&
          landlord['accomodationStatus'] == true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filteredList.isNotEmpty)
            _buildAccommodationSection(
                'Nsfas Accredited', filteredList, true, isAccomodation),
          if (filteredList.isNotEmpty)
            _buildAccommodationSection(
                'Not Nsfas Accredited', filteredList, false, isAccomodation),
        ],
      ),
    );
  }

  Widget _buildAccommodationSection(
      String title,
      List<Map<String, dynamic>> list,
      bool accrediationAvailability,
      bool isAccomodation) {
    String fullTitle = '$title ${isAccomodation ? 'Accommodations' : 'Houses'}';

    List<Map<String, dynamic>> sectionList = list
        .where((landlord) =>
            landlord['isNsfasAccredited'] == accrediationAvailability &&
            landlord['accomodationType'] == isAccomodation)
        .toList();

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
    String? profilePictureUrl = landlordData['displayedImages'][1] ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: AnimatedLoadingBorder(
                    borderColor: Colors.blue,
                    borderWidth: 5.0,
                    duration: Duration(seconds: 2),
                    child: CachedNetworkImage(
                      imageUrl: profilePictureUrl!,
                      width: 249,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ), // Display an empty container if profilePictureUrl is null
                AnimateEase(
                  duration: Duration(seconds: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            size: 16,
                          ),
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
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 13,
                            color: Colors.blue,
                          ),
                          Text(
                            landlordData['Duration'] == "Half Year"
                                ? 'Six Months Allowed'
                                : landlordData['Duration'] == "Full Year"
                                    ? 'Full Year Only'
                                    : 'All Students Allowed',
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
