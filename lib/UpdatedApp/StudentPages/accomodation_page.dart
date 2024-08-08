// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks

import 'package:animate_ease/animate_ease.dart';  
import 'package:api_com/UpdatedApp/Sign-Page/login_page.dart';
import 'package:api_com/UpdatedApp/StudentPages/Apply-Accomodation.dart';
import 'package:api_com/UpdatedApp/Sign-up-Pages/either_landlord_or_student.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart'; 
import 'package:url_launcher/url_launcher.dart';

class AccomodationPage extends StatefulWidget {
  final Map<String, dynamic> landlordData;
  const AccomodationPage({
    super.key,
    required this.landlordData,
  });

  @override
  State<AccomodationPage> createState() => _AccomodationPageState();
}

class _AccomodationPageState extends State<AccomodationPage> {
  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  late User? _user;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    loadData();
  }

  bool isLoading = true;
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width < 550 ? double.infinity : 500;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.landlordData['accomodationName'] ?? '',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor:
            widget.landlordData['isFull'] == true ? Colors.red : Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: Colors.blue[100],
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Container(
                width: buttonWidth,
                child: AnimateEase(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return CachedNetworkImage(
                             imageUrl: widget.landlordData['displayedImages'][index],
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount:
                              widget.landlordData['displayedImages'].length,
                          pagination: SwiperPagination(
                              margin: EdgeInsets.all(5),
                              builder: SwiperPagination.rect),
                          control: SwiperControl(
                              size: 20,
                              color: Colors.blue,
                              iconNext: Icons.navigate_next_outlined,
                              iconPrevious: Icons.navigate_before_rounded),
                          autoplay: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                widget.landlordData['accomodationName'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      String address =
                                          widget.landlordData['location'] ??
                                              '';
                                      Uri googleMapsUrl = Uri.parse(
                                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
                                      _launchURL(googleMapsUrl);
                                    },
                                    child: Text(
                                      "${widget.landlordData['location'] ?? 'Loading...'}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.social_distance,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 2),
                                Text(widget.landlordData['distance'] ??
                                    'Loading...'),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text('For more information contact us via:'),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue,
                                  size: 14,
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    String email =
                                        widget.landlordData['email'] ?? '';
                                    Uri mailtoUrl =
                                        Uri(scheme: 'mailto', path: email);
                                    _launchURL(mailtoUrl);
                                  },
                                  child: Text(
                                    widget.landlordData['email'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.call,
                                  size: 14,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 2),
                                GestureDetector(
                                  onTap: () {
                                    String phone = widget
                                            .landlordData['contactDetails'] ??
                                        '';
                                    Uri telUrl =
                                        Uri(scheme: 'tel', path: phone);
                                    _launchURL(telUrl);
                                  },
                                  child: Text(
                                    widget.landlordData['contactDetails'] ??
                                        '',
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text('Accommodated institutions',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            for (String university in widget
                                .landlordData['selectedUniversity'].keys)
                              if (widget.landlordData['selectedUniversity']
                                      ?[university] ??
                                  false)
                                Text('$university'),
                            SizedBox(height: 5),
                            Text('Accomodate Period Allowed: ',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              widget.landlordData['Duration'] ==
                                          "Half Year" &&
                                      widget.landlordData['Duration'] ==
                                          "Half Year"
                                  ? 'Both 6 months and full year'
                                  : 'Full year Only',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                widget.landlordData['isFull'] == true
                                    ? Text(
                                        'Accomodation is full due to space',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      )
                                    : Text(
                                        'Apply as soon as possible to secure your space',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                widget.landlordData['isFull'] == true
                                    ? Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        color: Colors.red,
                                      )
                                    : Icon(
                                        Icons
                                            .sentiment_very_satisfied_outlined,
                                        color: Colors.green,
                                      )
                              ],
                            ),
                            Text(
                              widget.landlordData['requireDeposit'] == true
                                  ? 'Requires Deposit fee for registration.'
                                  : 'Residence is free to apply and register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      widget.landlordData['requireDeposit'] ==
                                              true
                                          ? Colors.yellow[700]
                                          : Colors.green[400]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.landlordData['isNsfasAccredited'] == true
                                  ? 'NSFAS ACCREDITED'
                                  : 'NOT ACCREDITED BY NSFAS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.landlordData[
                                              'isNsfasAccredited'] ==
                                          false
                                      ? Colors.red
                                      : Colors.green[400]),
                            ),
                            SizedBox(height: 5),
                            ExpansionTile(
                              title: Text('More details',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              children: [
                                ListTile(
                                  title: Text('Offered amities',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                for (String offers in widget
                                    .landlordData['selectedOffers'].keys)
                                  if (widget.landlordData['selectedOffers']
                                          ?[offers] ??
                                      false)
                                    ListTile(
                                      title: Text(offers),
                                    ),
                                SizedBox(height: 5),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_user?.uid == null) {
                              widget.landlordData['isFull'] == true
                                  ? _fullAccomodation(context)
                                  : showDialog(
                                      context: context,
                                      builder: (context) => Container(
                                        height: 250,
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          title: Text(
                                            'Guest User',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Container(
                                            height: 200,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Container(
                                                      color: Colors.red[400],
                                                      width: 80,
                                                      height: 80,
                                                      child: Center(
                                                        child: Text(
                                                          'x',
                                                          style: TextStyle(
                                                              fontSize: 40,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  'To apply for this Residence you need to sign in with an existing account otherwise you can sign up.',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            StudentOrLandlord(
                                                                isLandlord:
                                                                    false,
                                                                guest: true)));
                                              },
                                              child: Text('Sign-up'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage()));
                                              },
                                              child: Text('Sign-in'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplyAccomodation(
                                    landlordData: widget.landlordData,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text('Apply Accommodation'),
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.white),
                              minimumSize: WidgetStateProperty.all(
                                  Size(buttonWidth, 50))),
                        ),
                      ),
                      SizedBox(height: 50),
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

void _fullAccomodation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Container(
      height: 250,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          'Application Response',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: 200,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  color: Colors.red[400],
                  width: 80,
                  height: 80,
                  child: Icon(Icons.cancel_outlined,
                      color: Colors.white, size: 35),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Please note that the residence is full. Try looking for another residence.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/studentPage');
            },
            child: Text('Okay'),
          ),
        ],
      ),
    ),
  );
}
 