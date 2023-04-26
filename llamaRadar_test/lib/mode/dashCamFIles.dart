import 'package:flutter/material.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class DashCamFiles extends StatefulWidget {
  @override
  _DashCamFilesState createState() => _DashCamFilesState();
}

class _DashCamFilesState extends State<DashCamFiles> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text('Files'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // color: Color(0xFF6497d3),
            color: Color(0xFF2580B3),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.indigoAccent,
        color: Colors.indigo.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
          // if(index == 0)
          // {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => DashCam()),
          //   );
          // }
          // if(index == 1)
          // {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => DashCamFiles()),
          //   );
          // }
          // if(index == 2)
          // {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => DashCamDetails()),
          //   );
          // }
        },
        items: [
          Icon(
            Icons.home,
            color: _currentIndex == 0 ? Colors.white : Colors.blueGrey.shade700,
          ),
          Icon(
            Icons.image,
            color: _currentIndex == 1 ? Colors.white : Colors.blueGrey.shade700,
          ),
          Icon(
            Icons.history,
            color: _currentIndex == 2 ? Colors.white : Colors.blueGrey.shade700,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Center(
            child: Text(
                "Files"
            ),
          ),
        ],
      ),
    );
  }
}