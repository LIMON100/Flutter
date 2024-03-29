import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final Color color1;
  final Color color2;

  // const GlowingButton(
  //     {required  Key key, this.color1 = Colors.cyan, this.color2 = Colors.greenAccent})
  //     : super(key: key);
  GlowingButton({
    Key? key, // add a nullable Key parameter
    this.color1 = Colors.cyan,
    this.color2 = Colors.greenAccent,
  }) : super(key: key ?? UniqueKey());

  @override
  _GlowingButtonState createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> {
  var glowing = true;
  var scale = 1.0;
  @override
  Widget build(BuildContext context) {
    //On mobile devices, gesture detector is perfect
    //However for desktop and web we can show this effect on hover too
    return GestureDetector(
      onTapUp: (val) {
        setState(() {
          glowing = false;
          scale = 1.0;
        });
      },
      onTapDown: (val) {
        setState(() {
          glowing = true;
          scale = 1.1;
        });
      },
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(scale),
        duration: Duration(milliseconds: 200),
        height: 48,
        width: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(
              colors: [
                widget.color1,
                widget.color2,
              ],
            ),
            boxShadow: glowing
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
            Icon(
              glowing ? Icons.lightbulb : Icons.lightbulb_outline,
              color: Colors.white,
            ),
            Text(
              glowing ? "Glowing" : "Dimmed",
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


// import 'package:flutter/material.dart';
//
// class GlowingButton extends StatefulWidget {
//   final String text;
//   final VoidCallback onPressed;
//
//   GlowingButton({required this.text, required this.onPressed});
//
//   @override
//   _GlowingButtonState createState() => _GlowingButtonState();
// }
//
// class _GlowingButtonState extends State<GlowingButton>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     )..repeat(reverse: true);
//
//     _animation = Tween(begin: 0.0, end: 20.0).animate(_controller);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var glowing = false;
//     // var scale = 1.0;
//     return GestureDetector(
//       onTapUp: (val) {
//         setState(() {
//           glowing = false;
//           // scale = 1.0;
//         });
//       },
//       onTapDown: (val) {
//         setState(() {
//           glowing = true;
//           // scale = 1.1;
//         });
//       },
//       child: AnimatedContainer(
//         // transform: Matrix4.identity(),
//         duration: Duration(milliseconds: 200),
//         height: 48,
//         width: 160,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(40),
//             gradient: LinearGradient(
//               colors: [
//                 Colors.cyan,
//                 Colors.greenAccent
//               ],
//             ),
//             boxShadow: glowing
//                 ? [
//               BoxShadow(
//                 color: Colors.cyan.withOpacity(0.6),
//                 spreadRadius: 1,
//                 blurRadius: 16,
//                 offset: Offset(-8, 0),
//               ),
//               BoxShadow(
//                 color: Colors.greenAccent.withOpacity(0.6),
//                 spreadRadius: 1,
//                 blurRadius: 16,
//                 offset: Offset(8, 0),
//               ),
//               BoxShadow(
//                 color: Colors.cyan.withOpacity(0.2),
//                 spreadRadius: 16,
//                 blurRadius: 32,
//                 offset: Offset(-8, 0),
//               ),
//               BoxShadow(
//                 color: Colors.greenAccent.withOpacity(0.2),
//                 spreadRadius: 16,
//                 blurRadius: 32,
//                 offset: Offset(8, 0),
//               )
//             ]
//                 : []),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               glowing ? Icons.lightbulb : Icons.lightbulb_outline,
//               color: Colors.white,
//             ),
//             Text(
//               glowing ? "Glowing" : "Dimmed",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }