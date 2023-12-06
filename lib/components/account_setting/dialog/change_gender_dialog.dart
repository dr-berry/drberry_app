import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeGenderDialog extends StatefulWidget {
  final String gender;
  final Function(String gender) setServerGender;

  const ChangeGenderDialog({
    super.key,
    required this.gender,
    required this.setServerGender,
  });

  @override
  State<ChangeGenderDialog> createState() => _ChangeGenderDialogState();
}

class _ChangeGenderDialogState extends State<ChangeGenderDialog> {
  final _controller = TextEditingController();

  String _gender = "MALE";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _gender = widget.gender;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Container(
            padding: const EdgeInsets.only(top: 19, left: 16, right: 16, bottom: 20),
            height: deviceHeight * 0.6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              color: CustomColors.systemWhite,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 5,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(60, 60, 67, 0.3), borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "취소",
                            style: TextStyle(
                              color: Color.fromARGB(0, 0, 0, 0),
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            "성별",
                            style: TextStyle(
                              color: CustomColors.secondaryBlack,
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Material(
                            color: CustomColors.systemWhite,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "취소",
                                  style: TextStyle(
                                    color: CustomColors.blue,
                                    fontFamily: "Pretendard",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Material(
                        color: _gender == "MALE" ? CustomColors.systemWhite : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            setState(() {
                              _gender = "MALE";
                            });
                          },
                          child: Container(
                            width: deviceWidth - 32,
                            height: 60,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _gender == "MALE" ? CustomColors.lightGreen2 : const Color(0xFFF2F2F7),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _gender == "MALE"
                                    ? SvgPicture.asset('assets/man_on.svg')
                                    : SvgPicture.asset('assets/man_off.svg'),
                                const SizedBox(width: 7),
                                Text(
                                  "남성",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Pretendard",
                                    color: _gender == "MALE" ? CustomColors.lightGreen2 : const Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 13),
                    Material(
                        color: _gender == "FEMALE" ? CustomColors.systemWhite : const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () {
                            setState(() {
                              _gender = "FEMALE";
                            });
                          },
                          child: Container(
                            width: deviceWidth - 32,
                            height: 60,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: _gender == "FEMALE" ? CustomColors.lightGreen2 : const Color(0xFFF2F2F7),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _gender == "FEMALE"
                                    ? SvgPicture.asset('assets/woman_on.svg')
                                    : SvgPicture.asset('assets/woman_off.svg'),
                                const SizedBox(width: 7),
                                Text(
                                  "여성",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Pretendard",
                                    color: _gender == "FEMALE" ? CustomColors.lightGreen2 : const Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                Material(
                    color: CustomColors.lightGreen2,
                    borderRadius: BorderRadius.circular(13),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () {
                        setState(() {
                          widget.setServerGender(_gender);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: deviceWidth - 32,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Center(
                          child: Text(
                            "저장",
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w500,
                              color: CustomColors.systemWhite,
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )));
  }
}
