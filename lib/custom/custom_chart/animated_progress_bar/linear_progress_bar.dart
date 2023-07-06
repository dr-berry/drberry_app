import 'package:flutter/material.dart';

class LinearProgressBar extends CustomPainter {
  final Color backgroundColor;
  final Color forgroundColor;
  final int progressing;

  LinearProgressBar(
      {this.backgroundColor = Colors.grey,
      this.forgroundColor = Colors.black,
      this.progressing = 0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundLinePaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    Paint forgroundLinePaint = Paint()
      ..color = forgroundColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), backgroundLinePaint);

    canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width * ((progressing + 1) / 4), size.height / 2),
        forgroundLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
