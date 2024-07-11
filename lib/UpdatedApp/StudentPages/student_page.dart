// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last, use_function_type_syntax_for_parameters, use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:api_com/UpdatedApp/StudentPages/ChatPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/HomePage.dart';
import 'package:api_com/UpdatedApp/StudentPages/HomePage2.dart';
import 'package:api_com/UpdatedApp/StudentPages/NotificationPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/Search-Class.dart';
import 'package:api_com/UpdatedApp/Terms&Conditions.dart';
import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  TextEditingController messageController = TextEditingController();
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
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 50))),
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
      String studentUserId = _user!.uid;
      String helpCenterId = 'dWKl2xV0gggWQyQycWm52lS3Hpk1';
      await FirebaseFirestore.instance
          .collection('Help Team')
          .doc(helpCenterId)
          .collection('studentHelpMessage')
          .doc(studentUserId)
          .set({
        'message': messageController.text,
        'userId': studentUserId,
        'email': _userData?['email'] ?? '',
        'name': _userData?['name'] ?? '',
        'surname': _userData?['surname'] ?? '',
      });
      sendEmail(
          'accomatehelpcenter@gmail.com', // help center's email
          'Reported Issue',
          'Goodday Accomate help center officer,\nYou have a there is an issue reported by ${_userData?['surname'] ?? ''} ${_userData?['name'] ?? ''}. \nUser\'s Issue:\n${messageController.text}\n\n\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

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
                        Navigator.pushReplacementNamed(context, '/studentPage');
                      },
                      child: Text('Done'),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green),
                          minimumSize: MaterialStatePropertyAll(
                              Size(double.infinity, 50)))),
                ],
              ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    _loadUserData();
  }

  List<Map<String, dynamic>> _landlordsData = [];

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

  void _onNotificationOpened() {
    _loadNotificationCount();
  }

  Future<void> _handleRefresh() async {
    await _loadLandlordData();
    await _loadUserData();
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController = RefreshController();

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
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Welcome ${_userData?['name'] ?? 'there!'}'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchView()),
                );
              },
            ),
          ],
        ),
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
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
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
                      label: 'Notificationns',
                    ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.mail_outline_outlined,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.person_outlined,
                ),
                label: 'Me',
              )
            ]),
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
                                                      'The your issue cannot be resolved'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Okay'),
                                                        style: ButtonStyle(
                                                            shape: MaterialStatePropertyAll(
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
                  title: Text(_user?.uid != null ? 'Logout' : 'Go to login'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _user?.uid != null
                        ? _showLogoutConfirmationDialog(context)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(
                                    userRole: 'Student', guest: false)));
                  },
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SmartRefresher(
            controller: _refreshController,
            onRefresh: _handleRefresh,
            header: WaterDropMaterialHeader(
              backgroundColor: Colors.blue,
            ),
            child: _buildBody()));
  }

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return HomePage();
      case 1:
        return NotificationPage(onNotificationOpened: _onNotificationOpened);
      case 2:
        return Chatpage();
      case 3:
        return PersonalPage();
      default:
        return Container();
    }
  }
}
