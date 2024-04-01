import 'package:api_com/UpdatedApp/accomodation-approve-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _landlordsData = [];
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this); // Adjust the length based on the number of tabs
    // _user = FirebaseAuth.instance.currentUser!;
    _loadLandlordData();
    // _loadUserData();
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

  // late User _user;
  // Map<String, dynamic>? _userData; // Make _userData nullable

  // Future<void> _loadUserData() async {
  //   DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_user.uid)
  //       .get();
  //   setState(() {
  //     _userData = userDataSnapshot.data() as Map<String, dynamic>?;
  //   });
  // }
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
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
                setState(() {});

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(
                    context, '/login'); // navigate to login page
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
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.settings,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(
                height: 50,
              ),
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
                                  Text('1.Acceptance of Terms',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(height: 5),
                                  Text(
                                      'By accessing or using the Accomate Accommodation Services, including the Accomate mobile application and associated platforms (collectively referred to as "the App"), you agree to comply with and be bound by the following terms and conditions.'),
                                  SizedBox(height: 10),
                                  Text('2.Landlord Responsibilities',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(height: 5),
                                  Text('a.Accurate Information',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                    'Landlords must provide accurate and up-to-date information about the accommodation, including but not limited to rent, amenities, location, and availability.',
                                  ),
                                  SizedBox(height: 5),
                                  Text('b.Media Content',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Any images, amities, or media content related to the accommodation must accurately represent the property.'),
                                  SizedBox(height: 5),
                                  Text('c.Compliance with Laws',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Landlords must comply with all relevant local, state, and national laws related to housing and accommodation.'),
                                  SizedBox(height: 5),
                                  Text('d.Timely Responses',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Landlords should respond to students applications in a timely manner, providing necessary information and documentation promptly.'),
                                  SizedBox(height: 5),
                                  Text('3.Students Responsibilities',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('a.Accurate Information',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Students must provide accurate and truthful information in their account registration.'),
                                  SizedBox(height: 5),
                                  Text('b.Compliance with Rules',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Students must abide by the rules and guidelines set by the landlord for the accommodation.'),
                                  SizedBox(height: 5),
                                  Text('c.Respectful Communication',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Students should communicate respectfully with landlords and other stakeholders involved in the application process.'),
                                  SizedBox(height: 5),
                                  Text('d.In-App Communication',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      "Should student encounter any faulty/issue in the room or block, the student can share the issue in the application's chat page."),
                                  SizedBox(height: 5),
                                  Text('e.Privacy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Students should be mindful of the privacy of others and handle personal information responsibly.'),
                                  SizedBox(height: 5),
                                  Text('4.Application Process',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('a.Submission',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Students must submit their accommodation application through the Accomate platform, providing all required information.'),
                                  SizedBox(height: 5),
                                  Text('b.Fair Review',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Landlords should apply fair and non-discriminatory screening practices when considering students applications.'),
                                  SizedBox(height: 5),
                                  Text('c.POPI Act and Personal Information',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Landlords must comply with the POPI Act when collecting, processing, or storing Student personal information.'),
                                  SizedBox(height: 5),
                                  Text('d.Decision',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Landlords will make decisions based on the information provided by Students and communicate the outcome through the Accomate platform.'),
                                  SizedBox(height: 5),
                                  Text('e.Confirmation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Successful Students should confirm their acceptance and adhere to the agreed-upon terms.'),
                                  SizedBox(height: 5),
                                  Text('5.Payments',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                    'In terms of Payments, Landlords should pay R21 per month for each student that will apply & register on their accommodation using the app',
                                  ),
                                  SizedBox(height: 5),
                                  Text('6.POPI Act Compliance',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('a.Consent',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'By using the App, students explicitly consent to the collection and processing of their personal information in compliance with the POPI Act.'),
                                  SizedBox(height: 5),
                                  Text('b.Data Security',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Accomate will implement reasonable measures to secure personal information in accordance with the POPI Act.'),
                                  SizedBox(height: 5),
                                  Text('c.Data Subject Rights',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Users have the right to access, correct, or delete their personal information as outlined in the POPI Act.'),
                                  SizedBox(height: 5),
                                  Text('7.Dispute Resolution',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text('a.Mediation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      ' In the event of disputes between landlords and Students, Accomate may offer mediation services to resolve conflicts.'),
                                  SizedBox(height: 5),
                                  Text('b.Legal Recourse',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Users retain the right to seek legal recourse for matters not resolved through mediation.'),
                                  SizedBox(height: 5),
                                  Text('8.Termination of Service',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Accomate reserves the right to terminate or suspend services for users who violate these terms and conditions.'),
                                  SizedBox(height: 5),
                                  Text('9.Changes to Terms',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(height: 5),
                                  Text(
                                      'Accomate reserves the right to modify these terms and conditions. Users will be notified of any changes, and continued use of the service constitutes acceptance of the modified terms.'),
                                  SizedBox(height: 5),
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
      body: Container(
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
                        if (_landlordsData.any(
                          (landlord) => landlord['accomodationType'] == false,
                        ))
                          SingleChildScrollView(
                              child: Column(
                            children: [
                              for (Map<String, dynamic> landlordData
                                  in _landlordsData)
                                if (landlordData['accomodationType'] == false &&
                                    landlordData['accomodationStatus'] == false)
                                  buildLandlordCard(landlordData),
                            ],
                          )),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_landlordsData.any(
                            (landlord) => landlord['accomodationType'] == true))
                          Column(
                            children: [
                              for (Map<String, dynamic> landlordData
                                  in _landlordsData)
                                if (landlordData['accomodationType'] == true &&
                                    landlordData['accomodationStatus'] == false)
                                  buildLandlordCard(landlordData),
                            ],
                          )
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

  Widget buildLandlordCard(Map<String, dynamic> landlordData) {
    return Column(
      children: [
        for (Map<String, dynamic> landlordData in _landlordsData)
          ListTile(
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
          ),
      ],
    );
  }
}
