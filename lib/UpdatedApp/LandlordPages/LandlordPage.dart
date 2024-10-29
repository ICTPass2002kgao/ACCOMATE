import 'package:api_com/UpdatedApp/LandlordPages/AccountDetails.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Notification.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Home.dart';
import 'package:api_com/UpdatedApp/Accomate%20pages/Functions.dart';
import 'package:api_com/UpdatedApp/Sign-Page/login_page.dart';
import 'package:api_com/UpdatedApp/StudentPages/SettingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:badges/badges.dart' as badges;

class LandlordPage extends StatefulWidget {
  const LandlordPage({super.key});

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
  TextEditingController messageController = TextEditingController();

  void loadUser() {
    if (_user?.uid == null) {
      showDialog(
        context: context,
        builder: (context) => Container(
          height: 250,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              'Guest User',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                        color: Colors.red[400],
                        width: 80,
                        height: 80,
                        child: Center(
                          child: Text(
                            'x',
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        )),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'To apply for this Residence you need to sign in with an existing account otherwise you can sign up.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Sign-in'),
              ),
            ],
          ),
        ),
      );
    }
  }

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
      barrierDismissible: false,
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
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
                  Navigator.of(context).pop();
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
        context: context,
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
    AccountDetails(),
    SettingPage(),
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

  final TermsAndConditions termsAndConditions = TermsAndConditions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: Text('Welcome to Accomate'),
        centerTitle: false,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (MediaQuery.of(context).size.width > 830) {
      return Row(
        children: [
          SidebarX(
            controller: SidebarXController(selectedIndex: _currentIndex),
            showToggleButton: false,
            theme: SidebarXTheme(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              textStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
              itemTextPadding: EdgeInsets.all(8),
              selectedItemTextPadding: EdgeInsets.all(8),
              selectedItemDecoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              iconTheme: IconThemeData(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.white),
            ),
            extendedTheme: SidebarXTheme(
              width: 200,
              textStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
              itemTextPadding: EdgeInsets.all(8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              selectedItemTextPadding: EdgeInsets.all(8),
              selectedItemDecoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            footerBuilder: (context, extended) {
              return Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.white,
                  onPressed: () => _user?.uid != null
                      ? termsAndConditions.showLogoutConfirmationDialog(context)
                      : Navigator.pushReplacementNamed(context, '/login'),
                ),
              );
            },
            items: [
              SidebarXItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              SidebarXItem(
                iconWidget: badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -12, end: -12),
                  showBadge: _notificationCount > 0,
                  badgeContent: Text(
                    '$_notificationCount',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
                label: 'Notifications',
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              SidebarXItem(
                icon: Icons.person,
                label: 'Account Details',
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
              SidebarXItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: screens[_currentIndex],
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
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconBadge(
                icon: Icon(Icons.notifications_active_outlined),
                itemCount: _notificationCount,
              ),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Me',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    }
  }
}
