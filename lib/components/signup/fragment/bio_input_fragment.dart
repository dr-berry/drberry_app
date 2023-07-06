import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BioInputFragment extends StatefulWidget {
  const BioInputFragment({super.key});

  @override
  State<BioInputFragment> createState() => _BioInputFragmentState();
}

class _BioInputFragmentState extends State<BioInputFragment> {
  final tallController = TextEditingController();
  final weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<SignUpProvider>();

      if (provider.tall > 0) {
        tallController.text = provider.tall.toString();
      }
      if (provider.weight > 0) {
        weightController.text = provider.weight.toString();
      }

      if (provider.tall > 0 && provider.weight > 0) {
        provider.setDisabled(true);
      }
    });
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
                "바이오 데이터 정보를 입력해 주세요.",
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
                "신장",
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.systemGrey2),
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: deviceWidth * 0.6,
                  margin: const EdgeInsets.only(top: 4),
                  child: TextField(
                    controller: tallController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        context
                            .read<SignUpProvider>()
                            .setTall(int.parse(value));
                      } else {
                        context.read<SignUpProvider>().setTall(0);
                      }

                      if (context.read<SignUpProvider>().tall > 0 &&
                          context.read<SignUpProvider>().weight > 0) {
                        context.read<SignUpProvider>().setDisabled(true);
                      } else {
                        context.read<SignUpProvider>().setDisabled(false);
                      }
                    },
                    cursorColor: Colors.black,
                    cursorHeight: 17,
                    style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    decoration: const InputDecoration(
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
                        hintText: "170",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        hintStyle: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color(0xFFAEAEB2))),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const Text(
                  "CM",
                  style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: CustomColors.systemBlack),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 22),
              child: const Text(
                "몸무게",
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: CustomColors.systemGrey2),
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: deviceWidth * 0.6,
                  margin: const EdgeInsets.only(top: 4),
                  child: TextField(
                    controller: weightController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        context
                            .read<SignUpProvider>()
                            .setWeight(int.parse(value));
                      } else {
                        context.read<SignUpProvider>().setWeight(0);
                      }

                      print(context.read<SignUpProvider>().tall > 0 &&
                          context.read<SignUpProvider>().weight > 0);

                      if (context.read<SignUpProvider>().tall > 0 &&
                          context.read<SignUpProvider>().weight > 0) {
                        context.read<SignUpProvider>().setDisabled(true);
                      } else {
                        context.read<SignUpProvider>().setDisabled(false);
                      }
                    },
                    cursorColor: Colors.black,
                    cursorHeight: 17,
                    style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    decoration: const InputDecoration(
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
                        hintText: "50",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        hintStyle: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color(0xFFAEAEB2))),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: const Text(
                  "KG",
                  style: TextStyle(
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: CustomColors.systemBlack),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
