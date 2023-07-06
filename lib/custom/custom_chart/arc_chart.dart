import 'dart:math';

import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class ArcChart extends CustomPainter {
  final String backgroundColor;
  late String foregroundColors;
  late String state;
  final Color percentageColor = CustomColors.systemBlack;
  late Color scoreStateColor;
  final double percentageTextSize;
  final double scoreStateTextSize;
  final double percentage;
  final double strokeWidth;
  final double descriptionTextSize;
  final String description;

  ArcChart(
      {this.percentage = 100,
      this.backgroundColor = 'GREY',
      this.percentageTextSize = 24,
      this.scoreStateTextSize = 15,
      this.strokeWidth = 15,
      this.description = '',
      this.descriptionTextSize = 13});

  void scoreState(double percentage) {
    if (percentage >= 90) {
      state = 'Excellent';
      foregroundColors = 'GREEN';
      scoreStateColor = CustomColors.lightGreen2;
    } else if (percentage >= 80 && percentage < 90) {
      state = 'Good';
      foregroundColors = 'BLUE';
      scoreStateColor = CustomColors.blue;
    } else if (percentage >= 70 && percentage < 80) {
      state = 'Fair';
      foregroundColors = 'YELLOW';
      scoreStateColor = CustomColors.yellow;
    } else if (percentage >= 60 && percentage < 70) {
      state = 'Bad';
      foregroundColors = 'PURPLE';
      scoreStateColor = CustomColors.purple;
    } else {
      state = 'Worst';
      foregroundColors = 'RED';
      scoreStateColor = CustomColors.red;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    scoreState(percentage);
    Rect rect = Rect.fromCircle(
        center: Offset(
            max(size.width, size.height) / 2, max(size.width, size.height) / 2),
        radius: size.width / 2);

    Paint bgCircle = Paint()
      ..shader = LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: CustomColors.gradient(backgroundColor))
          .createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(
        max(size.width, size.height) / 2, max(size.width, size.height) / 2);
    double radius = max(size.width / 2, size.height / 2);

    Paint fgCircle = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: CustomColors.gradient(foregroundColors),
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint neonShadow = Paint()
      ..color = CustomColors.getNeon(foregroundColors)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth - 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12)
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * pi * 0.6755;
    double startAngle = 2.58939;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, bgCircle);

    if (percentage > 0) {
      double chartAngle = (2 * pi * 0.6755) * (percentage / 100);
      print("=========");
      print(percentage);
      print(chartAngle);
      print("=========");

      final path = Path()..arcTo(rect, startAngle, chartAngle, false);

      canvas.drawPath(path, neonShadow);
      canvas.drawPath(path, fgCircle);
    }

    final percentageText = TextSpan(
        text: '${percentage.floor()}',
        style: TextStyle(
            fontSize: percentageTextSize,
            fontFamily: 'Pretendard',
            color: percentageColor,
            fontWeight: FontWeight.w600));

    final scoreStateText = TextSpan(
        text: state,
        style: TextStyle(
            fontSize: scoreStateTextSize,
            color: scoreStateColor,
            fontFamily: 'SF-Pro',
            fontWeight: FontWeight.w600));

    final percentagePainter =
        TextPainter(text: percentageText, textDirection: TextDirection.ltr);

    final scoreStatePainter =
        TextPainter(text: scoreStateText, textDirection: TextDirection.ltr);

    percentagePainter.layout();
    scoreStatePainter.layout();

    percentagePainter.paint(
        canvas,
        Offset(max(size.width, size.height) / 2 - percentagePainter.width / 2,
            max(size.width, size.height) / 2 - percentagePainter.height));

    if (percentage > 0) {
      scoreStatePainter.paint(
          canvas,
          Offset(max(size.width, size.height) / 2 - scoreStatePainter.width / 2,
              max(size.width, size.height) / 2 + 3));
    }

    if (description != '') {
      final descriptionText = TextSpan(
          text: description,
          style: TextStyle(
              fontSize: descriptionTextSize,
              fontFamily: 'Pretendard',
              color: CustomColors.systemBlack,
              fontWeight: FontWeight.w600));

      final descriptionPainter =
          TextPainter(text: descriptionText, textDirection: TextDirection.ltr);

      descriptionPainter.layout();
      descriptionPainter.paint(
          canvas,
          Offset(size.width / 2 - descriptionPainter.width / 2,
              size.height - descriptionPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
