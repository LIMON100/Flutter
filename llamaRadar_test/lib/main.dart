import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lamaradar/provider/ConnectionProvider.dart';
import 'package:lamaradar/provider/LedValuesProvider.dart';
import 'package:lamaradar/provider/BluetoothStateProvider.dart';
import 'package:lamaradar/provider/PopupWindowProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'amplifyconfiguration.dart';
import 'auth/Screens/LogInScreen.dart';
import 'models/ModelProvider.dart';
// import 'package:amplify_storage_s3/amplify_storage_s3.dart';

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await configureAmplify();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }
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

// Future<void> configureAmplify() async {
//   await Amplify.addPlugins([AmplifyAuthCognito()]);
//   await Amplify.configure(amplifyconfig);
// }

Future<void> _configureAmplify() async {
  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyAPI(modelProvider: ModelProvider.instance),
    AmplifyStorageS3()
  ]);
  await Amplify.configure(amplifyconfig);
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


// FOR AWS - chekc below OOFFLINE
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Google Maps',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SignIn(),
//     );
//   }
// }

// For Firebase
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   User? user;
//
//   @override
//   void initState(){
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Google Maps',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: user != null ? BleScreen(title: '') : SignIn(),
//     );
//   }
// }

/// For OFFLINE DB
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

