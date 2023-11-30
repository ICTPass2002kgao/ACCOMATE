// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:api_com/UpdatedApp/accomodation_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    userFuture = _loadUserData();
  }

  late Future<DocumentSnapshot> userFuture;

  Future<DocumentSnapshot> _loadUserData() async {
    // Assuming you have a reference to the current user
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Retrieve user details from Firestore
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // Fetch the data from Firestore
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data found');
        } else {
          // Data has been loaded successfully
          return _buildStudentCards(snapshot.data!);
        }
      },
    );
  }

  Widget _buildStudentCards(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        QueryDocumentSnapshot document = documents[index];

        String accomodationName = document['accomodationName'] ?? 'No Name';
        String location = document['location'] ?? 'No Location';

        // Display the data in a card
        return FutureBuilder<String>(
          future: _getFirstImageUrl(document.reference),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String imageUrl = snapshot.data ?? '';
              return Card(
                child: Column(
                  children: [
                    // Display the first image
                    Image.network(imageUrl, height: 100, width: 100),

                    // Display accommodation name
                    Text('Accommodation Name: $accomodationName'),

                    // Display location
                    Text('Location: $location'),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<String> _getFirstImageUrl(DocumentReference documentReference) async {
    // Check if the 'images' subcollection exists
    QuerySnapshot imagesSnapshot =
        await documentReference.collection('urls').get();

    // Check if there are images in the 'images' subcollection
    if (imagesSnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot firstImageDocument = imagesSnapshot.docs[0];
      return firstImageDocument['url'] ?? '';
    } else {
      return ''; // Return an empty string if no images are found
    }
  }
}
