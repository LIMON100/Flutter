import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lamaradar/auth/Screens/LogInScreen.dart';

class ConfirmCode extends StatefulWidget {
  final TextEditingController emailController;

  ConfirmCode({required this.emailController});

  @override
  _ConfirmCodeState createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  late StreamSubscription _subscription;

  String _confirmationNumber = "";
  final _cofirmController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  void _confirmSignUp() async {
    SignUpResult res = await Amplify.Auth.confirmSignUp(
        username: widget.emailController.text, confirmationCode: _cofirmController.text
    );
    if(res.isSignUpComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()), // Replace NextPage with your actual next page
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Confirmation complete"),
      ));
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(title: Text("")),
  //       body: SafeArea(
  //         child: Column(
  //           children: [
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {
  //                   _confirmationNumber = value;
  //                 });
  //               },
  //               decoration: InputDecoration(
  //                 labelText: "Confirmation Code",
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: _confirmationNumber.isNotEmpty
  //                   ? _confirmSignUp
  //                   : null,
  //               child: Text("Confirmation"),
  //             )
  //           ],
  //         ),
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0, // Remove any shadow
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Confirmation Code', style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                // color: Color(0xfff5f8fd),
                  color: Colors.black12,
                  borderRadius:
                  BorderRadius.all(Radius.circular(80))),
              child: TextFormField(
                controller: _cofirmController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "username is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Code",
                  border: InputBorder.none,
                  prefixIcon:
                  Icon(Icons.numbers, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                onPressed: _confirmSignUp,
                //   onPressed: _usernameController.text.isNotEmpty
                //       ? _confirmSignUp
                //       : null,
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  primary: Colors.grey, // Change to your preferred color
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                child: Text(
                  "Confirm Code",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
