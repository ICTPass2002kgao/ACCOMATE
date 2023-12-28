// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_final_fields

import 'package:api_com/LandlordDetails/LandlordRegistration.dart';
import 'package:api_com/UpdatedApp/LandlordPages/AccountDetails.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Notification.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Home.dart';
import 'package:api_com/UpdatedApp/LandlordPages/Messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandlordPage extends StatefulWidget {
  const LandlordPage({super.key});

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Logout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  // void openRegistrationPage() {
  //   setState(() {
  //     Navigator.push(context,
  //         MaterialPageRoute(builder: ((context) => LandlordRegistration())));
  //     print('add details');
  //   });
  // }

  int _currentIndex = 0;
  List screens = [HomePage(), Notifications(), Messages(), AccountDetails()];

  List<int> _badgeValues = [10, 0, 10, 99];

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
                    Icons.mail, 'Messages', _badgeValues[2]),
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
          items: [
            _buildBottomNavigatorBar('Home', Icons.home),
            _buildBottomNavigatorBar(
                'Notification', Icons.notifications_active),
            _buildBottomNavigatorBar('Messages', Icons.mail),
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
