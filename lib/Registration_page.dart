// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';

class RegistrationOption extends StatefulWidget {
  const RegistrationOption({super.key});

  @override
  State<RegistrationOption> createState() => _RegistrationOptionState();
}

class _RegistrationOptionState extends State<RegistrationOption> {

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Name'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        
      ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(Icons.person_add,
          size:  200,
          color: Colors.blue,),

          Row(
            children: [
              Text('You are registering as:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              
              
              

            ],

          ),
          RadioListTile(
            value: _value,
           groupValue: _value,
            onChanged:(value) {
              setState(() {
                _value = value!;
              });

            },
            title: Text('Landlord'),
            tileColor: Colors.white,
            ),RadioListTile(
            value: _value,
           groupValue: _value,
            onChanged:(value) {
              setState(() {
               _value=value!;
              });

            },
            title: Text('Student'),
            tileColor: Colors.white,
            ),

            
              SizedBox(
                height: 20,
              ),
              
              CheckboxListTile(
              value: true,
              onChanged:(value) {
                
              },
              
              title: Text('Agree with terms & conditions'),
              tileColor: Colors.white,),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18),
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    minimumSize: MaterialStatePropertyAll(Size(double.infinity, 50))),
              
              ),
        ],
        
      ),
    ),
      
    );
  }
}