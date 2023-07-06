import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/pattern_chart.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WakeupQualityWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const WakeupQualityWidget({super.key, required this.defaultBoxDecoration});

  @override
  State<WakeupQualityWidget> createState() => _WakeupQualityWidgetState();
}

class _WakeupQualityWidgetState extends State<WakeupQualityWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    WakeupQualityDetailData? wakeupQualityDetailData;
    if (context.watch<HomePageProvider>().mainPageBiometricData != null &&
        context
                .watch<HomePageProvider>()
                .mainPageBiometricData!
                .userBiometricData !=
            null) {
      wakeupQualityDetailData = context
          .watch<HomePageProvider>()
          .mainPageBiometricData!
          .wakeupQualityDetailData!;
    } else {
      wakeupQualityDetailData = null;
    }

    List<Widget> setWakeupQualityDetail() {
      List<Widget> widgets = [];

      var patterns = ['Wake', 'Rem', 'Light', 'Deep'];
      List<String> wakeupQuality = [];
      if (wakeupQualityDetailData != null) {
        wakeupQuality = [
          wakeupQualityDetailData.wakeTime,
          wakeupQualityDetailData.remTime,
          wakeupQualityDetailData.lightTime,
          wakeupQualityDetailData.deepTime
        ];
      } else {
        wakeupQuality = ["0", "0", "0", "0"];
      }
      print(wakeupQuality);

      for (var i = 0; i < wakeupQuality.length; i++) {
        widgets.add(Container(
          margin:
              EdgeInsets.fromLTRB(0, 0, 0, i == wakeupQuality.length ? 0 : 8),
          padding: EdgeInsets.zero,
          child: Text(
            '${patterns[i]} : ${int.parse(wakeupQuality[i]) * 10} min',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: CustomColors.systemGrey2,
                fontFamily: 'SF-Pro'),
          ),
        ));
      }

      return widgets;
    }

    return Center(
      child: Container(
        width: deviceWidth - 32,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        decoration: widget.defaultBoxDecoration,
        padding: const EdgeInsets.fromLTRB(12, 28, 6, 26),
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
                          padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.zero),
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
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
                    '기상 품질 데이터',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith(
                              (states) => EdgeInsets.zero),
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
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
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 13, 44),
              child: RepaintBoundary(
                child: CustomPaint(
                    painter: PatternChart(
                        serverData: context
                                        .watch<HomePageProvider>()
                                        .mainPageBiometricData !=
                                    null &&
                                context
                                        .watch<HomePageProvider>()
                                        .mainPageBiometricData!
                                        .userBiometricData !=
                                    null
                            ? context
                                .watch<HomePageProvider>()
                                .mainPageBiometricData!
                                .wakeupQualityGraphData!
                            : [],
                        size: Size(deviceWidth - 63, 220),
                        labels: context
                                        .watch<HomePageProvider>()
                                        .mainPageBiometricData !=
                                    null &&
                                context
                                        .watch<HomePageProvider>()
                                        .mainPageBiometricData!
                                        .userBiometricData !=
                                    null
                            ? [
                                SleepPatternGraphX(times: '0'),
                                SleepPatternGraphX(times: "60")
                              ]
                            : [],
                        sleepPatternNeedDataNum: []),
                    size: Size(deviceWidth - 63, 220)),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 19),
              width: deviceWidth - 66,
              height: 1,
              color: CustomColors.systemGrey6,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: const Text(
                        '기상 품질 점수',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 30, 0, 10),
                        child: RepaintBoundary(
                          child: CustomPaint(
                              painter: ArcChart(
                                  percentage: context
                                                  .watch<HomePageProvider>()
                                                  .mainPageBiometricData !=
                                              null &&
                                          context
                                                  .watch<HomePageProvider>()
                                                  .mainPageBiometricData!
                                                  .userBiometricData !=
                                              null
                                      ? wakeupQualityDetailData!
                                          .wakeupQualityScore
                                          .toDouble()
                                      : 0,
                                  strokeWidth: deviceWidth * 0.035),
                              size:
                                  Size(deviceWidth * 0.28, deviceWidth * 0.28)),
                        )),
                  ],
                ),
                Container(
                  width: 1,
                  height: 240,
                  margin: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                  color: CustomColors.systemGrey5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: const Text(
                        '기상까지 걸린시간',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: Text(
                        wakeupQualityDetailData != null
                            ? wakeupQualityDetailData.whenWakeTime.toString()
                            : "0m",
                        style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: CustomColors.lightGreen2),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        width: deviceWidth - 233,
                        height: 1,
                        color: CustomColors.systemGrey6),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: const Text(
                        '각 항목에서 걸린시간',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    ...setWakeupQualityDetail()
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
