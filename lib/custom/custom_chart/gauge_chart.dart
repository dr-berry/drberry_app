import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/path.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

class GaugeChart extends CustomPainter {
  final List<SleepHistoryGague> data;
  final String start;
  final String end;
  final double size;

  GaugeChart(
      {required this.data,
      required this.size,
      required this.start,
      required this.end});

  @override
  void paint(Canvas canvas, Size size) async {
    Paint point = Paint()
      ..color = CustomColors.systemGrey5
      ..style = PaintingStyle.fill;

    Paint line = Paint()
      ..color = CustomColors.systemGrey5
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Offset startPoint = Offset(0, size.height / 2);
    Offset endPoint = Offset(size.width, size.height / 2);
    double radius = 5;

    canvas.drawCircle(startPoint, radius, point);
    canvas.drawCircle(endPoint, radius, point);
    canvas.drawLine(startPoint, endPoint, line);

    var part = (size.width - 40) / data.length;
    double gaugeMaximum = 20;

    for (var i = 0; i < data.length; i++) {
      if (data[i].sleepPattern > 0) {
        Rect rect = Rect.fromPoints(
            Offset(gaugeMaximum.toDouble(), size.height / 2 - 6),
            Offset(gaugeMaximum + part, size.height / 2 + 6));

        Radius topLeft = const Radius.circular(0);
        Radius topRight = const Radius.circular(0);
        Radius bottomLeft = const Radius.circular(0);
        Radius bottomRight = const Radius.circular(0);

        if (i == 0) {
          topLeft = const Radius.circular(6);
          bottomLeft = const Radius.circular(6);

          if (data[i + 1].sleepPattern == 0) {
            topRight = const Radius.circular(6);
            bottomRight = const Radius.circular(6);
          }
        }

        if (i == data.length - 1) {
          topRight = const Radius.circular(6);
          bottomRight = const Radius.circular(6);

          if (data[i - 1].sleepPattern == 0) {
            topLeft = const Radius.circular(6);
            bottomLeft = const Radius.circular(6);
          }
        }

        if (i > 0 && i < data.length - 1) {
          if (data[i - 1].sleepPattern == 0) {
            topLeft = const Radius.circular(6);
            bottomLeft = const Radius.circular(6);
          }

          if (data[i + 1].sleepPattern == 0) {
            topRight = const Radius.circular(6);
            bottomRight = const Radius.circular(6);
          }
        }

        Paint gauge = Paint()
          ..shader = LinearGradient(
            colors: CustomColors.gradient('GREEN'),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rect)
          ..style = PaintingStyle.fill;

        RRect rRect = RRect.fromRectAndCorners(rect,
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight);

        canvas.drawRRect(rRect, gauge);
      }
      gaugeMaximum = gaugeMaximum + part;
    }

    if (data.isNotEmpty) {
      final startTextSpan = TextSpan(
          text: start,
          style: const TextStyle(
            color: CustomColors.systemBlack,
            fontSize: 13,
          ));
      final endTextSpan = TextSpan(
          text: end,
          style: const TextStyle(
              color: CustomColors.systemBlack,
              fontSize: 13,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400));

      final startPainter =
          TextPainter(text: startTextSpan, textDirection: TextDirection.ltr);

      final endPainter =
          TextPainter(text: endTextSpan, textDirection: TextDirection.ltr);

      startPainter.layout();
      endPainter.layout();

      startPainter.paint(canvas, Offset(28, size.height / 2 + 20));
      endPainter.paint(canvas,
          Offset(size.width - startPainter.width - 28, size.height / 2 + 20));
    }

    Paint moonPaint = Paint()..style = PaintingStyle.fill;
    moonPaint.color = const Color(0xff111111).withOpacity(1.0);
    canvas.save();
    canvas.translate(-5, size.height / 2 + 14);
    canvas.drawPath(SvgPath.getMoon(this.size), moonPaint);
    canvas.restore();

    Paint sunPaint = Paint()..style = PaintingStyle.fill;
    sunPaint.color = const Color(0xff111111).withOpacity(1.0);
    canvas.save();
    canvas.translate(size.width - 26, size.height / 2 + 14);
    canvas.drawPath(SvgPath.getSun(this.size + 2), sunPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
