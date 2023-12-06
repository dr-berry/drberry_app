import 'dart:ui';

import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';

import '../../color/color.dart';

class PatternChart extends CustomPainter {
  final List<SleepPatternGraphData> serverData;
  final List<SleepPatternGraphX> labels;
  final List<SleepPatternNeedDataNum> sleepPatternNeedDataNum;
  final Size size;
  late Picture picture;

  PatternChart(
      {required this.serverData, required this.size, required this.labels, required this.sleepPatternNeedDataNum}) {
    picture = _captureChart(size);
  }

  Picture _captureChart(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    List<List<SleepPatternGraphData>> data = <List<SleepPatternGraphData>>[];

    // print("+++++++++++----------");
    // print(data);
    // print(serverData);
    // print(sleepPatternNeedDataNum);
    // print("+++++++++++----------");
    if (serverData.isNotEmpty && labels.isNotEmpty) {
      if (sleepPatternNeedDataNum.isNotEmpty) {
        List<SleepPatternGraphData> list = List.from(serverData);
        for (var i in sleepPatternNeedDataNum) {
          print(i.cnt);
          print(i.hours);
        }

        for (var i = 0; i < sleepPatternNeedDataNum[0].cnt; i++) {
          list.insert(0, SleepPatternGraphData(sleepPattern: 0, measurementAt: ""));
        }

        if (sleepPatternNeedDataNum.length > 1) {
          for (var i = 0; i < sleepPatternNeedDataNum[1].cnt; i++) {
            list.insert(list.length - 1, SleepPatternGraphData(sleepPattern: 0, measurementAt: ""));
          }
        }

        // print(list.sublist(54, 60).length);
        for (var i = 0; i < list.length - 6; i += 6) {
          data.add(list.sublist(i, i + 6));
        }

        // data.add(list.sublist(0, 6));

        // for (var element in data) {
        //   print(element.length);
        // }
      } else {
        List<SleepPatternGraphData> d = List.from(serverData);
        for (var i = 0; i < 6 - serverData.length; i++) {
          d.add(SleepPatternGraphData(sleepPattern: 0, measurementAt: ""));
        }
        data = [d];
      }
    }

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
    var scoreState = ['깸', 'REM', '얕은', '깊은'];

    for (var i = 0; i < 4; i++) {
      final stateSpan = TextSpan(
          text: scoreState[i],
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Pretendard', color: CustomColors.systemGrey2));

      final statePainter = TextPainter(text: stateSpan, textDirection: TextDirection.ltr);

      statePainter.layout(maxWidth: 48);
      statePainter.paint(canvas, Offset(0, (textStartY + part / 2) - statePainter.height / 2));

      textStartY += part;
    }

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

      startY += part;
      lineNum--;
    }

    canvas.drawLine(Offset(44, startY), Offset(size.width - 7, startY), xlines);
    if (serverData.isNotEmpty && labels.isNotEmpty) {
      var xtextStartY = (size.height - 13).toDouble();
      var startX = 44.0;
      var p = (size.width - 51) / (labels.length - 1);

      // print(size.width);

      for (var i = 0; i < labels.length; i++) {
        TextSpan xtexts;
        if (labels[i].times == "0") {
          xtexts = TextSpan(
              text: "${labels[i].times} min",
              style: const TextStyle(
                  color: CustomColors.secondaryBlack,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400));
        } else if (labels[i].times == "60") {
          xtexts = TextSpan(
              text: '${labels[i].times} min',
              style: const TextStyle(
                  color: CustomColors.secondaryBlack, fontSize: 12, fontFamily: 'SF-Pro', fontWeight: FontWeight.w400));
        } else {
          xtexts = TextSpan(
              text: labels[i].times,
              style: TextStyle(
                  color: CustomColors.secondaryBlack,
                  fontSize: (100 / labels.length) > 12 ? 12 : (100 / labels.length),
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400));
        }

        final xtextPainter = TextPainter(text: xtexts, textDirection: TextDirection.ltr);

        xtextPainter.layout();
        xtextPainter.paint(canvas, Offset(startX - (xtextPainter.size.width / 2), xtextStartY));

        // print(labels[i]);
        // print(startX - (xtextPainter.size.width / 2));

        startX += p;
      }

      const barHeight = 37;
      final barWidth = (size.width - 51) / (data.length * 6);
      // print("barheight $barHeight");

      double runningTotal = 44.0;
      Path barPath = Path();
      Path linePath = Path();

      for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].length; j++) {
          final barTop =
              data[i][j].sleepPattern * barHeight + ((part - barHeight) / 2) + (13 * data[i][j].sleepPattern);
          final barBottom = barTop + barHeight;

          // print("barTop : $barTop, barBottom: $barBottom");

          Rect rect = Rect.fromPoints(
            Offset(runningTotal, barTop.toDouble()),
            Offset(runningTotal + barWidth, barBottom.toDouble()),
          );

          Radius topLeft;
          Radius topRight;
          Radius bottomLeft;
          Radius bottomRight;

          if (j - 1 < 0) {
            if (i == 0) {
              topLeft = const Radius.circular(5);
              bottomLeft = const Radius.circular(5);
            } else {
              if (data[i - 1][data[i - 1].length - 1].sleepPattern == data[i][j].sleepPattern) {
                topLeft = const Radius.circular(0);
                bottomLeft = const Radius.circular(0);
              } else {
                topLeft = const Radius.circular(5);
                bottomLeft = const Radius.circular(5);
              }
            }
          } else {
            if (data[i][j - 1].sleepPattern == data[i][j].sleepPattern) {
              topLeft = const Radius.circular(0);
              bottomLeft = const Radius.circular(0);
            } else {
              topLeft = const Radius.circular(5);
              bottomLeft = const Radius.circular(5);
            }
          }

          var rightNumber = 0;

          if (j + 1 >= data[i].length) {
            if (i + 1 < data.length) {
              if (data[i + 1][0] == data[i][j]) {
                topRight = const Radius.circular(0);
                bottomRight = const Radius.circular(0);
              } else {
                topRight = const Radius.circular(5);
                bottomRight = const Radius.circular(5);
              }
              rightNumber = data[i + 1][0].sleepPattern;
            } else {
              topRight = const Radius.circular(5);
              bottomRight = const Radius.circular(5);
              rightNumber = -1;
            }
          } else {
            if (data[i][j + 1].sleepPattern == data[i][j].sleepPattern) {
              topRight = const Radius.circular(0);
              bottomRight = const Radius.circular(0);
            } else {
              topRight = const Radius.circular(5);
              bottomRight = const Radius.circular(5);
            }
            rightNumber = data[i][j + 1].sleepPattern;
          }

          RRect rRect = RRect.fromRectAndCorners(rect,
              topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight);

          barPath.addRRect(rRect);

          if (rightNumber != -1) {
            double lineTop = (rightNumber * barHeight + ((part - barHeight) / 2) + (13 * rightNumber) + 4).toDouble();
            double lineBottom =
                ((rightNumber * barHeight + ((part - barHeight) / 2) + (13 * rightNumber)) + barHeight - 4).toDouble();

            Rect lineRect = Rect.fromPoints(
                Offset(runningTotal + barWidth,
                    rightNumber > data[i][j].sleepPattern ? barTop + 3.toDouble() : barBottom - 3.toDouble()),
                Offset((runningTotal + barWidth), rightNumber > data[i][j].sleepPattern ? lineBottom : lineTop));

            linePath.addRect(lineRect);
          }
          // 이 항목의 값을 누적 값에 더합니다.
          runningTotal += barWidth;
        }
        Rect rect = Rect.fromPoints(const Offset(0.0, 0.0), Offset(size.width, size.height));

        final Paint barPaint = Paint()
          ..shader = LinearGradient(
                  colors: CustomColors.gradient('GREEN'), begin: Alignment.bottomCenter, end: Alignment.topCenter)
              .createShader(rect)
          ..strokeWidth = 2.0;

        final Paint linePaint = Paint()
          ..shader = LinearGradient(
                  colors: CustomColors.gradient('GREEN'), begin: Alignment.bottomCenter, end: Alignment.topCenter)
              .createShader(rect)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

        canvas.drawPath(barPath, barPaint);
        canvas.drawPath(linePath, linePaint);
      }
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
