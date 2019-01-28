import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myPainter.dart';

class MyGraphLine extends StatefulWidget {
  _MyGraphLineState createState() => _MyGraphLineState();
}

class _MyGraphLineState extends State<MyGraphLine> {
  @override
  Widget build(BuildContext context) {
    double maxValue = 25600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _GraphLineItem((maxValue / maxValue) * 100),
          _GraphLineItem((1500 / maxValue) * 100),
          _GraphLineItem((0 / maxValue) * 100),
          _GraphLineItem((20000 / maxValue) * 100),
          _GraphLineItem((25600 / maxValue) * 100),
        ],
      ),
    );
  }
}

class _GraphLineItem extends StatefulWidget {
  final double percentage;
  _GraphLineItem(this.percentage);
  _GraphLineItemState createState() => _GraphLineItemState();
}

class _GraphLineItemState extends State<_GraphLineItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomPaint(
          child: Container(
            height: 100,
          ),
          painter: MyPainterLine(widget.percentage),
        ),
      ],
    );
  }
}
