import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // final TextEditingController ssidController;
  // final TextEditingController passController;
  // final TextEditingController dhcpController;
  // final TextEditingController ipController;
  // final TextEditingController gwController;
  // final TextEditingController maskController;
  // final TextEditingController dns1Controller;
  // final TextEditingController dns2Controller;
  // final Axis scrollDirection; // removed default value here
  //
  // CustomTextField({
  //   Key? key,
  //   required this.dhcpController,
  //   required this.ipController,
  //   required this.gwController,
  //   required this.maskController,
  //   required this.dns1Controller,
  //   required this.dns2Controller,
  //   this.scrollDirection = Axis.horizontal,
  // }) : super(key: key);
  //
  // CustomTextField({
  //   Key? key,
  //   required this.ssidController,
  //   required this.passController,
  //   this.scrollDirection = Axis.horizontal,
  // }) : super(key: key);

  final TextEditingController? ssidController;
  final TextEditingController? passController;
  final TextEditingController? dhcpController;
  final TextEditingController? ipController;
  final TextEditingController? gwController;
  final TextEditingController? maskController;
  final TextEditingController? dns1Controller;
  final TextEditingController? dns2Controller;
  final Axis scrollDirection;

  CustomTextField({
    Key? key,
    this.dhcpController,
    this.ipController,
    this.gwController,
    this.maskController,
    this.dns1Controller,
    this.dns2Controller,
    this.scrollDirection = Axis.horizontal,
  })  : ssidController = null,
        passController = null,
        super(key: key);

  CustomTextField.credentials({
    Key? key,
    required this.ssidController,
    required this.passController,
    this.scrollDirection = Axis.horizontal,
  })  : dhcpController = null,
        ipController = null,
        gwController = null,
        maskController = null,
        dns1Controller = null,
        dns2Controller = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      child: Row(
        children: [
          Container(
            width: 100,
            child: TextField(
              controller: dhcpController,
              decoration: InputDecoration(
                hintText: "dhcp",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.all(8),
            child: TextField(
              controller: ipController,
              decoration: InputDecoration(
                hintText: "ip",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 100,
            child: TextField(
              controller: gwController,
              decoration: InputDecoration(
                hintText: "gw",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 100,
            margin: EdgeInsets.all(8),
            child: TextField(
              controller: maskController,
              decoration: InputDecoration(
                hintText: "mask",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 150,
            child: TextField(
              controller: dns1Controller,
              decoration: InputDecoration(
                hintText: "dns1",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: 150,
            child: TextField(
              controller: dns2Controller,
              decoration: InputDecoration(
                hintText: "dns2",
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
