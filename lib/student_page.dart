
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Hi Student'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.search_rounded))],

        
      ),
      bottomNavigationBar: BottomNavigationBar(
       
        fixedColor: Colors.white         ,
        onTap: (index) {
          setState(() {
            _index=index;
          });
        },
        currentIndex: _index,
        items: [BottomNavigationBarItem(
           backgroundColor: Colors.blue ,
          icon: Icon(Icons.home_outlined,size: 30),
          label: 'Home',
          
          ),BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active_outlined,size: 30),
          label: 'Notifications',
          
          ),BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined,size: 30),
          label: 'Messages',
          
          ),BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined,size: 30,),
          label: 'Personal account',
          
          )]),
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Icon(Icons.settings,
                  size: 100,
                  color:Colors.white ,),
                
                SizedBox(height: 50,),
                  ListTile(
                    leading: Icon(Icons.policy_outlined,color: Colors.white),
                    title: Text('Terms & conditions'),
                    onTap: (){},
                    textColor: Colors.white,
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline,color: Colors.white,),
                    title: Text('More Info'),
                    onTap: (){},
                    textColor: Colors.white,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout_outlined,color: Colors.white),
                    title: Text('Logout'),
                    onTap: (){},
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            backgroundColor: Colors.blue,
            
          ),
          body: Padding(
            padding:  EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transport Accomodations',
                style: TextStyle(
                  fontSize: 20,
                fontWeight: 
                FontWeight.bold),),
          
          
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                     Card(
                      color: Colors.white70,
                      child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ Image.asset(
                            'taung.jpeg',
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Taung Student Accomodation',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),),
                                Icon(Icons.verified,
                                color: Colors.blue[900],
                                size: 15,),
                               ],
                            ),
                             Text('Available Now',
                                style: TextStyle(
                                  color: Colors.green),)
                              
                            ],
                      ),
                    )
                          
                        
                  ),
                    ],
                  ),
                ),
                SizedBox(height:20),
               Text('No-Transport Accomodations',
                style: TextStyle(
                  fontSize: 20,
                fontWeight: 
                FontWeight.bold),),
          
              ],),
          ),
    );
  }
}