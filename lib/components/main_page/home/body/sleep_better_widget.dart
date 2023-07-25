import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/better_score_chart.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepBetterWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const SleepBetterWidget({super.key, required this.defaultBoxDecoration});

  @override
  State<SleepBetterWidget> createState() => _SleepBetterWidgetState();
}

class _SleepBetterWidgetState extends State<SleepBetterWidget> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 26),
        width: deviceWidth - 32,
        decoration: widget.defaultBoxDecoration,
        child: Column(
          children: [
            const Center(
              child: Text(
                '어제 나의 수면 호전도',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Pretendard",
                ),
              ),
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              child: CustomPaint(
                painter: BetterScoreChart(
                    score: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                            context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.watch<HomePageProvider>().mainPageBiometricData!.sleepSuming!.thisScore
                        : 0,
                    maxScore: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                            context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.watch<HomePageProvider>().mainPageBiometricData!.sleepSuming!.sumScore
                        : 0),
                size: Size(deviceWidth - 154, 57),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: "내일 적정 목표 ",
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      color: CustomColors.systemBlack,
                    ),
                  ),
                  TextSpan(
                    text:
                        "${context.watch<HomePageProvider>().mainPageBiometricData != null && context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null ? context.watch<HomePageProvider>().mainPageBiometricData!.sleepSuming!.sumScore : 0}",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 20,
                      color: CustomColors.systemBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(
                    text: "점",
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      color: CustomColors.systemBlack,
                    ),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
