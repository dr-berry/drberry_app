import 'dart:ui';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

class HistoryLineChart extends CustomPainter {
  final List<Offset> dataPoints = [];

  final List<int> datas;
  late Picture _picture;
  final List<String> labels;

  HistoryLineChart({required Size size, required this.datas, required this.labels}) {
    _picture = _captureGraph(size);
  }

  Picture _captureGraph(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()
      ..color = CustomColors.lightGreen2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

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
          style: const TextStyle(fontSize: 12, fontFamily: "SF-Pro", color: Color(0xFF8E8E93)));
      final graphYPainter = TextPainter(text: graphYText, textDirection: TextDirection.ltr);

      graphYPainter.layout();
      graphYPainter.paint(canvas, Offset(0, startY - graphYPainter.height / 2));

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
      var startX = 44.0;
      var p = (size.width - 51) / (labels.length - 1);

      for (var i = 0; i < labels.length; i++) {
        TextSpan xtexts = TextSpan(
            text: labels[i],
            style: const TextStyle(
                color: CustomColors.secondaryBlack,
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400));

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

      var graphPart = (size.width - 44) / (datas.length - 1);
      var graphX = 44.0;

      for (var i = 0; i < datas.length; i++) {
        var score = (100 - datas[i]) / 100;
        var y = (startY - 55) * score + 23;

        dataPoints.add(Offset(graphX, y));

        graphX += graphPart;
      }

      final gradientPaint = Paint()
        ..shader = const LinearGradient(
                colors: [CustomColors.lightGreen2, Color(0xFFEAF8E0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)
            .createShader(Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)));

      final path = Path();
      final fillPath = Path();

      // 첫번째 데이터 포인트로 경로를 이동합니다.
      path.moveTo(dataPoints[0].dx, dataPoints[0].dy);
      fillPath.moveTo(dataPoints[0].dx, startY); // 채우기 경로는 화면 바닥에서 시작합니다.
      fillPath.lineTo(dataPoints[0].dx, dataPoints[0].dy);

      for (int i = 0; i < dataPoints.length - 1; i++) {
        final xCenter = (dataPoints[i].dx + dataPoints[i + 1].dx) / 2;
        final yCenter = (dataPoints[i].dy + dataPoints[i + 1].dy) / 2;

        // 현재 포인트에서 중간 포인트까지 베지어 곡선을 그립니다.
        path.quadraticBezierTo(
          dataPoints[i].dx,
          dataPoints[i].dy,
          xCenter,
          yCenter,
        );
        fillPath.quadraticBezierTo(
          dataPoints[i].dx,
          dataPoints[i].dy,
          xCenter,
          yCenter,
        );
      }

      // 마지막 데이터 포인트로 직선을 그립니다.
      path.lineTo(dataPoints.last.dx, dataPoints.last.dy);
      fillPath.lineTo(dataPoints.last.dx, dataPoints.last.dy);
      fillPath.lineTo(dataPoints.last.dx, startY); // 채우기 경로는 화면 바닥에서 종료합니다.

      canvas.drawPath(fillPath, gradientPaint); // 그라데이션을 채웁니다.
      canvas.drawPath(path, paint); // 곡선을 그립니다.
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
