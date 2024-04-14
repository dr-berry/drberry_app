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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.transparent,
                  ),
                ),
                const Text(
                  '나의 수면 호전도',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Pretendard",
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          title: Text(
                            '수면 호전도란?',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                            ),
                          ),
                          content: Text(
                            '수면 호전도란, 유저분들께서 패드를 사용하신 뒤 축적된 수면 데이터들의 평균을 기반으로 유저분들의 수면 스코어가 더욱 개선 될 수 있는 정도의 수치를 제공해 줌으로써 유저분들이 현제 목표 수면 스코어보다 얼마나 부족한지 인지하고 수면 개선에 도움을 주는 데이터입니다.',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: CustomColors.systemWhite,
                          surfaceTintColor: CustomColors.systemWhite,
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            RepaintBoundary(
              child: CustomPaint(
                painter: BetterScoreChart(
                    score: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                            context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.watch<HomePageProvider>().mainPageBiometricData!.sleepSuming!.thisScore!
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
