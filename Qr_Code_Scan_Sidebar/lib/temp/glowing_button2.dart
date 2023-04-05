import 'package:flutter/material.dart';

class GlowingButton2 extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color1;
  final Color color2;

  const GlowingButton2({required this.text, required this.onPressed, required this.color1, required this.color2});

  @override
  _GlowingButton2State createState() => _GlowingButton2State();
}

class _GlowingButton2State extends State<GlowingButton2> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onTapDown: (details) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isPressed = false;
        });
      },
      // child: AnimatedContainer(
      //   duration: Duration(milliseconds: 200),
      //   padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(30.0),
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [
      //         _isPressed ? Colors.greenAccent : Colors.cyan,
      //         _isPressed ? Colors.cyan : Colors.greenAccent,
      //       ],
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5),
      //         blurRadius: 6.0,
      //         spreadRadius: 2.0,
      //         offset: Offset(0.0, 3.0),
      //       ),
      //     ],
      //   ),
      //   child: Text(
      //     widget.text,
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 18.0,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),

      child: AnimatedContainer(
        // transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 200),
        height: 52,
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [
                widget.color1,
                widget.color2,
              ],
            ),
            boxShadow: _isPressed
                ? [
              BoxShadow(
                color: widget.color1.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 16,
                offset: Offset(-8, 0),
              ),
              BoxShadow(
                color: widget.color2.withOpacity(0.6),
                spreadRadius: 1,
                blurRadius: 16,
                offset: Offset(8, 0),
              ),
              BoxShadow(
                color: widget.color1.withOpacity(0.2),
                spreadRadius: 16,
                blurRadius: 32,
                offset: Offset(-8, 0),
              ),
              BoxShadow(
                color: widget.color2.withOpacity(0.2),
                spreadRadius: 16,
                blurRadius: 32,
                offset: Offset(8, 0),
              )
            ]
                : []),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   _isPressed ? Icons.lightbulb : Icons.lightbulb_outline,
            //   color: Colors.white,
            // ),
            Text(
              _isPressed ? widget.text : widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
