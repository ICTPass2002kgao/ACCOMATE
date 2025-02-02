// import 'package:api_com/UpdatedApp/CreateAnAccount.dart';
// import 'package:api_com/UpdatedApp/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_swiper_view/flutter_swiper_view.dart';
// import 'package:lottie/lottie.dart';

// class StartPage extends StatefulWidget {
//   const StartPage({Key? key}) : super(key: key);

//   @override
//   State<StartPage> createState() => _StartPageState();
// }

// class _StartPageState extends State<StartPage>
//     with AutomaticKeepAliveClientMixin<StartPage> {
//   final List<String> images = [
//     'https://lottie.host/d7aac53c-6640-47b7-8f42-6581408ba1c7/LASbeQEhrY.json',
//   ];

//   int currentImage = 0;
//   String selectedRole = '';
//   List<String> gender = [
//     'Landlord',
//     'Student',
//     'Guest User',
//     'Admin',
//     'Create new Account'
//   ];

//   @override
//   bool get wantKeepAlive => true;

//   bool isLoading = true;
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     await Future.delayed(Duration(seconds: 4));
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) {
//           SystemNavigator.pop();
//         },
//         child: Scaffold(
//           backgroundColor: Colors.blue[100],
//           appBar: AppBar(
//             title: Text("Welcome to Accomate"),
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//             centerTitle: true,
//             automaticallyImplyLeading: false,
//           ),
//           body: isLoading
//               ? Center(
//                   child: Container(
//                     width: 100,
//                     height: 100,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Center(child: Text("Loading...")),
//                           Center(
//                               child:
//                                   LinearProgressIndicator(color: Colors.blue)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               : MediaQuery.of(context).size.width < 768
//                   ? SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 300,
//                             child: Swiper(
//                               duration: Duration.secondsPerHour,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Lottie.network(
//                                   images[index],
//                                   fit: BoxFit.cover,
//                                 );
//                               },
//                               itemCount: images.length,
//                               pagination: SwiperPagination(
//                                   builder: SwiperPagination.dots),
//                               autoplay: false,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Builder(builder: (context) {
//                               return ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           width: 2, color: Colors.blue)),
//                                   child: ExpansionTile(
//                                     title: Text('Sign-in with your Role',
//                                         style: TextStyle(color: Colors.blue)),
//                                     children: gender.map((paramRole) {
//                                       return RadioListTile<String>(
//                                         activeColor: Colors.blue,
//                                         title: Text(
//                                           paramRole,
//                                           style: TextStyle(color: Colors.blue),
//                                         ),
//                                         value: paramRole,
//                                         groupValue: selectedRole,
//                                         onChanged: (value) async {
//                                           setState(() {
//                                             selectedRole = value!;
//                                           });

//                                           if (selectedRole ==
//                                               'Create new Account') {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         RegistrationOption()));
//                                           } else if (selectedRole ==
//                                               'Guest User') {
//                                             await FirebaseAuth.instance
//                                                 .signOut();
//                                             Navigator.pushReplacementNamed(
//                                                 context, '/studentPage');
//                                           } else {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         LoginPage(
//                                                             guest: false,
//                                                             userRole:
//                                                                 selectedRole)));
//                                           }
//                                         },
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               );
//                             }),
//                           )
//                         ],
//                       ),
//                     )
//                   : Expanded(
//                       child: SingleChildScrollView(
//                         child: Row(children: [
//                           Expanded(
//                               child: Center(
//                             child: Lottie.network(
//                               'https://lottie.host/d7aac53c-6640-47b7-8f42-6581408ba1c7/LASbeQEhrY.json',
//                               width: 300,
//                               height: 300,
//                               fit: BoxFit.cover,
//                             ),
//                           )),
//                           Expanded(
//                             child: Container(
//                               color: Colors.blue[200],
//                               child: Column(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(100),
//                                     child: Image.asset(
//                                       'assets/icon.jpg',
//                                       width: 200,
//                                       height: 200,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         border: Border.all(
//                                             width: 2, color: Colors.blue)),
//                                     child: ExpansionTile(
//                                       title: Text('Sign-in with your Role',
//                                           style: TextStyle(color: Colors.blue)),
//                                       children: gender.map((paramRole) {
//                                         return RadioListTile<String>(
//                                           activeColor: Colors.blue,
//                                           title: Text(
//                                             paramRole,
//                                             style:
//                                                 TextStyle(color: Colors.blue),
//                                           ),
//                                           value: paramRole,
//                                           groupValue: selectedRole,
//                                           onChanged: (value) async {
//                                             setState(() {
//                                               selectedRole = value!;
//                                             });

//                                             if (selectedRole ==
//                                                 'Create new Account') {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           RegistrationOption()));
//                                             } else if (selectedRole ==
//                                                 'Guest User') {
//                                               await FirebaseAuth.instance
//                                                   .signOut();
//                                               Navigator.pushReplacementNamed(
//                                                   context, '/studentPage');
//                                             } else {
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           LoginPage(
//                                                               guest: false,
//                                                               userRole:
//                                                                   selectedRole)));
//                                             }
//                                           },
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//         ));
//   }
// }
