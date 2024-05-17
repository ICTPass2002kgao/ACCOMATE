import 'package:api_com/UpdatedApp/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}
/**    'https://lottie.host/d7aac53c-6640-47b7-8f42-6581408ba1c7/LASbeQEhrY.json',
    'assets/icon1.jpg',
    'assets/icon2.jpg',
    'assets/icon3.jpg',
    'assets/icon4.jpg',
    'https://lottie.host/c25aedf9-7b5d-4852-8677-f079d5445808/SOhXthR1lW.json' */

class _StartPageState extends State<StartPage> {
  final List<String> images = [
    'assets/icon.jpg',
    'assets/app_icon.jpg',
    'assets/icon1.jpg',
    'assets/icon3.jpg',
    'assets/icon2.jpg',
    'assets/icon4.jpg',
  ];

  int currentImage = 0;
  String selectedRole = '';
  List<String> gender = ['Landlord', 'Student', 'Admin', 'Create new Account'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Accomate"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.blue[100],
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 300,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.Asset(
                      images[index],
                      fit: BoxFit.cover,
                    );
                  },
                  itemCount: images.length,
                  pagination: SwiperPagination(builder: SwiperPagination.rect),
                  autoplay: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Builder(builder: (context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.blue)),
                      child: ExpansionTile(
                        title: Text('Sign-in with your Role',
                            style: TextStyle(color: Colors.blue)),
                        children: gender.map((paramRole) {
                          return RadioListTile<String>(
                            activeColor: Colors.blue,
                            title: Text(
                              paramRole,
                              style: TextStyle(color: Colors.blue),
                            ),
                            value: paramRole,
                            groupValue: selectedRole,
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value!;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(userRole: selectedRole)));
                              if (selectedRole == 'Create new Account')
                                Navigator.pushReplacementNamed(
                                    context, '/CreateAccountPage');
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              )
            ]),
          ),
        ));
  }
}
