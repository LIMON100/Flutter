import 'package:flutter/material.dart';
import 'package:lamaradar/mode/dashCamFIles.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DashCamDetails extends StatefulWidget {
  @override
  _DashCamDetailsState createState() => _DashCamDetailsState();
}

class _DashCamDetailsState extends State<DashCamDetails> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   foregroundColor: Colors.black,
      //   title: const Text('About'),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       // color: Color(0xFF6497d3),
      //       color: Colors.deepPurpleAccent,
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.deepPurple.shade100,
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.indigoAccent,
        color: Colors.indigo.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          if(index == 0)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCam()),
            );
          }
          if(index == 1)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCamFiles()),
            );
          }
          if(index == 2)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashCamDetails()),
            );
          }
        },
        items: [
          Icon(
            Icons.home,
            color: Colors.blueGrey.shade700,
          ),
          Icon(
            Icons.image,
            color: Colors.blueGrey.shade700,
          ),
          Icon(
            Icons.history,
            color: Colors.blueGrey.shade700,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Expanded(
            child: Center(
              child: Text(
                  "About"
              ),
            ),
          ),
        ],
      ),
    );
  }
}