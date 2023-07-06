import 'package:drberry_app/data/Data.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import '../../../color/color.dart';

class CategorityChart extends CustomPainter {
  NosingGraphX labels;
  List<NosingGraph> datas;

  final BuildContext context;
  final void Function(
      BuildContext context,
      LongPressStartDetails details,
      NosingGraph data,
      double barWidth,
      Offset localPosition,
      Offset triangleOffset) showDetailInfo;

  final void Function() removeOverlay;
  final double deviceWidth;
  final Size? Function() getSize;

  CategorityChart(
      {required this.context,
      required this.datas,
      required this.labels,
      required this.getSize,
      required this.showDetailInfo,
      required this.deviceWidth,
      required this.removeOverlay});

  @override
  void paint(Canvas canvas, Size size) {
    TouchyCanvas touchyCanvas = TouchyCanvas(context, canvas);

    Paint xlines = Paint()
      ..color = CustomColors.systemGrey5
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    var dashWidth = 4;
    var dashSpace = 4;
    var startY = 0.0;
    var textStartY = 20.0;
    var lineNum = 4;
    var part = (size.height - 44) / 4;
    var scoreState = ['Quiet', 'Light', 'Loud', 'Epic'];

    const topicText = TextSpan(
        text: '(dB)',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'Pretendard',
            color: CustomColors.systemGrey2));

    final topicPainter =
        TextPainter(text: topicText, textDirection: TextDirection.ltr);

    topicPainter.layout(maxWidth: 48);
    topicPainter.paint(canvas, Offset(0, -topicPainter.height));

    for (var i = 0; i < 4; i++) {
      final stateSpan = TextSpan(
          text: scoreState[3 - i],
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard',
              color: CustomColors.systemGrey2));

      final statePainter =
          TextPainter(text: stateSpan, textDirection: TextDirection.ltr);

      statePainter.layout(maxWidth: 48);
      statePainter.paint(
          canvas, Offset(0, (textStartY) - statePainter.height / 2));

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
      canvas.translate(44, 20);
      canvas.drawPath(path, xlines);
      canvas.restore();

      startY += part;
      lineNum--;
    }

    canvas.drawLine(Offset(44, size.height - 24),
        Offset(size.width, size.height - 24), xlines);

    TextSpan minTexts = TextSpan(
        text: labels.minTime,
        style: const TextStyle(
            color: CustomColors.secondaryBlack,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400));

    final minPainter =
        TextPainter(text: minTexts, textDirection: TextDirection.ltr);

    minPainter.layout();
    minPainter.paint(canvas, Offset(44, size.height - minPainter.height));

    TextSpan maxTexts = TextSpan(
        text: labels.minTime,
        style: const TextStyle(
            color: CustomColors.secondaryBlack,
            fontSize: 12,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400));

    final maxPainter =
        TextPainter(text: maxTexts, textDirection: TextDirection.ltr);

    maxPainter.layout();
    maxPainter.paint(canvas,
        Offset(size.width - maxPainter.width, size.height - maxPainter.height));

    var epicY = 20.0;
    var loudY = 20.0 + part;
    var lightY = 20.0 + part * 2;
    var quietY = 20.0 + part * 3;
    // print('loud $epicY, $loudY, $lightY, $quietY');

    var startX = 44.0;
    var maxLength = 0;
    for (var i = 0; i < datas.length; i++) {
      maxLength += datas[i].levelCnt;
    }
    var barX = (size.width - 44) * (1 / maxLength);

    for (var i = 0; i < datas.length; i++) {
      var y = 0.0;

      if (datas[i].snoringLevel == 'Epic') {
        y = epicY;
      } else if (datas[i].snoringLevel == 'Loud') {
        y = loudY;
      } else if (datas[i].snoringLevel == 'Light') {
        y = lightY;
      } else if (datas[i].snoringLevel == 'Quiet') {
        y = quietY;
      }
      var width = barX * datas[i].levelCnt;

      double localX;

      // print('=========');
      // print(getSize()?.width);
      // print(deviceWidth);
      // print('=========');

      double cWidth = getSize()?.width ?? deviceWidth;
      // print(cWidth - 95);

      if (startX + width / 2 + 60 > cWidth + 35) {
        localX = (cWidth + 35) - 135;
      } else {
        localX = startX + width / 2 - 60;
      }

      double triX = ((startX + width / 2) - localX) - 10;
      double triY = 51.2;

      Offset triangleOffset = Offset(triX, triY);
      Offset localPosition = Offset(localX, y - 76);

      Rect rect = Rect.fromPoints(
          Offset(startX, y), Offset(startX + width, size.height - 24));

      Paint paint = Paint()
        ..shader = LinearGradient(
                colors: CustomColors.gradient('GREEN'),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)
            .createShader(rect)
        ..style = PaintingStyle.fill;

      RRect rRect = RRect.fromRectAndCorners(rect,
          topLeft: const Radius.circular(7),
          topRight: const Radius.circular(7));

      touchyCanvas.drawRRect(
        rRect,
        paint,
        onLongPressStart: (details) => showDetailInfo(
            context, details, datas[i], width, localPosition, triangleOffset),
      );

      startX += barX * datas[i].levelCnt;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
