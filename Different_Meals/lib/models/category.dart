import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  const Catetory({
    @required this.id,
    @required this.title,
    this.color = Colors.orage,
  });
}
