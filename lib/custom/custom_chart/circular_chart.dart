import 'dart:math';

import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class CircularChart extends CustomPainter {
  final Color backgroundColor;
  late String foregroundColors;
  late String state;
  late Color percentageColor;
  late Color scoreStateColor;
  final double percentageTextSize;
  final double scoreStateTextSize;
  final double percentage;
  final double strokeWidth;
  final bool isScoreState;

  CircularChart(
      {this.backgroundColor = const Color(0xFFD9D9D9),
      this.percentage = 75,
      this.strokeWidth = 20.5,
      this.percentageColor = const Color(0xFFFFFFFF),
      this.percentageTextSize = 57,
      this.scoreStateTextSize = 17,
      this.isScoreState = true});

  void scoreState(double percentage) {
    if (percentage >= 90) {
      state = 'Excellent';
      foregroundColors = 'GREEN';
      if (percentageColor == const Color(0xFFFFFFFF)) {
        percentageColor = CustomColors.lightGreen2;
      }
      scoreStateColor = CustomColors.lightGreen2;
    } else if (percentage >= 80 && percentage < 90) {
      state = 'Good';
      foregroundColors = 'BLUE';
      if (percentageColor == const Color(0xFFFFFFFF)) {
        percentageColor = CustomColors.blue;
      }
      scoreStateColor = CustomColors.blue;
    } else if (percentage >= 70 && percentage < 80) {
      state = 'Fair';
      foregroundColors = 'YELLOW';
      if (percentageColor == const Color(0xFFFFFFFF)) {
        percentageColor = CustomColors.yellow;
      }
      scoreStateColor = CustomColors.yellow;
    } else if (percentage >= 60 && percentage < 70) {
      state = 'Bad';
      foregroundColors = 'PURPLE';
      if (percentageColor == const Color(0xFFFFFFFF)) {
        percentageColor = CustomColors.purple;
      }
      scoreStateColor = CustomColors.purple;
    } else {
      state = 'Worst';
      foregroundColors = 'RED';
      if (percentageColor == const Color(0xFFFFFFFF)) {
        percentageColor = CustomColors.red;
      }
      scoreStateColor = CustomColors.red;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    scoreState(percentage);
    Paint bgCircle = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    Rect rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);

    double sweepAngle = 2 * pi * (percentage / 100);

    Paint fgCircle = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: CustomColors.gradient(foregroundColors),
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final percentageSpan = TextSpan(
        text: '${percentage.floor()}',
        style: TextStyle(
            color: percentageColor, fontSize: percentageTextSize, fontWeight: FontWeight.w700, fontFamily: 'SF-Pro'));

    final percentagePainter = TextPainter(text: percentageSpan, textDirection: TextDirection.ltr);

    final scoreStateSpan = TextSpan(
        text: state,
        style: TextStyle(
            color: scoreStateColor, fontSize: scoreStateTextSize, fontWeight: FontWeight.w700, fontFamily: 'SF-Pro'));

    final scoreStatePainter = TextPainter(text: scoreStateSpan, textDirection: TextDirection.ltr);

    percentagePainter.layout();
    scoreStatePainter.layout();
    Offset textCenter =
        Offset((size.width / 2 - percentagePainter.width / 2), (size.height / 2 - percentagePainter.height / 2 - 10));
    Offset textCenterBottom = Offset((size.width / 2 - scoreStatePainter.width / 2),
        size.height / 2 - scoreStatePainter.height / 2 + percentagePainter.height / 2);

    canvas.drawCircle(center, radius, bgCircle);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, sweepAngle, false, fgCircle);

    if (isScoreState) {
      percentagePainter.paint(canvas, textCenter);
      scoreStatePainter.paint(canvas, textCenterBottom);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
