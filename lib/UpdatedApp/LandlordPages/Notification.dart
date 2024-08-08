import 'package:api_com/UpdatedApp/LandlordPages/viewApplicantDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Notifications extends StatefulWidget {
  final Function onNotificationOpened;
  const Notifications({super.key, required this.onNotificationOpened});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late User? _user;
  Map<String, dynamic>? _userData;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Landlords')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
      isLoading = false;
    });
  }

  Future<void> _markNotificationAsRead(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Landlords')
          .doc(_user?.uid)
          .collection('applications')
          .doc(documentId)
          .update({'read': true});

      widget.onNotificationOpened();
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 650;
    bool isLargeScreen = MediaQuery.of(context).size.width > 650;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isLargeScreen ? Colors.blue : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    width: containerWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Landlords')
                                .doc(_user?.uid)
                                .collection('applications')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Map<String, dynamic>> studentApplications =
                                    snapshot.data!.docs
                                        .map((doc) =>
                                            doc.data() as Map<String, dynamic>)
                                        .toList();

                                if (studentApplications.isEmpty) {
                                  return Center(
                                    child: Text(
                                      'No Notification',
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: studentApplications
                                      .map((application) => Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    border: Border.all(
                                                        color: Colors.blue)),
                                                child: ListTile(
                                                  onTap: () {
                                                    _markNotificationAsRead(
                                                        application['userId']);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewApplicantDetails(
                                                          studentApplicationData:
                                                              application,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  title: Text(
                                                    '${application['name'] ?? ''} ${application['surname'] ?? ''}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          application['read'] ==
                                                                  true
                                                              ? FontWeight
                                                                  .normal
                                                              : FontWeight.w900,
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'You have a new application from ${application['surname'] ?? ''} ${application['name'] ?? ''}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                application['read'] ==
                                                                        true
                                                                    ? FontWeight
                                                                        .normal
                                                                    : FontWeight
                                                                        .w600,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                'yyyy-MM-dd HH:mm')
                                                            .format(application[
                                                                    'appliedDate']
                                                                .toDate()),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Icon(
                                                    Icons.arrow_right,
                                                    size: 40,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              return Center(
                            child: ColorfulCircularProgressIndicator(
                          colors: [
                            Colors.blue,
                            Colors.red,
                            Colors.purple,
                            Colors.green,
                            Colors.grey
                          ],
                          strokeWidth: 5,
                          indicatorHeight: 40,
                          indicatorWidth: 40,
                        ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
