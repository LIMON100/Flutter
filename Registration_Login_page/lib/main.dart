import 'package:flutter/material.dart';
import 'package:testgpss/temp/LocationPage2.dart';
import 'final/Screens/LogInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // User is logged in, redirect to home page
              return LocationPage2();
            }
            else {
              // User is not logged in, redirect to login page
              return SignIn();
            }
          } else {
            // Loading indicator
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  // // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Flutter Google Maps',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: SignIn(),
  //   );
  // }
}
