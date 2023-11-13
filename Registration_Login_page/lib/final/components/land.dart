import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Land extends StatelessWidget {
  const Land({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: getProportionateScreenWidth(-65),
      left: 0,
      right: 0,
      child: Image.asset(
        // "assets/images/land_tree_dark.png",
        "assets/images/3.png",
        height: getProportionateScreenWidth(430),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
