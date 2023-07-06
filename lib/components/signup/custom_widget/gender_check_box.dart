import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GenderCheckBox extends StatefulWidget {
  final String gender;
  final double width;

  const GenderCheckBox({super.key, required this.gender, required this.width});

  @override
  State<GenderCheckBox> createState() => _GenderCheckBoxState();
}

class _GenderCheckBoxState extends State<GenderCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final provider = context.read<SignUpProvider>();
        provider.setGender(widget.gender);
        provider.setDisabled(true);
      },
      child: Container(
        height: 62,
        width: widget.width,
        decoration: BoxDecoration(
            border: Border.all(
                color: context.watch<SignUpProvider>().gender == widget.gender
                    ? CustomColors.lightGreen2
                    : const Color(0xffe5e5ea),
                width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(13))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context.watch<SignUpProvider>().gender == widget.gender
                ? widget.gender == "MALE"
                    ? SvgPicture.asset('assets/man_on.svg')
                    : SvgPicture.asset("assets/woman_on.svg")
                : widget.gender == "MALE"
                    ? SvgPicture.asset('assets/man_off.svg')
                    : SvgPicture.asset("assets/woman_off.svg"),
            Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                widget.gender,
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500,
                    color:
                        context.watch<SignUpProvider>().gender == widget.gender
                            ? CustomColors.lightGreen2
                            : const Color(0xFF8E8E93)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
