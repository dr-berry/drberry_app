import 'dart:ui';

import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

import '../../color/color.dart';

class TossChart extends CustomPainter {
  final List<TossNTurnGraph> tossNTurnGraph;
  final TossNTurnGraphY tossNTurnGraphY;
  late Picture picture;

  TossChart(Size size, {required this.tossNTurnGraph, required this.tossNTurnGraphY}) {
    picture = _captureChart(size);
  }

  Picture _captureChart(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    Paint xlines = Paint()
      ..color = CustomColors.systemGrey5
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    var dashWidth = 4;
    var dashSpace = 4;
    var startY = 0.0;

    var path = Path();
    path.moveTo(0, startY);
    for (var i = 0; i < size.width - 49; i += dashSpace * 2 + dashWidth) {
      path.lineTo((i + dashWidth).toDouble(), startY);
      path.moveTo((i + dashWidth + dashSpace).toDouble(), startY);
    }
    canvas.save();
    canvas.translate(49, 32);
    canvas.drawPath(path, xlines);
    canvas.restore();

    const topicSpan = TextSpan(
        text: "(강도)",
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

    final topicPainter = TextPainter(text: topicSpan, textDirection: TextDirection.ltr);

    topicPainter.layout();
    topicPainter.paint(canvas, const Offset(0, 0));

    final minToss = TextSpan(
        text: ((int.parse(tossNTurnGraphY.minToss) / 10).floor() * 10).toString(),
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

    final minTossPainter = TextPainter(text: minToss, textDirection: TextDirection.ltr);

    minTossPainter.layout(maxWidth: 48);
    minTossPainter.paint(canvas,
        Offset(topicPainter.width / 2 - minTossPainter.width / 2, (size.height - 23) - minTossPainter.height / 2));

    final maxToss = TextSpan(
        text: ((int.parse(tossNTurnGraphY.maxToss) / 10).ceil() * 10).toString(),
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

    final maxTossPainter = TextPainter(text: maxToss, textDirection: TextDirection.ltr);

    maxTossPainter.layout(maxWidth: 48);
    maxTossPainter.paint(
        canvas, Offset(topicPainter.width / 2 - maxTossPainter.width / 2, 32 - maxTossPainter.height / 2));

    canvas.drawLine(Offset(49, size.height - 23), Offset(size.width - 7, size.height - 23), xlines);

    var xtextStartY = (size.height - 13).toDouble();
    var p = (size.width - 49) / tossNTurnGraph.length;
    var startX = 49.0;

    for (var i = 0; i < tossNTurnGraph.length; i++) {
      TextSpan xtexts = TextSpan(
          text: tossNTurnGraph[i].hour,
          style: const TextStyle(
              color: CustomColors.secondaryBlack, fontSize: 12, fontFamily: 'Pretendard', fontWeight: FontWeight.w400));

      final xtextPainter = TextPainter(text: xtexts, textDirection: TextDirection.ltr);

      xtextPainter.layout();
      xtextPainter.paint(canvas, Offset(startX + p / 2 - (xtextPainter.width / 2), xtextStartY));

      startX += p;
    }

    var sX = 49.0;
    var barWidth = p / 2;
    var min = int.parse(tossNTurnGraphY.minToss);
    var max = int.parse(tossNTurnGraphY.maxToss);
    var minT = (min / 10).floor() * 10;
    var maxT = (max / 10).ceil() * 10;

    for (var i = 0; i < tossNTurnGraph.length; i++) {
      var toss = int.parse(tossNTurnGraph[i].tossNTurn);
      var y = ((size.height - 55) * (((maxT - minT) - (toss - minT)) / (maxT - minT))) + 32;
      var sx = sX + p / 2 - barWidth / 2;
      var ex = sX + p / 2 + barWidth / 2;

      // print('yyyy : ${((toss - minT))}');

      Offset topLeft = Offset(sx, size.height - 23);
      Offset bottomRight = Offset(ex, y);

      Rect rect = Rect.fromPoints(topLeft, bottomRight);

      Paint barPaint = Paint()
        ..shader = LinearGradient(
                colors: CustomColors.gradient('GREEN'), begin: Alignment.centerLeft, end: Alignment.centerRight)
            .createShader(rect)
        ..style = PaintingStyle.fill;

      RRect rRect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(barWidth / 5), topRight: Radius.circular(barWidth / 5));

      canvas.drawRRect(rRect, barPaint);

      sX += p;
    }

    return recorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
