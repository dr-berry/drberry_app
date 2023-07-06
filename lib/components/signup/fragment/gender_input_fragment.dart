import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/signup/custom_widget/gender_check_box.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderInputFragment extends StatefulWidget {
  const GenderInputFragment({super.key});

  @override
  State<GenderInputFragment> createState() => _GenderInputFragmentState();
}

class _GenderInputFragmentState extends State<GenderInputFragment> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<SignUpProvider>();
      if (provider.gender.isNotEmpty) {
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
                "성별을 알려주세요.",
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
                "성별",
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GenderCheckBox(gender: "MALE", width: (deviceWidth - 45) / 2),
              GenderCheckBox(gender: "FEMALE", width: (deviceWidth - 45) / 2)
            ],
          ),
        )
      ],
    );
  }
}
