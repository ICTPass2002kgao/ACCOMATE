// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:api_com/Accomodation_card.dart';
import 'package:api_com/UpdatedApp/accomodation_page.dart';
import 'package:api_com/advanced_details.dart';
import 'package:api_com/global_variables.dart';
import 'package:api_com/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final details = residencesCard;
int isSelected = 0;

class _HomePageState extends State<HomePage> {
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
    var residenceList = Provider.of<ResData>(context).residences;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('accommodations')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Loading indicator while data is loading
              }

              List<Accommodation> accommodations =
                  snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return Accommodation(
                  name: data['name'],
                  location: data['location'],
                  images: List<String>.from(data['images']),
                  residenceDetails: data['residenceDetails'],
                );
              }).toList();

              return ListView.builder(
                itemCount: accommodations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transport Accomodations',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display the first image
                                          // accommodations[index].images.isNotEmpty
                                          //     ? Image.network(
                                          //         accommodations[index].images[0])
                                          //     : SizedBox.shrink(),
                                          Image.asset('assets/taung.jpeg'),
                                          Row(
                                            children: [
                                              Text(accommodations[index].name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Icon(Icons.verified,
                                                  color: Colors.blue[900],
                                                  size: 15),
                                            ],
                                          ),
                                          Text(
                                            'Available Now',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Display the first image
                                          accommodations[index]
                                                  .images
                                                  .isNotEmpty
                                              ? Image.network(
                                                  accommodations[index]
                                                      .images[0])
                                              : SizedBox.shrink(),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(accommodations[index].name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Icon(Icons.verified,
                                                  color: Colors.blue[900],
                                                  size: 15),
                                            ],
                                          ),
                                          Text(
                                            'Available Now',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Display the first image
                                          // accommodations[index].images.isNotEmpty
                                          //     ? Image.network(
                                          //         accommodations[index].images[0])
                                          //     : SizedBox.shrink(),
                                          Image.asset('assets/taung.jpeg'),
                                          Row(
                                            children: [
                                              Text(accommodations[index].name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Icon(Icons.verified,
                                                  color: Colors.blue[900],
                                                  size: 15),
                                            ],
                                          ),
                                          Text(
                                            'Available Now',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  );
                },
              );
            },
          );
  }
}

              // List<Accommodation> accommodations =
              //     snapshot.data!.docs.map((doc) {
              //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              //   ListView.builder(
              //     itemCount: accommodations.length,
              //     itemBuilder: (context, index) {
              //       return Card(
              //         child: Column(
              //           children: [
              //             // Display the first image
              //             accommodations[index].images.isNotEmpty
              //                 ? Image.network(accommodations[index].images[0])
              //                 : SizedBox.shrink(),
              //             ListTile(
              //               title: Text(accommodations[index].name),
              //               subtitle: Text(accommodations[index].location),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(accommodations[index].residenceDetails),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   );
              // });
            
// Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Transport Accomodations',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: residenceList.map((residence) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               AccomodationPage(residence: residence),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 300,
//                       height: 200,
//                       decoration: BoxDecoration(
//                           color: Color.fromARGB(179, 231, 228, 228),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Center(
//                                     child:
//                                         Image.network(residence.images.first))),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   residence.name,
//                                   style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Icon(
//                                   Icons.verified,
//                                   color: Colors.blue[900],
//                                   size: 15,
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'Available Now',
//                               style: TextStyle(color: Colors.green),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'No-Transport Accomodations',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               height: 300,
//               width: double.infinity,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: details.length,
//                   itemBuilder: (context, index) {
//                     final accomodationData = details[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) {
//                           return Text('hi');
//                         }));
//                       },
//                       child: AccomodationCard(
//                           accomodationName: accomodationData['name'] as String,
//                           imagePath: accomodationData['imagePath'] as String),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
