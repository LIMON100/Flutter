import 'package:flutter/material.dart';
import 'open_camera.dart';
import 'qrviewexample.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('LLAMA'),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('images/llamalogo_no_txt.jpg',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.electric_scooter),
            title: Text('Llama Eye'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context){
                    return Container(
                      child: AlertDialog(
                        title: Text("Want to open web tool"),
                        actions: [
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const OpenCamera(),
                                  ),
                                );
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text("No"))
                        ],
                      ),
                    );
                  });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.car_crash),
            title: Text(' Llama Radar'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
