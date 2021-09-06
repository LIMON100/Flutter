import 'package:flutter/material.dart';

Color getColor(BuildContext context, double parcent) {
  if (parcent >= 0.50) {
    return Theme.of(context).primaryColor;
  } else if (parcent >= 0.25) {
    return Colors.orange;
  }
  return Colors.red;
}
