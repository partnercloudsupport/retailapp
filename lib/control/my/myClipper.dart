import 'package:flutter/material.dart';

class MyClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final Path p = Path();

    p.lineTo(0, s.height);

    p.quadraticBezierTo(
        s.width * .25, s.height - 50, s.width * .5, s.height - 35);

    p.quadraticBezierTo(s.width * .75, s.height - 20, s.width, s.height - 50);

    p.lineTo(s.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
