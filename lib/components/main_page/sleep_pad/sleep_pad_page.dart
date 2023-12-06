import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/screen/ble_n_wifi_link_page.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepPadPage extends StatefulWidget {
  const SleepPadPage({super.key});

  @override
  State<SleepPadPage> createState() => _SleepPadPageState();
}

class _SleepPadPageState extends State<SleepPadPage> {
  Server server = Server();
  Future<UseTime>? _useTime;
  Future<dynamic>? _state;

  void getSleepState() async {
    print("getSleepState");
    final sleepState = await server.getSleepState();
    // setState(() {
    //   _sleepState = sleepState.data;
    // });
    context.read<HomePageProvider>().setSleepState(bool.parse(sleepState.data));
  }

  void getPadOff() async {
    final pref = await SharedPreferences.getInstance();
    final isPO = pref.getBool("isPadOff");

    print("lsajdfhlkasdhflkjahfkljasdlkufjahsdlkjfhakfhalksjdfhjk");

    if (isPO != null) {
      showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
          title: const Text(
            '수면을 종료하시겠습니까?',
            style: TextStyle(fontFamily: "Pretendard"),
          ),
          content: const Text(
            '패드에서 떨어진지 10분이 지났습니다. 수면 종료를 원할시 확인을 눌러주세요.',
            style: TextStyle(fontFamily: "Pretnedard"),
          ),
          actions: [
            BasicDialogAction(
              title: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  color: CustomColors.blue,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  Future<UseTime> getUseTime() async {
    final useTime = server.getUseDeviceData().then((value) {
      print(value.data);
      return UseTime.fromJson(value.data);
    }).catchError((err) {
      return UseTime(totalDays: "", totalUseTime: "");
    });

    return useTime;
  }

  Future<dynamic> checkDeviceState() async {
    final state = server.deviceState().then(
      (value) {
        return value.data;
      },
    ).catchError((err) {
      return {"state": "disconnected"};
    });

    return state;
  }

  @override
  void initState() {
    getPadOff();
    getSleepState();
    super.initState();
    _useTime = getUseTime();
    _state = checkDeviceState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.only(top: 70.h, left: 16.w, right: 16.w),
          // color: CustomColors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _state,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SvgPicture.asset(
                      "assets/Disconnect.svg",
                      width: 361.w,
                      height: 383.h,
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 361.w,
                      height: 383.h,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CustomColors.lightGreen,
                      ),
                    );
                  } else {
                    switch (snapshot.data['state']) {
                      case 'connected':
                        return SvgPicture.asset(
                          "assets/Connect.svg",
                          width: 361.w,
                          height: 383.h,
                        );
                      case 'disconnected':
                        return SvgPicture.asset(
                          "assets/Disconnect.svg",
                          width: 361.w,
                          height: 383.h,
                        );
                      case 'padOn':
                        return SvgPicture.asset(
                          "assets/OnPad.svg",
                          width: 361.w,
                          height: 383.h,
                        );
                      default:
                        return SvgPicture.asset(
                          "assets/Disconnect.svg",
                          width: 361.w,
                          height: 383.h,
                        );
                    }
                  }
                },
              ),
              SizedBox(height: 20.h),
              FutureBuilder(
                future: _useTime,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 일수",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              const CircularProgressIndicator()
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 시간",
                                style: TextStyle(
                                    fontSize: 15.sp, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                              ),
                              const CircularProgressIndicator()
                            ],
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 일수",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                snapshot.data!.totalDays,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontFamily: "SF-Pro",
                                  color: const Color(0xFFFC2E2E),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 시간",
                                style: TextStyle(
                                    fontSize: 15.sp, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                snapshot.data!.totalUseTime,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontFamily: "SF-Pro",
                                    color: const Color(0xFFFC2E2E),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 일수",
                                style: TextStyle(
                                    fontSize: 15.sp, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Text(
                                snapshot.data!.totalDays,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontFamily: "SF-Pro",
                                    color: CustomColors.systemBlack,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          width: (deviceWidth - 52.w) / 2,
                          height: 93.h,
                          decoration: const BoxDecoration(
                              color: CustomColors.systemWhite, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "총 사용 시간",
                                style: TextStyle(
                                    fontSize: 15.sp, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                snapshot.data!.totalUseTime,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontFamily: "SF-Pro",
                                    color: CustomColors.systemBlack,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              Material(
                color: CustomColors.systemWhite,
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    showModalBottomSheet(
                      elevation: 10,
                      backgroundColor: Colors.white,
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: deviceWidth,
                              height: 80.h,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                color: CustomColors.systemWhite,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: deviceWidth,
                                  height: 60.h,
                                  child: Material(
                                    color: CustomColors.systemWhite,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const SplashPage(
                                              type: "reconnect",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                                        alignment: Alignment.center,
                                        width: deviceWidth,
                                        child: const Text(
                                          "네트워크 연결",
                                          style: TextStyle(
                                            fontFamily: "Pretendard",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: deviceWidth,
                              height: 80.h,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                color: CustomColors.systemWhite,
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: deviceWidth,
                                  height: 60.h,
                                  child: Material(
                                      color: CustomColors.systemWhite,
                                      child: InkWell(
                                        onTap: () {},
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
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: deviceWidth - 32,
                    padding: EdgeInsets.only(left: 20.w, right: 25.w),
                    height: 68.h,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "메뉴 선택",
                          style: TextStyle(
                              color: CustomColors.systemBlack,
                              fontSize: 16.h,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w400),
                        ),
                        SvgPicture.asset("assets/ArrowRight.svg")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
