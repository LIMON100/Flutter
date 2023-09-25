import 'package:lamaradar/temp/ConnectionProvider.dart';
import 'package:lamaradar/temp/LedValuesProvider.dart';
import 'package:lamaradar/provider/BluetoothStateProvider.dart';
import 'package:provider/provider.dart';

import 'SideBar.dart';
import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

// void main() {
//   runApp(SplashScreen());
// }


// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => LedValuesProvider(),
//       child: SplashScreen(),
//     ),
//   );
// }

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BleScreen(title: ''),
    );
  }
}
