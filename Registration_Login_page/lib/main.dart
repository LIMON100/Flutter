import 'package:flutter/material.dart';
import 'package:testgpss/screens/Login/login_screen.dart';

import 'Screens23/LogInScreen.dart';

// import 'package:testgpss/screens/Signup/signup_screen.dart';
// import 'package:testgpss/screens/Welcome/components/login_signup_btn.dart';
// import 'package:testgpss/screens/Welcome/welcome_screen.dart';
// import 'package:testgpss/src/welcomePage.dart';

// import 'Screens23/LogInScreen.dart';
// import 'Screens23/SignUpScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignIn(),
    );
  }
}
