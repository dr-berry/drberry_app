import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/circular_chart.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepScoreRingData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const SleepScoreRingData({super.key, required this.defaultBoxDecoration});

  @override
  State<SleepScoreRingData> createState() => _SleepScoreRingDataState();
}

class _SleepScoreRingDataState extends State<SleepScoreRingData> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: deviceWidth - 32,
        decoration: widget.defaultBoxDecoration,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        padding: const EdgeInsets.fromLTRB(12, 26, 12, 53),
        child: Column(
          children: [
            const Center(
              child: Text(
                '슬립 스코어링',
                style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 17),
              ),
            ),
            Center(
                child: Container(
              margin: const EdgeInsets.fromLTRB(0, 33, 0, 27),
              child: const Text(
                '슬립 스코어는 수면 패턴, 기상품질, 심박수, 코골이, 뒤척임 이 5가지 요인 별 점수를 측정하고 자체적인 배점 알고리즘을 통해 산출합니다.',
                style: TextStyle(
                    color: Color(0xFF8E8E93), fontFamily: 'Pretendard', fontWeight: FontWeight.w400, fontSize: 15),
              ),
            )),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 27.76),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('슬립 스코어',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.sleepScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('수면 패턴',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.sleepPatternScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('기상 품질',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.wakeupQualityScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('심박수',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.heartScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('뒤척임',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.tossNTurnScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('코골이',
                          style: TextStyle(fontSize: 15, fontFamily: 'Pretendard', fontWeight: FontWeight.w400)),
                      const SizedBox(height: 19),
                      RepaintBoundary(
                        child: CustomPaint(
                            painter: CircularChart(
                              percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.watch<HomePageProvider>().mainPageBiometricData!.sleepScoreRing!.nosingScore}")
                                  : 0,
                              strokeWidth: 9,
                              scoreStateTextSize: 12,
                              percentageTextSize: 17.78,
                              percentageColor: CustomColors.secondaryBlack,
                            ),
                            size: const Size(85, 85)),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
