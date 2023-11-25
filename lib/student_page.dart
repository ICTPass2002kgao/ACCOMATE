// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last, use_function_type_syntax_for_parameters

import 'package:api_com/Pages/HomePage.dart';
import 'package:api_com/Pages/MessagesPage.dart';
import 'package:api_com/Pages/NotificationPage.dart';
import 'package:api_com/Pages/PeersonalPage.dart';
import 'package:api_com/advanced_details.dart';
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
          backgroundColor: Colors.white,
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Icon(Icons.warning_outlined, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Text('Are you sure you want to logout?'),
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
                // Perform logout logic here
                // ...

                Navigator.of(context).pop(); // Close the dialog
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));

                // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  int _index = 0;
  List screens = [
    HomePage(),
    MessagesPage(),
    NotificationPage(),
    PersonalPage()
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));

    // Set isLoading to false when data is loaded
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Hi Student'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchDelegateWidget());
              },
              icon: Icon(Icons.search_rounded))
        ],
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
              icon: Icon(Icons.home_outlined, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.notifications_active_outlined, size: 30),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.message_outlined, size: 30),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.person_outlined,
                size: 30,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('accommodations')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator(); // Loading indicator while data is loading
                }

                List<Accommodation> accommodations =
                    snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Accommodation(
                    name: data['name'],
                    location: data['location'],
                    images: List<String>.from(data['images']),
                    residenceDetails: data['residenceDetails'],
                  );
                }).toList();
                return screens[_index];
              },
            ),
    );
  }
}

class SearchDelegateWidget extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    // Customize the search box color
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.blue,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }

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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Handle search results
    return Center(
      child: Text('Search Results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions as the user types
    return Center(
      child: Text('Suggestions for: $query'),
    );
  }
}
