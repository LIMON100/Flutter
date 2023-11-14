import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamaradar/mode/bleScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/usersauth.dart';
import '../../sqflite/sqlite.dart';
import 'registration_screen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {

  final username = TextEditingController();
  final password = TextEditingController();
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  //Now we should call this function in login button
  login() async {
    var response = await db
        .login(UsersAuth(usrName: username.text, usrPassword: password.text));
    if (response == true) {
      //If login is correct, then goto notes
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BleScreen(title: '')));
    }
    else {
      //If not, true the bool value to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }
  final formKey = GlobalKey<FormState>();

  bool isLoggedIn = false;
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return Container(
              child: AlertDialog(
                title: Text("Are you sure to exit?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pop(true);
                      SystemNavigator.pop();
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("No"),
                  )
                ],
              ),
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffe8ebed),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                50, //For moving according to the screen when the keyboard popsup.
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(30),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 300,
                              width: 400,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("assets/images/logo.png",),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 60),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffe1e2e3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ]),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w800),
                                    )),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20))),
                                  child: TextFormField(
                                    controller: username,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "password is required";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20))),
                                  child: TextFormField(
                                    controller: password,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "password is required";
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      border: InputBorder.none,
                                      prefixIcon:
                                          Icon(Icons.vpn_key, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ]),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        // Container(
                        //   alignment: Alignment.centerRight,
                        //   child: Container(
                        //       child: Text(
                        //     "Forgot Password?",
                        //     style: TextStyle(
                        //         color: Colors.deepPurpleAccent,
                        //         fontWeight: FontWeight.w500),
                        //   )),
                        // ),

                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  login();
                                }
                                setState(() {
                                  isLoggedIn = true;
                                  saveLoginStatus(isLoggedIn);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 3,
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                                primary: Colors.deepPurpleAccent, // Change to your preferred color
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(width: 10),
                          ],
                        ),

                        SizedBox(height: 10),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text("Don't have an account?"),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegistrationScreen())
                              );
                            },
                            child: Container(
                              child: Text("Register now",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepPurpleAccent)),
                            ),
                          )
                        ]),
                        isLoginTrue
                            ? const Text(
                          "Username or passowrd is incorrect",
                          style: TextStyle(color: Colors.red),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
