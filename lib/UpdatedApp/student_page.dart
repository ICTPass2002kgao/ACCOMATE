// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last, use_function_type_syntax_for_parameters, use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:api_com/UpdatedApp/StudentPages/HomePage.dart';
import 'package:api_com/UpdatedApp/StudentPages/MessagesPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/NotificationPage.dart';
import 'package:api_com/UpdatedApp/StudentPages/PeersonalPage.dart';
import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        .collection('users')
        .doc(_user.uid)
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
      String studentUserId = _user.uid;
      String helpCenterId = '3MdElZpzxgbOFJMqgkt32NnQ4UQ2';
      await FirebaseFirestore.instance
          .collection('users')
          .doc(helpCenterId)
          .collection('studentHelpMessage')
          .doc(studentUserId)
          .set({
        'message': messageController.text,
        'userId': studentUserId,
        'email': _userData?['email'],
        'name': _userData?['name'],
        'surname': _userData?['surname'],
      });
      sendEmail(
          'accomatehelpcenter@gmail.com', // Student's email
          'Reported Issue',
          'Goodday Accomate help center officer,\nYou have a there is an issue reported by ${_userData?['surname']} ${_userData?['name']}.Please try by all means to assist our user.\n\n\n\n\n\n\n\n\n\n\n\nBest Regards\nYours Accomate');

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

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Hi ${_userData?['name'] ?? 'Loading'}'),
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
                              actions: [
                                OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.blue),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      side: MaterialStatePropertyAll(
                                          BorderSide(width: 2))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Okay'),
                                )
                              ],
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
