import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/screen/account_management_page.dart';
import 'package:drberry_app/screen/app_setting_page.dart';
import 'package:drberry_app/screen/sleep_data_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Server server = Server();
  Future<ProfileTabData>? _userData;

  Future<ProfileTabData> getUserData() async {
    final result = server.getProfileTabData().then((value) => ProfileTabData.fromJson(value.data));

    return result;
  }

  @override
  void initState() {
    super.initState();
    _userData = getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: _userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Row(
                        children: [CircularProgressIndicator()],
                      );
                    } else if (snapshot.hasError) {
                      return RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(style: DefaultTextStyle.of(context).style, children: const [
                          TextSpan(
                              text: "안녕하세요 ",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: "오류",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFC2E2E),
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: "님",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                                fontSize: 20,
                              ))
                        ]),
                      );
                    } else {
                      return RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                          const TextSpan(
                              text: "안녕하세요 ",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                                fontSize: 20,
                              )),
                          TextSpan(
                              text: snapshot.data!.userName,
                              style: const TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                                fontSize: 20,
                              )),
                          const TextSpan(
                              text: "님",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                                fontSize: 20,
                              ))
                        ]),
                      );
                    }
                  },
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppSettingPage(),
                        ),
                      );
                    },
                    icon: SvgPicture.asset("assets/SettingIcon.svg"))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: ((deviceWidth - 58) / 3) * 1.2,
                    decoration: BoxDecoration(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/GradientBad.svg"),
                        const SizedBox(height: 4),
                        const Text(
                          "평균 수면 시간",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Pretendard",
                            color: CustomColors.secondaryBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FutureBuilder(
                          future: _userData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text(
                                "오류",
                                style: TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: Color(0xFFFC2E2E),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.avgSleepTime,
                                style: const TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Container(
                    height: ((deviceWidth - 58) / 3) * 1.2,
                    decoration: BoxDecoration(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/GradientData.svg"),
                        const SizedBox(height: 4),
                        const Text(
                          "평균 수면 점수",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Pretendard",
                            color: CustomColors.secondaryBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FutureBuilder(
                          future: _userData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text(
                                "오류",
                                style: TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: Color(0xFFFC2E2E),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.avgSleepScore,
                                style: const TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Container(
                    height: ((deviceWidth - 58) / 3) * 1.2,
                    decoration: BoxDecoration(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/GradientPad.svg"),
                        const SizedBox(height: 4),
                        const Text(
                          "패드 사용일",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Pretendard",
                            color: CustomColors.secondaryBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FutureBuilder(
                          future: _userData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text(
                                "오류",
                                style: TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: Color(0xFFFC2E2E),
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            } else {
                              return Text(
                                snapshot.data!.totalDays,
                                style: const TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 17,
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text("메뉴 ",
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w700,
                    color: CustomColors.secondaryBlack,
                    fontSize: 20,
                  )),
            ),
            const SizedBox(height: 12),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.systemWhite,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountManagePage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 25),
                  height: (deviceWidth - 32) / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/profile.svg"),
                          const SizedBox(width: 8),
                          const Text(
                            "계정관리",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.secondaryBlack,
                              fontFamily: "Pretendard",
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset("assets/ArrowRight.svg")
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.systemWhite,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SleepDataPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 25),
                  height: (deviceWidth - 32) / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/data.svg"),
                          const SizedBox(width: 8),
                          const Text(
                            "수면 데이터 전송",
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.secondaryBlack,
                              fontFamily: "Pretendard",
                            ),
                          )
                        ],
                      ),
                      SvgPicture.asset("assets/ArrowRight.svg")
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: CustomColors.systemWhite,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 25),
                  height: (deviceWidth - 32) / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/call.svg"),
                          const SizedBox(width: 8),
                          const Row(
                            children: [
                              Text(
                                "고객센터",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CustomColors.secondaryBlack,
                                  fontFamily: "Pretendard",
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SvgPicture.asset("assets/ArrowRight.svg")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}