// import 'package:animated_card/animated_card.dart';
// import 'package:animated_card/animated_card_direction.dart';
// import 'package:api_com/UpdatedApp/Accomate%20pages/Functions.dart';
// import 'package:api_com/UpdatedApp/Sign-Page/login_page.dart';
import 'package:api_com/UpdatedApp/Accomate%20pages/Functions.dart';
import 'package:api_com/UpdatedApp/StudentPages/HomePage.dart';
import 'package:api_com/UpdatedApp/StudentPages/NotificationPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/Search-Class.dart';
import 'package:api_com/UpdatedApp/StudentPages/SettingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:badges/badges.dart' as badges;

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController messageController = TextEditingController();
  TermsAndConditions termsAndConditions = TermsAndConditions();

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    loadData();
    _loadUserData();
    _loadNotificationCount();
  }

  late User? _user;
  Map<String, dynamic>? _userData;

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
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
              'Unsuccessful Response',
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

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    _loadUserData();
  }

  void _onNotificationOpened() {
    _loadNotificationCount();
  }

  int _notificationCount = 0;

  Future<void> _loadNotificationCount() async {
    QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .collection('applicationsResponse')
        .where('read', isEqualTo: false)
        .get();
    setState(() {
      _notificationCount = applicationsSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double buttonWidth =
    //     MediaQuery.of(context).size.width < 550 ? double.infinity : 500;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: Text('Hello ${_userData?['name'] ?? 'there!'}'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: SearchView(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 550) {
            return _buildSmallScreen();
          } else {
            return _buildLargeScreen();
          }
        },
      ),
    );
  }

  Widget _buildSmallScreen() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        backgroundColor: Colors.blue,
        useLegacyColorScheme: false,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconBadge(
              icon: Icon(Icons.notifications_none),
              itemCount: _notificationCount,
            ),
            label: 'Notifications',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(),
          NotificationPage(
            onNotificationOpened: _onNotificationOpened,
          ),
          PersonalPage(),
          SettingPage()
        ],
      ),
    );
  }

  Widget _buildLargeScreen() {
    return Scaffold(
      body: Row(
        children: [
          SidebarX(
            controller: SidebarXController(selectedIndex: _index),
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
              width: 300, textStyle: TextStyle(color: Colors.white),
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
              iconTheme: IconThemeData(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.white),
              // extendIconTheme: IconThemeData(color: Colors.white),
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
                    _index = 0;
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
                    _index = 1;
                  });
                },
              ),
              SidebarXItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () {
                  setState(() {
                    _index = 2;
                  });
                },
              ),
              SidebarXItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {
                  setState(() {
                    _index = 3;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                HomePage(),
                NotificationPage(
                  onNotificationOpened: _onNotificationOpened,
                ),
                PersonalPage(),
                SettingPage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
