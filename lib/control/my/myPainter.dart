import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';

class MyPainter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.4,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = MyColor.color1.withOpacity(.2);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80,
        size.width * 0.15, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.45,
        size.width * 0.75, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = MyColor.color1.withOpacity(.5);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.55,
        size.width * 0.20, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.30, size.height * 0.90,
        size.width * 0.40, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.52, size.height * 0.50,
        size.width * 0.65, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.85, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = MyColor.color1;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class MyPainterLine extends CustomPainter {
  final double percentage;
  MyPainterLine(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;

    Paint paint = Paint()
      ..color = MyColor.grey
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset bottomPoint = Offset(0, height);

    canvas.drawLine(Offset(0, 0), bottomPoint, paint);

    paint = Paint()
      ..color = MyColor.color1
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        bottomPoint, Offset(0, height - (percentage * height) / 100), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
