// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_final_fields

import 'package:api_com/UpdatedApp/LandlordPages/AccountDetails.dart';
import 'package:api_com/UpdatedApp/LandlordPages/ChatPage.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Notification.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Home.dart';
import 'package:api_com/UpdatedApp/LandlordPages/RegisteredStudents.dart';
import 'package:api_com/UpdatedApp/Terms&Conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';

class LandlordPage extends StatefulWidget {
  const LandlordPage({super.key});

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
  TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> _registeredStudents = [];

  late User? _user;
  Map<String, dynamic>? _userData;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    _loadNotificationCount();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
    _loadNotificationCount();
  }

  bool isFull = false;
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
      String? landlordUserId = _user?.uid;
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
  List screens = [
    HomePage(),
    Notifications(
      onNotificationOpened: () {},
    ),
    Chatpage(),
    AccountDetails(),
    RegisteredStudents()
  ];

  int _notificationCount = 0;
  Future<void> _loadNotificationCount() async {
    QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user?.uid)
        .collection('applications')
        .where('read', isEqualTo: false)
        .get();
    setState(() {
      _notificationCount = applicationsSnapshot.docs.length;
    });
  }

  void _onNotificationOpened() {
    _loadNotificationCount();
  }

  Future<void> _loadStudentContract() async {
    try {
      String landlordId = _userData?['userId'] ?? '';
      if (landlordId.isEmpty) {
        print('Landlord ID is empty');
        return;
      }
      QuerySnapshot registeredSnapshot = await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(landlordId)
          .collection('signedContracts')
          .get();

      List<Map<String, dynamic>> registeredStudents = [];

      for (QueryDocumentSnapshot documentSnapshot in registeredSnapshot.docs) {
        Map<String, dynamic> registrationData =
            documentSnapshot.data() as Map<String, dynamic>;
        registeredStudents.add(registrationData);
      }

      setState(() {
        _registeredStudents = registeredStudents;
      });

      print('Loaded registered students: $_registeredStudents');
    } catch (e) {
      print('Error loading student contracts: $e');
    }
  }

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
                    TermsAndConditions();
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
                                    messageController.text.isEmpty &&
                                            messageController.text.length < 10
                                        ? showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                    'Error',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  content: Text(
                                                      'Sorry, your issue cannot be resolved'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Okay'),
                                                        style: ButtonStyle(
                                                            shape: WidgetStatePropertyAll(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5))),
                                                            foregroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors
                                                                        .white),
                                                            backgroundColor:
                                                                MaterialStatePropertyAll(
                                                                    Colors
                                                                        .green),
                                                            minimumSize:
                                                                MaterialStatePropertyAll(
                                                                    Size(
                                                                        double
                                                                            .infinity,
                                                                        50)))),
                                                  ],
                                                ))
                                        : _sendHelpMessage();
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
                ),
              ],
            )),
        body: _buildBody());
  }

  Widget _buildBodyPages() {
    switch (_currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return Notifications(onNotificationOpened: _onNotificationOpened);
      case 2:
        return Chatpage();
      case 3:
        return AccountDetails();
      case 4:
        return RegisteredStudents();
      default:
        return Container();
    }
  }

  NavigationRailDestination _buildNavigationRailDestination(
      IconData icon, String label) {
    return NavigationRailDestination(
      indicatorColor: Colors.blue,
      icon: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 25),
            SizedBox(width: 30),
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
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
            data: IconThemeData(size: 100.0),
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
                _buildNavigationRailDestination(Icons.home, 'Home'),
                NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: [
                        _notificationCount > 0
                            ? IconBadge(
                                icon: Icon(Icons.notifications_active_outlined,
                                    color: Colors.white, size: 25),
                              )
                            : Icon(Icons.notifications_active_outlined,
                                color: Colors.white, size: 25),
                        SizedBox(width: 30),
                        Text(
                          'Notifications',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  label: Text('Notifications'),
                ),
                _buildNavigationRailDestination(
                    Icons.mail_outline_outlined, 'Chat'),
                _buildNavigationRailDestination(
                    Icons.person, 'Account Details'),
                _buildNavigationRailDestination(
                    Icons.people_outline, 'Registered Students'),
              ],
            ),
          ),
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
        body: _buildBodyPages(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          useLegacyColorScheme: false,
          fixedColor: Colors.white,
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.white70,
          items: [
            _buildBottomNavigatorBar('Home', Icons.home),
            _notificationCount > 0
                ? BottomNavigationBarItem(
                    icon: IconBadge(
                      icon: Icon(
                        Icons.notifications_active_outlined,
                      ),
                      itemCount: _notificationCount,
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                    ),
                    label: 'Notifications',
                    backgroundColor: Colors.blue,
                  )
                : BottomNavigationBarItem(
                    backgroundColor: Colors.blue,
                    icon: Icon(
                      Icons.notifications_active_outlined,
                    ),
                    label: 'Notifications',
                  ),
            _buildBottomNavigatorBar('Chat', Icons.mail_outline_outlined),
            _buildBottomNavigatorBar('Me', Icons.person),
            _buildBottomNavigatorBar(
                'Registered Students', Icons.people_outline),
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
