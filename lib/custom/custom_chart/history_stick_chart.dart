import 'dart:ui';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

class HistoryStickChart extends CustomPainter {
  final List<Offset> dataPoints = [];

  final List<HistoryGraph> datas;
  late Picture _picture;
  final List<HistoryLabels> labels;

  HistoryStickChart({required Size size, required this.datas, required this.labels}) {
    _picture = _captureGraph(size);
  }

  Picture _captureGraph(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    Paint xlines = Paint()
      ..color = CustomColors.systemGrey5
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    var dashWidth = 4;
    var dashSpace = 4;
    var startY = 32.0;
    var lineNum = 4;
    var part = (size.height - 55) / 4;

    while (lineNum > 0) {
      var path = Path();
      path.moveTo(0, startY);
      for (var i = 0; i < size.width - 44; i += dashSpace * 2 + dashWidth) {
        path.lineTo((i + dashWidth).toDouble(), startY);
        path.moveTo((i + dashWidth + dashSpace).toDouble(), startY);
      }
      canvas.save();
      canvas.translate(44, 0);
      canvas.drawPath(path, xlines);
      canvas.restore();

      TextSpan graphYText = TextSpan(
        text: ((100 / 4) * (lineNum)).floor().toString(),
        style: const TextStyle(
          fontSize: 12,
          fontFamily: "SF-Pro",
          color: Color(0xFF8E8E93),
        ),
      );
      final graphYPainter = TextPainter(
        text: graphYText,
        textDirection: TextDirection.ltr,
      );

      graphYPainter.layout();
      graphYPainter.paint(
        canvas,
        Offset(0, startY - graphYPainter.height / 2),
      );

      startY += part;
      lineNum--;
    }

    TextSpan graphYText = TextSpan(
        text: ((100 / 4) * (lineNum)).floor().toString(),
        style: const TextStyle(fontSize: 12, fontFamily: "SF-Pro", color: Color(0xFF8E8E93)));
    final graphYPainter = TextPainter(text: graphYText, textDirection: TextDirection.ltr);

    graphYPainter.layout();
    graphYPainter.paint(canvas, Offset(0, startY - graphYPainter.height / 2));
    canvas.drawLine(Offset(44, startY), Offset(size.width - 7, startY), xlines);
    if (datas.isNotEmpty) {
      var p = (size.width - 51) / (labels.length);
      var startX = 44.0 + (p / 2);

      for (var i = 0; i < labels.length; i++) {
        TextSpan xtexts = TextSpan(
          text: labels[i].date,
          style: const TextStyle(
            color: CustomColors.secondaryBlack,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        );

        final xtextPainter = TextPainter(text: xtexts, textDirection: TextDirection.ltr);

        xtextPainter.layout();
        xtextPainter.paint(canvas, Offset(startX - (xtextPainter.size.width / 2), size.height - xtextPainter.height));

        startX += p;
      }

      TextSpan yd =
          const TextSpan(text: "(스코어)", style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontFamily: "SF-Pro"));
      final ydPainter = TextPainter(text: yd, textDirection: TextDirection.ltr);
      ydPainter.layout();
      ydPainter.paint(canvas, Offset.zero);
    }

    var startX = 44.0;
    var sy = part * 4 + 32;
    var p = (size.width - 51) / (labels.length);

    for (var i = 0; i < datas.length; i++) {
      Offset topLeft = Offset(startX, sy);
      Offset bottomRight = Offset(startX + p, sy - ((sy - 32) * (datas[i].avgScore / 100)));

      Rect rect = Rect.fromPoints(topLeft, bottomRight);

      Paint barPaint = Paint()
        ..shader = LinearGradient(
                colors: CustomColors.gradient('GREEN'), begin: Alignment.centerLeft, end: Alignment.centerRight)
            .createShader(rect)
        ..style = PaintingStyle.fill;

      RRect rRect = RRect.fromRectAndCorners(rect, topLeft: Radius.circular(p / 5), topRight: Radius.circular(p / 5));

      canvas.drawRRect(rRect, barPaint);

      startX += p;
    }

    return recorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(_picture);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
