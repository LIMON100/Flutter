import 'package:testgpss/size_config.dart';
import 'package:flutter/material.dart';

import '../components/body.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
