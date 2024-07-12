// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:api_com/UpdatedApp/StudentPages/accomodation_page.dart';
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
                searchName = value
                    .toLowerCase(); // Convert the search input to lowercase
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
              // .where('accomodationStatus', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                children: [
                  Center(
                    child: Lottie.network(
                      'https://lottie.host/63272c20-431d-45d1-ade1-401d93fd8a81/4MIrc3WqN4.json', // Replace this with the path to your animation JSON file
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Center(
                      child: Text(
                    'One Moment',
                    style: TextStyle(fontSize: 24),
                  ))
                ],
              );
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

            var filteredDocs = snapshot.data!.docs.where((doc) {
              var data = doc.data() as Map<String, dynamic>;
              var accomodationName =
                  data['accomodationName']?.toLowerCase() ?? '';
              return accomodationName.contains(searchName);
            }).toList();

            return Container(
              color: Colors.blue[100],
              child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index];
                    var landlordData = data.data() as Map<String, dynamic>;
                    return landlordData['accomodationStatus'] == true
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5.0, left: 10, right: 10, top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue)),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccomodationPage(
                                                      landlordData:
                                                          landlordData)),
                                        );
                                      },
                                      trailing:
                                          Icon(Icons.arrow_forward_rounded),
                                      leading: CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                            data['profilePicture']),
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          children: highlightOccurrences(
                                              data['accomodationName'],
                                              searchName),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        data['email'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container();
                  }),
            );
          }),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    String lowerSource = source.toLowerCase();
    String lowerQuery = query.toLowerCase();

    int start = 0;
    while (start < lowerSource.length) {
      final match = lowerSource.indexOf(lowerQuery, start);
      if (match == -1) break;
      matches.add(Match(start: match, end: match + lowerQuery.length));
      start = match + lowerQuery.length;
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }

    var spans = <TextSpan>[];
    int lastMatchEnd = 0;
    for (var match in matches) {
      if (lastMatchEnd < match.start) {
        spans.add(TextSpan(text: source.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
          text: source.substring(match.start, match.end),
          style: TextStyle(fontWeight: FontWeight.bold)));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < source.length) {
      spans.add(TextSpan(text: source.substring(lastMatchEnd)));
    }

    return spans;
  }
}

class Match {
  final int start;
  final int end;

  Match({required this.start, required this.end});
}
