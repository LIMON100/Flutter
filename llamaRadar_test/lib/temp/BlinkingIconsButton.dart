import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class BlinkingIconsButton extends StatefulWidget {
  final bool isBlinking;

  const BlinkingIconsButton({required this.isBlinking});

  @override
  _BlinkingIconsButtonState createState() => _BlinkingIconsButtonState();
}

class _BlinkingIconsButtonState extends State<BlinkingIconsButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (widget.isBlinking) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Icon(
          Icons.square,
          size: 40,
          color: _animationController.isAnimating ? Colors.red : Colors.black,
        );
      },
    );
  }
}
