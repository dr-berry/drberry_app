import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SleepPadPage extends StatefulWidget {
  const SleepPadPage({super.key});

  @override
  State<SleepPadPage> createState() => _SleepPadPageState();
}

class _SleepPadPageState extends State<SleepPadPage> {
  Server server = Server();
  Future<UseTime>? _useTime;

  Future<UseTime> getUseTime() async {
    final useTime = server.getUseDeviceData().then((value) {
      return UseTime.fromJson(value.data);
    }).catchError((err) {
      return UseTime(totalDays: "", totalUseTime: "");
    });

    return useTime;
  }

  @override
  void initState() {
    super.initState();
    _useTime = getUseTime();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.only(top: 90, left: 16, right: 16),
      // color: CustomColors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/Connect.svg",
            width: deviceWidth - 32,
          ),
          const SizedBox(height: 20),
          Expanded(
              child: FutureBuilder(
            future: _useTime,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "총 사용 일수",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "총 사용 시간",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    ))
                  ],
                );
              } else if (snapshot.hasError) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "총 사용 일수",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "오류",
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: "SF-Pro",
                                color: Color(0xFFFC2E2E),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "총 사용 시간",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "오류",
                            style: TextStyle(
                                fontSize: 24,
                                fontFamily: "SF-Pro",
                                color: Color(0xFFFC2E2E),
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ))
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "총 사용 일수",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            snapshot.data!.totalDays,
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: "SF-Pro",
                                color: CustomColors.systemBlack,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "총 사용 시간",
                            style: TextStyle(
                                fontSize: 15, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            snapshot.data!.totalUseTime,
                            style: const TextStyle(
                                fontSize: 24,
                                fontFamily: "SF-Pro",
                                color: CustomColors.systemBlack,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ))
                  ],
                );
              }
            },
          )),
          const SizedBox(
            height: 20,
          ),
          Material(
            color: CustomColors.systemWhite,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                showBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                        width: deviceWidth,
                        height: 138,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            color: CustomColors.systemWhite,
                            boxShadow: [
                              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.4), blurRadius: 15, offset: Offset(0, -1))
                            ]),
                        child: Center(
                            child: SizedBox(
                          width: deviceWidth,
                          height: 60,
                          child: Material(
                              color: CustomColors.systemWhite,
                              child: InkWell(
                                onTap: () {
                                  print("tap!");
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                                    alignment: Alignment.center,
                                    width: deviceWidth,
                                    child: const Text(
                                      "기기변경",
                                      style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFFC2E2E)),
                                    )),
                              )),
                        )));
                  },
                );
              },
              child: Container(
                width: deviceWidth - 32,
                padding: const EdgeInsets.only(left: 20, right: 25),
                height: 68,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "메뉴 선택",
                      style: TextStyle(
                          color: CustomColors.systemBlack,
                          fontSize: 16,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w400),
                    ),
                    SvgPicture.asset("assets/ArrowRight.svg")
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32)
        ],
      ),
    );
  }
}
