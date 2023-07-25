import 'dart:ui';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

class WaveLineChart extends CustomPainter {
  final List<Offset> dataPoints = [];

  final List<HeartRateGraph> datas;
  late Picture _picture;
  final List<HeartRateGraphX> labels;
  final HeartRateGraphY y;

  WaveLineChart({required Size size, required this.datas, required this.labels, required this.y}) {
    _picture = _captureGraph(size);
  }

  Picture _captureGraph(Size size) {
    if (labels.isNotEmpty) {
      if (labels[labels.length - 1].number != "0") {
        labels.insert(labels.length, HeartRateGraphX(hour: labels[labels.length - 1].hour + 1, number: "0"));
      }
    }

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
    var startY = 0.0;
    var textStartY = 0.0;
    var lineNum = 4;
    var part = (size.height - 23) / 4;
    int minY = 0;
    int maxY = 0;
    if (y.maxHeartRate != "0" && y.minHeartRate != "0") {
      minY = ((double.parse(y.minHeartRate) / 10).floor() * 10);
      maxY = ((double.parse(y.maxHeartRate) / 10).ceil() * 10);
    } else {
      minY = 0;
      maxY = 0;
    }

    for (var i = 0; i < 4; i++) {
      if (i == 0) {
        final stateSpan = TextSpan(
            text: maxY.toString(),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

        final statePainter = TextPainter(text: stateSpan, textDirection: TextDirection.ltr);

        statePainter.layout(maxWidth: 48);
        statePainter.paint(canvas, Offset(0, (textStartY) - statePainter.height / 2));
      }

      textStartY += part;
    }

    while (lineNum > 0) {
      var path = Path();
      path.moveTo(0, startY);
      for (var i = 0; i < size.width - 38; i += dashSpace * 2 + dashWidth) {
        path.lineTo((i + dashWidth).toDouble(), startY);
        path.moveTo((i + dashWidth + dashSpace).toDouble(), startY);
      }
      canvas.save();
      canvas.translate(38, 0);
      canvas.drawPath(path, xlines);
      canvas.restore();

      startY += part;
      lineNum--;
    }

    final stateSpan = TextSpan(
        text: minY.toString(),
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

    final statePainter = TextPainter(text: stateSpan, textDirection: TextDirection.ltr);

    statePainter.layout(maxWidth: 48);
    statePainter.paint(canvas, Offset(0, startY - statePainter.height / 2));

    canvas.drawLine(Offset(33, startY), Offset(size.width - 7, startY), xlines);
    if (datas.isNotEmpty) {
      var xtextStartY = (size.height - 13).toDouble();
      var startX = 33.0;
      var p = (size.width - 51) / (labels.length - 1);

      for (var i = 0; i < labels.length; i++) {
        TextSpan xtexts = TextSpan(
            text: labels[i].hour > 12 ? '오후${labels[i].hour - 12}' : '오전${labels[i].hour}',
            style: const TextStyle(
                color: CustomColors.secondaryBlack,
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400));

        final xtextPainter = TextPainter(text: xtexts, textDirection: TextDirection.ltr);

        xtextPainter.layout();
        xtextPainter.paint(canvas, Offset(startX - (xtextPainter.size.width / 2), xtextStartY));

        startX += p;
      }

      if (int.parse(labels[labels.length - 2].number) < 4) {
        var diffEnd = 4 - int.parse(labels[labels.length - 2].number);
        for (var i = 0; i < diffEnd; i++) {
          datas.insert(
              datas.length, HeartRateGraph(heartRate: datas[datas.length - 1].heartRate, mesurementAt: "00:00"));
        }
        labels[labels.length - 2].number = "4";
      }

      if (int.parse(labels[0].number) < 4) {
        var diffBegin = 4 - int.parse(labels[0].number);
        for (var i = 0; i < diffBegin; i++) {
          datas.insert(0, HeartRateGraph(heartRate: datas[0].heartRate, mesurementAt: "00:00"));
        }
        labels[0].number = "4";
      }

      var graphPart = (size.width - 38) / datas.length;
      var graphX = 38.0;

      for (var i = 0; i < datas.length; i++) {
        var y = ((startY) * (((maxY - minY) - (datas[i].heartRate - minY)) / (maxY - minY)));

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
