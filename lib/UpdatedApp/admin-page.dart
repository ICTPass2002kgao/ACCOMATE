import 'package:api_com/UpdatedApp/accomodation-approve-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> _futureLandlordsData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _futureLandlordsData = _loadLandlordData();
  }

  Future<List<Map<String, dynamic>>> _loadLandlordData() async {
    QuerySnapshot landlordSnapshot =
        await FirebaseFirestore.instance.collection('Landlords').get();
    return landlordSnapshot.docs
        .map((documentSnapshot) =>
            documentSnapshot.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _futureLandlordsData = _loadLandlordData();
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          title: Text('Logout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Expanded(child: Text('Are you sure you want to logout?')),
                  ],
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/startPage');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Icon(Icons.settings, size: 100, color: Colors.white),
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.policy_outlined, color: Colors.white),
                title: Text('Terms & conditions'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          height: 500,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            scrollable: true,
                            title: Text('Term and conditions',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Add your terms and conditions content here
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                textColor: Colors.white,
              ),
              ListTile(
                leading: Icon(Icons.logout_outlined, color: Colors.white),
                title: Text('Logout'),
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                textColor: Colors.white,
              )
            ],
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureLandlordsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Approval Request available'));
            }

            final landlordsData = snapshot.data!;
            return Container(
              height: double.infinity,
              color: Colors.blue[100],
              child: Column(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (landlordsData.any((landlord) =>
                                  landlord['accomodationType'] == false))
                                Column(
                                  children: [
                                    for (Map<String, dynamic> landlordData
                                        in landlordsData)
                                      if (landlordData['accomodationType'] ==
                                              false &&
                                          landlordData['accomodationStatus'] ==
                                              false)
                                        buildLandlordCard(landlordData),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (landlordsData.any((landlord) =>
                                  landlord['accomodationType'] == true))
                                Column(
                                  children: [
                                    for (Map<String, dynamic> landlordData
                                        in landlordsData)
                                      if (landlordData['accomodationType'] ==
                                              true &&
                                          landlordData['accomodationStatus'] ==
                                              false)
                                        buildLandlordCard(landlordData),
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
            );
          },
        ),
      ),
    );
  }

  Widget buildLandlordCard(Map<String, dynamic> landlordData) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccomodationApproval(
              landlordData: landlordData,
            ),
          ),
        );
      },
      title: Row(
        children: [
          Flexible(
            child: Text(
              '${landlordData['accomodationName'] ?? 'N/A'}',
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.verified,
            color: Colors.blue[900],
            size: 14,
          ),
        ],
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(27.5),
        child: Image.network(
          landlordData['profilePicture'] ?? '',
          width: 55,
          height: 55,
          fit: BoxFit.cover,
        ),
      ),
      subtitle: Text(
        '${landlordData['email']}...',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
    );
  }
}
