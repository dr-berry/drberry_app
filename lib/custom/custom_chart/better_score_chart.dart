import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class BetterScoreChart extends CustomPainter {
  int score;
  int maxScore;

  BetterScoreChart({required this.score, required this.maxScore});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()..color = const Color(0xFFF2F2F7);

    final startX = Offset(0, size.height / 2 - 6);
    final endX = Offset(size.width, size.height / 2 + 6);

    Rect bg = Rect.fromPoints(startX, endX);
    RRect background = RRect.fromRectAndRadius(bg, const Radius.circular(6));

    canvas.drawRRect(background, backgroundPaint);

    if (score != 0 && maxScore != 0) {
      final fgEndX = Offset(size.width * (score / maxScore), size.height / 2 + 6);
      Rect fg = Rect.fromPoints(startX, fgEndX);

      Paint forgroundPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Color(0xFF28D96F), CustomColors.lightGreen],
        ).createShader(fg);
      RRect forground = RRect.fromRectAndRadius(fg, const Radius.circular(6));

      canvas.drawRRect(forground, forgroundPaint);
      TextSpan thisScoreText = TextSpan(
        text: '$score점',
        style: const TextStyle(
          fontFamily: "Pretendard",
          fontSize: 13,
          color: Color(0xFF8E8E93),
          fontWeight: FontWeight.w400,
        ),
      );

      TextPainter thisScorePainter = TextPainter(
        text: thisScoreText,
        textDirection: TextDirection.ltr,
      );

      thisScorePainter.layout();

      final thisScoreOffset =
          Offset(size.width * (score / maxScore) - (thisScorePainter.width / 2), size.height - thisScorePainter.height);
      thisScorePainter.paint(canvas, thisScoreOffset);

      TextSpan maxScoreText = TextSpan(
        text: '$maxScore점',
        style: const TextStyle(
          fontFamily: "Pretendard",
          fontSize: 13,
          color: CustomColors.systemBlack,
          fontWeight: FontWeight.w400,
        ),
      );

      TextPainter maxScorePainter = TextPainter(
        text: maxScoreText,
        textDirection: TextDirection.ltr,
      );

      maxScorePainter.layout();

      final maxScoreOffset = Offset(size.width - (maxScorePainter.width / 2), 0);
      maxScorePainter.paint(canvas, maxScoreOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
