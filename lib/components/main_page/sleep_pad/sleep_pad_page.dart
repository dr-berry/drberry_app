import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return SafeArea(
        child: ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.only(top: 142.h, left: 16.w, right: 16.w),
          // color: CustomColors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/Disconnect.svg",
                width: 361.w,
                height: 383.h,
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
                                    fontSize: 15.sp, color: CustomColors.secondaryBlack, fontWeight: FontWeight.w400),
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
                                    color: const Color(0xFFFC2E2E),
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
                      context: context,
                      builder: (context) {
                        return Container(
                            width: deviceWidth,
                            height: 138.h,
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
                            )));
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
