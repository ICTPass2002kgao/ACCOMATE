import 'package:animated_card/animated_card.dart';
import 'package:api_com/UpdatedApp/StudentPages/ViewApplicationResponses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends StatefulWidget {
  final Function onNotificationOpened;

  const NotificationPage({Key? key, required this.onNotificationOpened})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late User? _user;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _studentApplications = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadUserData();
    loadData();
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
        .collection('Students')
        .doc(_user?.uid)
        .get();
    setState(() {
      _userData = userDataSnapshot.data() as Map<String, dynamic>?;
    });
    await _loadStudentApplications();
  }

  Future<void> _loadStudentApplications() async {
    try {
      String studentUserId = _userData?['userId'] ?? '';

      QuerySnapshot applicationsSnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .doc(studentUserId)
          .collection('applicationsResponse')
          .get();

      List<Map<String, dynamic>> studentApplications = [];

      for (QueryDocumentSnapshot documentSnapshot
          in applicationsSnapshot.docs) {
        Map<String, dynamic> applicationData =
            documentSnapshot.data() as Map<String, dynamic>;
        studentApplications.add({
          ...applicationData,
          'documentId': documentSnapshot.id,
        });
      }

      setState(() {
        _studentApplications = studentApplications;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading student applications: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await _loadStudentApplications();
    _refreshController.refreshCompleted();
  }

  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _markNotificationAsRead(String documentId) async {
    try {
      String studentUserId = _userData?['userId'] ?? '';
      for (int index = 0; index < _studentApplications.length; index++) {
        await FirebaseFirestore.instance
            .collection('Students')
            .doc(studentUserId)
            .collection('applicationsResponse')
            .doc(_studentApplications[index]['userId'])
            .update({'read': true});
      }

      widget.onNotificationOpened();
      _loadStudentApplications();
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
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _handleRefresh,
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.blue,
        ),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Container(
                      width: 100,
                      height: 100,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: Text("Loading...")),
                          Center(
                              child:
                                  LinearProgressIndicator(color: Colors.blue)),
                        ],
                      ))))
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12, top: 10),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: isLargeScreen
                                ? Colors.blue
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      width: containerWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
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
                            if (_studentApplications.isEmpty)
                              Center(
                                  child: Text(
                                'No Notification',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            for (int index = 0;
                                index < _studentApplications.length;
                                index++)
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: AnimatedCard(
                                  direction: AnimatedCardDirection.top,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: Column(
                                      children: [
                                        _studentApplications.isEmpty
                                            ? Center(
                                                child: Text(
                                                'No Notification',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                            : ListTile(
                                                onTap: () {
                                                  _markNotificationAsRead(
                                                      _studentApplications[
                                                          index]['documentId']);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewApplicationResponses(
                                                        studentApplicationData:
                                                            _studentApplications[
                                                                index],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                title: Text(
                                                  '${_studentApplications[index]['accomodationName']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight:
                                                        _studentApplications[
                                                                        index]
                                                                    ['read'] ==
                                                                true
                                                            ? FontWeight.normal
                                                            : FontWeight.w900,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _studentApplications[
                                                                      index]
                                                                  ['status'] ==
                                                              true
                                                          ? 'Hi ${_userData?['name'] ?? ''}, your application from ${_studentApplications[index]['accomodationName']} was successfully approved'
                                                          : 'Hi ${_userData?['name'] ?? ''}, we regret to inform you that your application from ${_studentApplications[index]['accomodationName']} was Unsuccessful',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            _studentApplications[
                                                                            index]
                                                                        [
                                                                        'read'] ==
                                                                    true
                                                                ? FontWeight
                                                                    .normal
                                                                : FontWeight
                                                                    .w900,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat(
                                                              'yyyy-MM-dd HH:mm')
                                                          .format(_studentApplications[
                                                                      index][
                                                                  'feedbackDate']
                                                              .toDate()),
                                                      style: TextStyle(
                                                          fontWeight: _studentApplications[
                                                                          index]
                                                                      [
                                                                      'read'] ==
                                                                  true
                                                              ? FontWeight
                                                                  .normal
                                                              : FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
