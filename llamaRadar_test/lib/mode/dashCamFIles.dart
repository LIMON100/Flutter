import 'package:flutter/material.dart';
import 'package:lamaradar/mode/dash_cam.dart';
import 'package:lamaradar/mode/dashCamDetails.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class DashCamFiles extends StatefulWidget {
  @override
  _DashCamFilesState createState() => _DashCamFilesState();
}

class _DashCamFilesState extends State<DashCamFiles> {

  int _currentIndex = 0;

  List<String> items = [
    "All",
    "Video",
    "Photos",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.video_file,
    Icons.photo,
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],

      /// APPBAR
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

      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(45),
        child: Column(
          children: [
            /// CUSTOM TABBAR
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 90,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(15)
                                  : BorderRadius.circular(10),
                              border: current == index
                                  ? Border.all(
                                  color: Colors.deepPurpleAccent, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: GoogleFonts.laila(
                                    fontWeight: FontWeight.w500,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: current == index,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle),
                            ))
                      ],
                    );
                  }),
            ),

            /// MAIN BODY
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              height: 550,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[current],
                    size: 200,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    items[current],
                    style: GoogleFonts.laila(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //   body: Column(
    //     children: [
    //       SizedBox(height: 60),
    //       Center(
    //         child: Text(
    //             "Files"
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}