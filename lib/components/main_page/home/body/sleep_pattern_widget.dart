import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/pattern_chart.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepPatternWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const SleepPatternWidget({super.key, required this.defaultBoxDecoration});

  @override
  State<SleepPatternWidget> createState() => _SleepPatternWidgetState();
}

class _SleepPatternWidgetState extends State<SleepPatternWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    List<Widget> setSleepPatternDetail() {
      List<Widget> widgets = [];
      List<String> sleepPattern = [];
      if (context.watch<HomePageProvider>().mainPageBiometricData != null &&
          context
                  .watch<HomePageProvider>()
                  .mainPageBiometricData!
                  .userBiometricData !=
              null) {
        final provider = context
            .watch<HomePageProvider>()
            .mainPageBiometricData!
            .sleepPatternDetailData!;

        sleepPattern = [
          provider.wakeupPercent,
          provider.remPercent,
          provider.lightPercent,
          provider.deepPercent
        ];
      } else {
        sleepPattern = [
          "0",
          "0",
          "0",
          "0",
        ];
      }

      var patterns = ["깸", "REM", "얕은", "깊은"];

      print(sleepPattern);

      for (var i = 0; i < sleepPattern.length; i++) {
        var w = [];

        if (sleepPattern[i] == "0") {
          w.add(
            Text(
              '${sleepPattern[i]}%',
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400),
            ),
          );
          w.add(Container(
            margin: EdgeInsets.fromLTRB(0, 0, i < 3 ? 8 : 0, 3),
            width: (deviceWidth - 219) / 4,
            height: 7,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: CustomColors.lightGreen),
          ));
        } else {
          w.add(
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, i < 3 ? 8 : 0, 3),
                width: (deviceWidth - 219) / 4,
                height: 76 * (int.parse(sleepPattern[i]) / 35) + 7,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: CustomColors.lightGreen),
                child: Center(
                  child: Text(
                    '${sleepPattern[i]}%',
                    style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400),
                  ),
                )),
          );
        }

        widgets.add(Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...w,
            Text(
              patterns[i],
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400),
            )
          ],
        ));
      }

      return widgets;
    }

    return Center(
      child: Container(
        width: deviceWidth - 32,
        decoration: widget.defaultBoxDecoration,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        padding: const EdgeInsets.fromLTRB(12, 28, 6, 26),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 39),
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    '수면패턴',
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
                        serverData:
                            context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                    context
                                            .watch<HomePageProvider>()
                                            .mainPageBiometricData!
                                            .userBiometricData !=
                                        null
                                ? context
                                    .watch<HomePageProvider>()
                                    .mainPageBiometricData!
                                    .sleepPatternGraphData!
                                : [],
                        size: Size(deviceWidth - 63, 220),
                        labels: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                context
                                        .watch<HomePageProvider>()
                                        .mainPageBiometricData!
                                        .userBiometricData !=
                                    null
                            ? context
                                .watch<HomePageProvider>()
                                .mainPageBiometricData!
                                .sleepPatternGraphX!
                            : [],
                        sleepPatternNeedDataNum:
                            context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                    context
                                            .watch<HomePageProvider>()
                                            .mainPageBiometricData!
                                            .userBiometricData !=
                                        null
                                ? context
                                    .watch<HomePageProvider>()
                                    .mainPageBiometricData!
                                    .sleepPatternNeedDataNum!
                                : []),
                    size: Size(deviceWidth - 63, 220)),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 17),
              width: deviceWidth - 66,
              height: 1,
              color: CustomColors.systemGrey5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                  child: const Text(
                    '수면 패턴 점수',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                                  ? context
                                      .watch<HomePageProvider>()
                                      .mainPageBiometricData!
                                      .sleepPatternDetailData!
                                      .sleepPatternScore
                                      .toDouble()
                                  : 0,
                              strokeWidth: deviceWidth * 0.035),
                          size: Size(deviceWidth * 0.28, deviceWidth * 0.28)),
                    )),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: setSleepPatternDetail(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
