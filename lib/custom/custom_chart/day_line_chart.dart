import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

class DayLineChart extends CustomPainter {
  List<SevenWeekData> data;

  DayLineChart({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    List<SevenWeekData> data = List.from(this.data);
    if (this.data.length < 7) {
      for (var i = 0; i < 7 - this.data.length; i++) {
        var oldDate = this.data[0].date.toString().split("/");
        var date = "";
        if (int.parse(oldDate[1]) > 1) {
          date = '${oldDate[0]}/${int.parse(oldDate[1]) - 1}';
        } else {
          date = '${int.parse(oldDate[0]) - 1}/31';
        }
        data.insert(0, SevenWeekData(sleepScore: 0, date: date));
      }
    }

    Paint xlines = Paint()
      ..color = CustomColors.systemGrey5
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Paint ylines = Paint()
      ..color = const Color.fromRGBO(237, 237, 237, 0.6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint backPoint = Paint()
      ..color = CustomColors.lightGreen2
      ..style = PaintingStyle.fill;

    Paint forPoint = Paint()
      ..color = CustomColors.systemWhite
      ..style = PaintingStyle.fill;

    var dashWidth = 4;
    var dashSpace = 4;
    var startY = 0.0;
    var textStartY = 0.0;
    var lineNum = 4;
    var part = (size.height - 23) / 4;
    var scoreState = ['좋음', '정상', '좋지 않음', '매우 좋지 않음'];

    for (var i = 0; i < 4; i++) {
      final stateSpan = TextSpan(
          text: scoreState[i],
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
              color: CustomColors.systemGrey2));

      final statePainter =
          TextPainter(text: stateSpan, textDirection: TextDirection.ltr);

      statePainter.layout(maxWidth: 48);
      statePainter.paint(
          canvas, Offset(0, (textStartY + part / 2) - statePainter.height / 2));

      textStartY += part;
    }

    while (lineNum > 0) {
      var path = Path();
      path.moveTo(0, startY);
      for (var i = 0; i < size.width - 64; i += dashSpace * 2 + dashWidth) {
        path.lineTo((i + dashWidth).toDouble(), startY);
        path.moveTo((i + dashWidth + dashSpace).toDouble(), startY);
      }
      canvas.save();
      canvas.translate(64, 0);
      canvas.drawPath(path, xlines);
      canvas.restore();

      startY += part;
      lineNum--;
    }

    canvas.drawLine(Offset(64, startY), Offset(size.width, startY), xlines);

    var sY = 8.0;
    var eY = (size.height - 31).toDouble();
    var xtextStartY = (size.height - 13).toDouble();
    var startX = 84.0;
    var p = (size.width - 64 - 14 - 20) / 6;
    var y = 0.0;
    var x = 0.0;
    var pointSize = 14;

    List<Offset> points = [];

    for (var i = 0; i < 7; i++) {
      canvas.drawLine(Offset(startX, sY), Offset(startX, eY), ylines);

      final xtexts = TextSpan(
          text: data[i].date.toString(),
          style: const TextStyle(
              color: CustomColors.secondaryBlack,
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400));

      final xtextPainter =
          TextPainter(text: xtexts, textDirection: TextDirection.ltr);

      xtextPainter.layout();
      xtextPainter.paint(
          canvas, Offset(startX - (xtextPainter.size.width / 2), xtextStartY));

      var score = (100 - data[i].sleepScore) / 100;

      Offset startLine = Offset(x, y);
      Offset endLine = Offset(startX, y = (eY - sY) * score);

      if (i > 0) {
        if (data[i].sleepScore > 0) {
          Rect rect = Rect.fromPoints(startLine, endLine);

          Paint scoreLine = Paint()
            ..shader = LinearGradient(
                    colors: CustomColors.gradient('GREEN'),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
                .createShader(rect)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

          canvas.drawLine(startLine, endLine, scoreLine);
        }
      }

      y = (eY - sY) * score;
      points.add(Offset(startX, y));

      x = startX;

      startX += p;
    }

    for (var i = 0; i < points.length; i++) {
      if (data[i].sleepScore > 0) {
        canvas.drawCircle(points[i], pointSize / 2, backPoint);
        canvas.drawCircle(points[i], (pointSize - 6) / 2, forPoint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
