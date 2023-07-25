import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/categority/categority_widget.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SnoringWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;
  final GlobalKey<CategorityWidgetState> snoringKey;

  const SnoringWidget({super.key, required this.defaultBoxDecoration, required this.snoringKey});

  @override
  State<SnoringWidget> createState() => _SnoringWidgetState();
}

class _SnoringWidgetState extends State<SnoringWidget> {
  final GlobalKey _snoringWidgetKey = GlobalKey();
  double height = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox box = _snoringWidgetKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        height = box.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        double deviceWidth = MediaQuery.of(context).size.width;

        Widget setSnoringDetail() {
          List<Widget> widgets = [];
          List<Widget> states = [];

          var count = ['Quiet (40이하)', 'Light (40-50 dB)', 'Loud (50-60 dB)', 'Epic (70 이상)'];

          var levels = ['Quiet', 'Light', 'Loud', 'Epic'];

          if (context.read<HomePageProvider>().mainPageBiometricData != null &&
              context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData != null) {
            final snoringPercents = context.read<HomePageProvider>().mainPageBiometricData!.nosingPartPercent!;

            for (var i = 0; i < count.length; i++) {
              widgets.add(Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, i == levels.length ? 0 : 8),
                padding: EdgeInsets.zero,
                child: Text(
                  count[i],
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.systemGrey2,
                      fontFamily: 'Pretendard'),
                ),
              ));
              String state;
              NosingPartPercent percent;
              try {
                percent = snoringPercents.firstWhere((element) => element.snoringLevel == levels[i]);
                state = '${percent.cnt.toString().split('.')[0]}%';
              } catch (e) {
                state = '0%';
              }

              states.add(Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, i == levels.length ? 0 : 8),
                padding: EdgeInsets.zero,
                child: Text(
                  state,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8E93),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ));
            }
          } else {
            states = [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.zero,
                child: Text(
                  "0%",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8E93),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.zero,
                child: Text(
                  "0%",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8E93),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.zero,
                child: Text(
                  "0%",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8E93),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                padding: EdgeInsets.zero,
                child: Text(
                  "0%",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E8E93),
                    fontFamily: 'Pretendard',
                  ),
                ),
              )
            ];
          }

          return Container(
              margin: const EdgeInsets.fromLTRB(0, 9, 0, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...widgets],
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [...states],
                      ))
                ],
              ));
        }

        return Center(
          child: Container(
            width: deviceWidth - 32,
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 46),
            padding: const EdgeInsets.fromLTRB(12, 30, 12, 33),
            decoration: widget.defaultBoxDecoration,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 39),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                              overlayColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.transparent;
                                }
                                return null;
                              })),
                          onPressed: () {},
                          child: const Text(
                            '더보기 >',
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.transparent),
                          )),
                      const Text(
                        '코골이',
                        style: TextStyle(fontFamily: 'Pretendard', fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                              overlayColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return CustomColors.systemGrey5;
                                }
                                return null;
                              })),
                          onPressed: () {},
                          child: const Text('더보기 >',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  color: CustomColors.systemGrey2))),
                    ],
                  ),
                ),
                CategorityWidget(
                  key: widget.snoringKey,
                  deviceWidth: deviceWidth,
                  size: Size(deviceWidth, 224),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 28, 0, 16),
                  width: deviceWidth - 66,
                  height: 1,
                  color: CustomColors.systemGrey6,
                ),
                Row(
                  key: _snoringWidgetKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                          child: const Text(
                            '코골이 점수',
                            style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 30, 0, 10),
                            child: RepaintBoundary(
                              child: CustomPaint(
                                  painter: ArcChart(
                                      percentage: context.read<HomePageProvider>().mainPageBiometricData != null &&
                                              context
                                                      .read<HomePageProvider>()
                                                      .mainPageBiometricData!
                                                      .userBiometricData !=
                                                  null
                                          ? context
                                              .read<HomePageProvider>()
                                              .mainPageBiometricData!
                                              .nosingDetailData!
                                              .score
                                              .toDouble()
                                          : 0,
                                      strokeWidth: deviceWidth * 0.035),
                                  size: Size(deviceWidth * 0.28, deviceWidth * 0.28)),
                            )),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 325.h,
                      margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      color: CustomColors.systemGrey5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Text(
                                    '코골이 비율',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  child: Text(
                                    context.read<HomePageProvider>().mainPageBiometricData != null &&
                                            context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData !=
                                                null
                                        ? '${context.read<HomePageProvider>().mainPageBiometricData!.nosingDetailData!.snoringPercent}%'
                                        : "0%",
                                    style: TextStyle(
                                        fontFamily: 'SF-Pro',
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                        color: CustomColors.lightGreen2),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: Text(
                                        '평균 dB',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                      child: Text(
                                        context.read<HomePageProvider>().mainPageBiometricData != null &&
                                                context
                                                        .read<HomePageProvider>()
                                                        .mainPageBiometricData!
                                                        .userBiometricData !=
                                                    null
                                            ? '${context.read<HomePageProvider>().mainPageBiometricData!.nosingDetailData!.avgSnoring} dB'
                                            : "0dB",
                                        style: TextStyle(
                                            fontFamily: 'SF-Pro',
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w700,
                                            color: CustomColors.lightGreen2),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Container(
                            height: 1,
                            width: (deviceWidth - 50) / 2,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                            color: CustomColors.systemGrey5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: Text(
                                    '최대 dB',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  child: Text(
                                    context.read<HomePageProvider>().mainPageBiometricData != null &&
                                            context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData !=
                                                null
                                        ? '${context.read<HomePageProvider>().mainPageBiometricData!.nosingDetailData!.maxSnoring} dB'
                                        : "0dB",
                                    style: const TextStyle(
                                        fontFamily: 'SF-Pro',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: CustomColors.lightGreen2),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: const Text(
                                        '지속구간',
                                        style: TextStyle(
                                            fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                      width: deviceWidth * 0.21,
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                      child: Text(
                                        context.read<HomePageProvider>().mainPageBiometricData != null &&
                                                context
                                                        .read<HomePageProvider>()
                                                        .mainPageBiometricData!
                                                        .userBiometricData !=
                                                    null
                                            ? context
                                                .read<HomePageProvider>()
                                                .mainPageBiometricData!
                                                .nosingDetailData!
                                                .date
                                            : "00:00 ~ 00:00",
                                        style: TextStyle(
                                            fontFamily: 'SF-Pro',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: CustomColors.lightGreen2),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Container(
                            height: 1,
                            width: (deviceWidth - 50) / 2,
                            margin: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                            color: CustomColors.systemGrey5),
                        Text('코골이 비율',
                            style: TextStyle(
                                color: CustomColors.secondaryBlack,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Pretendard')),
                        setSnoringDetail()
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
