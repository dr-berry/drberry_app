import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = CustomColors.systemWhite
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // 역삼각형의 왼쪽 위 꼭지점
    path.lineTo(0, 3);
    path.lineTo(size.width / 2, size.height); // 역삼각형의 오른쪽 위 꼭지점
    path.lineTo(size.width, 3); // 역삼각형의 아래쪽 꼭지점
    path.lineTo(size.width, 0);
    path.close(); // 경로를 닫음

    Paint linePaint = Paint()
      ..color = CustomColors.lightGreen2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paint);

    Paint hidePaint = Paint()
      ..color = CustomColors.systemWhite
      ..style = PaintingStyle.fill;

    Path linePath = Path();
    linePath.moveTo(-2, -2);
    linePath.lineTo(size.width / 2, size.height - 4);
    linePath.lineTo(size.width + 2, -2);
    linePath.close();

    Path hidePath = Path();
    hidePath.moveTo(-2, -2);
    hidePath.lineTo(size.width + 2, -2);
    hidePath.lineTo(size.width + 2, 0.3);
    hidePath.lineTo(-2, 0.3);
    hidePath.close();

    canvas.drawPath(path, linePaint);
    canvas.drawPath(linePath, hidePaint);
    canvas.drawPath(hidePath, hidePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
