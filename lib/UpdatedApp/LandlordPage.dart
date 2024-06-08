// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_final_fields

import 'package:api_com/UpdatedApp/LandlordPages/AccountDetails.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Notification.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Home.dart';
import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandlordPage extends StatefulWidget {
  const LandlordPage({super.key});

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  late User _user;
  Map<String, dynamic>? _userData;
  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text('Logout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined,
                        color: Color.fromARGB(255, 167, 156, 60), size: 40),
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

  final HttpsCallable sendEmailCallable =
      FirebaseFunctions.instance.httpsCallable('sendEmail');

  Future<void> sendEmail(String to, String subject, String body) async {
    try {
      final result = await sendEmailCallable.call({
        'to': to,
        'subject': subject,
        'body': body,
      });
      print(result.data);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 350,
          width: 250,
          child: AlertDialog(
            title: Text(
              'Successful Response',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop;
                },
                child: Text('okay'),
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 50))),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _sendHelpMessage() async {
    try {
      showDialog(
        context: context, // Prevent user from dismissing the dialog
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        },
      );
      String landlordUserId = _user.uid;
      String helpCenterId = 'dWKl2xV0gggWQyQycWm52lS3Hpk1';
      await FirebaseFirestore.instance
          .collection('Help Team')
          .doc(helpCenterId)
          .collection('studentHelpMessage')
          .doc(landlordUserId)
          .set({
        'message': messageController.text,
        'userId': landlordUserId,
        'email': _userData?['email'],
        'accomodationName': _userData?['accomodationName'],
        'profile': _userData?['profilePicture'],
      });
      sendEmail('accomatehelpcenter@gmail.com', 'Reported Issue',
          'Goodday Accomate help center officer,\nYou have a there is an issue reported by ${_userData?['accomodationName']} landlord.Please try by all means to assist our user.\n\n\n\n\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'Help Sent successfully',
                  style: TextStyle(fontSize: 15),
                ),
                content: Text(
                    'Accomate help center will try to troubleshoot & solve your reported issue.'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        // Close the dialog

                        Navigator.of(context).pop();
                        messageController.text = '';
                        Navigator.pushReplacementNamed(
                            context, '/landlordPage');
                      },
                      child: Text('Done'),
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          backgroundColor: WidgetStatePropertyAll(Colors.green),
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 50)))),
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  int _currentIndex = 0;
  List screens = [HomePage(), Notifications(), AccountDetails()];

  List<int> _badgeValues = [10, 0, 10, 99];

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: Colors.white,
          title: Text('Welcome to Accomate'),
          centerTitle: false,
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        endDrawer: Drawer(
            backgroundColor: Colors.blue,
            child: ListView(
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
                              title: Text('Term & conditions',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
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
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text('Help Center'),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Center(
                              child: Text('Contact Us',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.blue)),
                            ),
                            scrollable: true,
                            content: Container(
                              height: 250,
                              child: Column(
                                children: [
                                  Text(
                                      'We will sent a respond to you in Accomate chatPage',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.grey)),
                                  SizedBox(height: 10),
                                  Container(
                                    width: buttonWidth,
                                    child: TextField(
                                      maxLines: 6,
                                      controller: messageController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "Tell us how we can help"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            actions: [
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _sendHelpMessage();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                  ),
                                  label: Text(
                                    "Send",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
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
                    Navigator.of(context).pop();
                    setState(() {
                      _showLogoutConfirmationDialog(context);
                    });
                  },
                  textColor: Colors.white,
                )
              ],
            )),
        body: _buildBody());
  }

  // Widget _buildBody() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return HomePage();
  //     case 1:
  //       return Notifications();
  //     case 2:
  //       return Messages();
  //     case 3:
  //       return AccountDetails();
  //     default:
  //       return Container(); // Handle other cases if needed
  //   }
  // }

  NavigationRailDestination _buildNavigationRailDestination(
      IconData icon, String label, int badgeValue) {
    return NavigationRailDestination(
      indicatorColor: Colors.blue,
      icon: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 25),
                if (badgeValue > 0)
                  Positioned(
                    top: 0,
                    right: 110,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            badgeValue.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 30),
                Text(
                  label,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      label: Text(label),
    );
  }

  BottomNavigationBarItem _buildBottomNavigatorBar(
      String label, IconData icon) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(
        icon,
      ),
      label: label,
    );
  }

  Widget _buildBody() {
    if (MediaQuery.of(context).size.width > 830) {
      return Row(
        children: [
          IconTheme(
            data: IconThemeData(size: 100.0), // Adjust the size as needed

            child: NavigationRail(
              backgroundColor: Colors.blue,
              minWidth: 250,
              indicatorColor: Colors.transparent,
              useIndicator: false,
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.none,
              destinations: [
                _buildNavigationRailDestination(
                    Icons.home, 'Home', _badgeValues[0]),
                _buildNavigationRailDestination(Icons.notifications_active,
                    'Notification', _badgeValues[1]),
                _buildNavigationRailDestination(
                    Icons.person, 'Account Details', _badgeValues[3]),
              ],
            ),
          ),
          // Your main content goes here
          Expanded(
            child: Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => screens[_currentIndex],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          useLegacyColorScheme: false,
          fixedColor: Colors.white,
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.white70,
          items: [
            _buildBottomNavigatorBar('Home', Icons.home),
            _buildBottomNavigatorBar(
                'Notification', Icons.notifications_active),
            _buildBottomNavigatorBar('Account Details', Icons.person),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              screens[index];
            });
          },
        ),
      );
    }
  }
}
