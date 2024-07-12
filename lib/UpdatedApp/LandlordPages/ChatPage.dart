import 'package:api_com/UpdatedApp/LandlordPages/Inboxpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Landlords')
            .doc(_user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> userData =
                snapshot.data?.data() as Map<String, dynamic>;
            String landlordId = userData['userId'] ?? '';

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Landlords')
                  .doc(landlordId)
                  .collection('signedContracts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, dynamic>> registeredStudents = snapshot
                      .data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_user == null)
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied_rounded,
                                  color: Colors.red,
                                  size: 150,
                                ),
                                SizedBox(height: 10),
                                Text('Oops user not found!\nTry to login.'),
                              ],
                            ),
                          ),
                        if (_user != null && registeredStudents.isEmpty)
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.sentiment_dissatisfied_rounded,
                                  color: Colors.red,
                                  size: 150,
                                ),
                                SizedBox(height: 10),
                                Text('Oops!! no registered student yet!.'),
                              ],
                            ),
                          ),
                        if (_user != null && registeredStudents.isNotEmpty)
                          for (int i = 0; i < registeredStudents.length; i++)
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Landlords')
                                  .doc(landlordId)
                                  .collection('Messages')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Map<String, dynamic>>
                                      registeredStudentsMessages = snapshot
                                          .data!.docs
                                          .map((doc) => doc.data()
                                              as Map<String, dynamic>)
                                          .toList();

                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InboxPage(
                                            studentsContracts:
                                                registeredStudents[i],
                                          ),
                                        ),
                                      );
                                    },
                                    title: Text(
                                        '${registeredStudents[i]['name'] ?? ''} ${registeredStudents[i]['surname'] ?? ''} '),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          'Open Message...',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.person_2_outlined,
                                        color: Colors.blue[50],
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    trailing: Icon(Icons.arrow_right_outlined),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
