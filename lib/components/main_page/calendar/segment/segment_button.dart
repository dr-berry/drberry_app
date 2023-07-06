import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class CustomSegmentButton extends StatelessWidget {
  const CustomSegmentButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (197 / 2),
      height: 28,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.04), width: 0.5),
        color: CustomColors.systemWhite,
        boxShadow: const [
          BoxShadow(blurRadius: 8, color: Color.fromRGBO(0, 0, 0, 0.12), offset: Offset(0, 3)),
          BoxShadow(blurRadius: 1, color: Color.fromRGBO(0, 0, 0, 0.04), offset: Offset(0, 3))
        ],
      ),
    );
  }
}
