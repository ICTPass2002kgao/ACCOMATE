import 'package:api_com/UpdatedApp/StudentPages/ViewApplicationResponses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
        studentApplications.add(applicationData);
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

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
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
                      for (int index = 0;
                          index < _studentApplications.length;
                          index++)
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewApplicationResponses(
                                                studentApplicationData:
                                                    _studentApplications[index],
                                              ),
                                            ),
                                          );
                                        },
                                        title: Text(
                                          '${_studentApplications[index]['accomodationName']}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _studentApplications[index]
                                                          ['status'] ==
                                                      true
                                                  ? 'Hi ${_userData?['name'] ?? ''}, your application from ${_studentApplications[index]['accomodationName']} was successfully approved'
                                                  : 'Hi ${_userData?['name'] ?? ''}, we regret to inform you that your application from ${_studentApplications[index]['accomodationName']} was Unsuccessful',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd HH:mm')
                                                  .format(_studentApplications[
                                                          index]['feedbackDate']
                                                      .toDate()),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.blue,
                                        ),
                                      ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
