import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BirthInputFragment extends StatefulWidget {
  final void Function(double selectDate) datePicker;

  const BirthInputFragment({
    super.key,
    required this.datePicker,
  });

  @override
  State<BirthInputFragment> createState() => _BirthInputFragmentState();
}

class _BirthInputFragmentState extends State<BirthInputFragment> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SignUpProvider>();

      controller.text = provider.birth;

      if (provider.birth.isNotEmpty) {
        provider.setDisabled(true);
      }
    });
  }

  @override
  void didUpdateWidget(covariant BirthInputFragment oldWidget) {
    final provider = context.watch<SignUpProvider>();
    controller.text = provider.birth;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: const Text(
                "생년월일이 어떻게 되시나요?",
                style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 20,
                    color: CustomColors.systemBlack,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 61, left: 22),
              child: const Text(
                "생년월일",
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.systemGrey2),
              ),
            )
          ],
        ),
        Center(
          child: Container(
              width: deviceWidth - 32,
              margin: const EdgeInsets.only(top: 4),
              child: GestureDetector(
                onTap: () {
                  widget.datePicker(222.0);
                },
                child: TextField(
                  onChanged: (value) {
                    final provider = context.watch<SignUpProvider>();
                    if (value.isNotEmpty) {
                      provider.setDisabled(true);
                    } else {
                      provider.setDisabled(false);
                    }
                  },
                  controller: controller,
                  cursorColor: Colors.black,
                  cursorHeight: 17,
                  enabled: false,
                  style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  decoration: const InputDecoration(
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: "2000.01.01",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      hintStyle: TextStyle(
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Color(0xFFAEAEB2))),
                ),
              )),
        ),
      ],
    );
  }
}
