import 'package:flutter/material.dart';
import '../components/body.dart';
import '../components/body_new.dart';
import '../size_config.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: BodyNew(),
    );
  }
}
