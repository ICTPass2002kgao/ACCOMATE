// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last, use_function_type_syntax_for_parameters, use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:api_com/UpdatedApp/StudentPages/HomePage.dart';
import 'package:api_com/UpdatedApp/StudentPages/MessagesPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/NotificationPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
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

  int _index = 0;


  late User _user;
  Map<String, dynamic>? _userData; // Make _userData nullable

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text("Welcome ${_userData?['name'] ?? 'Loading'}"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            unselectedItemColor: Colors.white54,
            selectedItemColor: Colors.white,
            onTap: (value) {
              setState(() {
                _index = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.notifications_active_outlined,
                ),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.message_outlined,
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.blue,
                icon: Icon(
                  Icons.person_outlined,
                ),
                label: 'Personal account',
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
                  onTap: () {},
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text('More Info'),
                  onTap: () {},
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
        body: _buildBody());
  }

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return HomePage();
      case 1:
        return NotificationPage();
      case 2:
        return MessagesPage();
      case 3:
        return PersonalPage();
      default:
        return Container(); // Handle other cases if needed
    }
  }
}

class _DataSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> landlordsData;

  _DataSearch(this.landlordsData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        color: Colors.black,
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredLandlords = landlordsData.where((landlord) {
      final accommodationName =
          landlord['accommodationName']?.toLowerCase() ?? '';
      return accommodationName.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredLandlords.length,
      itemBuilder: (context, index) {
        final landlordData = filteredLandlords[index];
        return ListTile(
          title: Text(
            landlordData['accommodationName'] ?? '',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            // Handle the selected search result
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccomodationPage(
                  landlordData: landlordData,
                ),
              ),
            );
            close(context, landlordData['accommodationName'] ?? '');
          },
        );
      },
    );
  }
}
