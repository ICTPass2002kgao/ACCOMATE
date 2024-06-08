// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchView extends StatefulWidget {
  SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  var searchName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Colors.blue[100],
                hintText: 'Search for residence',
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Landlords')
              .orderBy('accomodationName')
              .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/63272c20-431d-45d1-ade1-401d93fd8a81/4MIrc3WqN4.json', // Replace this with the path to your animation JSON file
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Center(
                        child: Text(
                      'One Moment',
                      style: TextStyle(fontSize: 24),
                    ))
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Container(
                  color: Colors.blue[100],
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.network(
                            'https://lottie.host/4f43b42d-3e11-4aaf-b07e-c3352b086a45/9QoklefHek.json',
                            width: 200,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Center(
                            child: Text(
                          'Could not find that Residence',
                          style: TextStyle(fontSize: 24),
                        ))
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.blue[100],
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    var landlordData = data.data() as Map<String, dynamic>;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5.0, left: 10, right: 10, top: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccomodationPage(
                                        landlordData: landlordData)),
                              );
                            },
                            trailing: Icon(Icons.arrow_forward_rounded),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage:
                                  NetworkImage(data['profilePicture']),
                            ),
                            title: Text(data['accomodationName']),
                            subtitle: Text(
                              data['email'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
