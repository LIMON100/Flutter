import 'package:lamaradar/provider/ConnectionProvider.dart';
import 'package:lamaradar/provider/LedValuesProvider.dart';
import 'package:lamaradar/provider/BluetoothStateProvider.dart';
import 'package:lamaradar/provider/PopupWindowProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SideBar.dart';
import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'auth/Screens/LogInScreen.dart';

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LedValuesProvider>(
          create: (_) => LedValuesProvider(),
        ),
        ChangeNotifierProvider<ConnectionProvider>(
          create: (_) => ConnectionProvider(),
        ),
        ChangeNotifierProvider<BluetoothStateProvider>(
          create: (_) => BluetoothStateProvider(),
        ),
        ChangeNotifierProvider<PopupWindowProvider>(
          create: (_) => PopupWindowProvider(),
        ),
      ],
      child: SplashScreen(),
    ),
  );
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: AssetImage('assets/images/app_background_rb.png'),
              fit: BoxFit.fitHeight,

            ),
          ),
        ),
        backgroundColor: Colors.blueGrey,
        nextScreen: MyApp(),
        splashIconSize: 510,
        duration: 3000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
        animationDuration: const Duration(seconds: 1),
      ),
    );
  }
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
              return BleScreen(title: '');
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
}


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BleScreen(title: ''),
//     );
//   }
// }

