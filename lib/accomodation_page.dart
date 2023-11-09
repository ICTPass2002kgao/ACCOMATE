// ignore_for_file: prefer_const_constructors, dead_code, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, unnecessary_string_interpolations


import 'package:flutter/material.dart';

class AccomodationPage extends StatelessWidget {
  const AccomodationPage({super.key, required this.residenceDetails});
  final Map<String, Object> residenceDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          residenceDetails['name'] as String,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: Image.asset( residenceDetails['imagePath'] as String,
                ),
            ),
            SizedBox(height: 10,),
             Center(
               child: Text( residenceDetails['name'] as String,
                  style:TextStyle(
                  fontSize:15,
                  fontWeight: FontWeight.bold 
                )
                  ),
             ),


            Center(
              child: TextButton.icon(onPressed: (){}, 
              icon: Icon(Icons.favorite_border,
              color: Colors.yellow,), 
              label: Text('Add to favorite',
              style:TextStyle(
                fontSize:15,
                color: Colors.yellow,
                fontWeight: FontWeight.bold
              ))),
            ),

          
          SizedBox(height: 10,),
           
            Text('Location: ',
             style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
              
            ),),
           
    
            Row(children: [
            SizedBox(height: 10,),
              
            Text('Status: ',
             style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
              
            ),),
            SizedBox(width: 10,),
            
            Text(residenceDetails['status'] as String,
            style: TextStyle(
              fontSize: 15,
              color: Colors.green
            ),),
            ],),
            SizedBox(height: 10,),
          
           Spacer(),
           
            
            SizedBox(height: 10,),
            TextButton(
                onPressed: (){}, 
                child: Text('Register Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                 
                ),),
                style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(double.infinity,50)),
                    foregroundColor: MaterialStatePropertyAll(Colors.blue),
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                ),),

                Spacer(),

            ],
              ),
            ),
         

          
        
      
    );
  }
}
