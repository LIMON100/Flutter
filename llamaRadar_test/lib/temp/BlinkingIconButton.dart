import 'dart:async';
import 'package:flutter/material.dart';
import 'indicator_icons.dart';

class BlinkingIconButton extends StatefulWidget {
  final IconData icon;
  final double size;

  BlinkingIconButton({required this.icon, required this.size});

  @override
  _BlinkingIconButtonState createState() => _BlinkingIconButtonState();
}

class _BlinkingIconButtonState extends State<BlinkingIconButton> {
  bool _isBlinking = false;
  Timer? _timer;

  void _startBlinking() {
    setState(() {
      _isBlinking = true;
    });

    _timer = Timer(Duration(seconds: 3), () {
      setState(() {
        _isBlinking = false;
      });
    });

    _blink();
  }

  void _stopBlinking() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void _blink() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });
  }

  @override
  void dispose() {
    _stopBlinking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _startBlinking();
      },
      child: Icon(
        widget.icon,
        size: widget.size,
        color: _isBlinking
            ? (widget.icon == Indicator.image2vector
            ? Colors.orange
            : widget.icon == Indicator.image2vector__1_
            ? Colors.orange
            : Colors.red)
            : Colors.black,
      ),

    );
  }
}
