import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WeeklyChangeData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const WeeklyChangeData({super.key, required this.defaultBoxDecoration});

  @override
  State<WeeklyChangeData> createState() => _WeeklyChangeDataState();
}

class _WeeklyChangeDataState extends State<WeeklyChangeData> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    Widget getMessage() {
      if (context.watch<HomePageProvider>().mainPageBiometricData != null &&
          context
                  .watch<HomePageProvider>()
                  .mainPageBiometricData!
                  .userBiometricData !=
              null) {
        final provider = context
            .watch<HomePageProvider>()
            .mainPageBiometricData!
            .sleepSuming!;

        if (provider.lastScore == null) {
          return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const [
                    TextSpan(
                      text: '아직 호전도를 측정할 수 없어요',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ]));
        } else if (provider.lastScore! > provider.thisScore) {
          return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                      text: '최근 한 주 간 평균 수면 점수가 ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                        text: "${provider.lastScore! - provider.thisScore}점",
                        style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const TextSpan(
                        text: ' 하락했어요. 좋지 않은 방향이에요.',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w400))
                  ]));
        } else if (provider.lastScore! < provider.thisScore) {
          return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                      text: '최근 한 주 간 평균 수면 점수가 ',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                        text: '${provider.thisScore - provider.lastScore!}점',
                        style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const TextSpan(
                        text: ' 증가했어요. 좋은 호전이에요.',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            fontWeight: FontWeight.w400))
                  ]));
        } else {
          return RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const [
                    TextSpan(
                      text: '최근 한 주 간 평균 수면 점수가 유지되었어요! 이대로만 힘내세요!',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ]));
        }
      } else {
        return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const [
                  TextSpan(
                    text: '아직 호전도를 측정할 수 없어요',
                    style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ]));
      }
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
        padding: const EdgeInsets.fromLTRB(
          12.5,
          0,
          12.5,
          40,
        ),
        decoration: widget.defaultBoxDecoration,
        width: deviceWidth - 32,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(0.0),
                  width: deviceWidth,
                ),
                SizedBox(
                  child: Transform.translate(
                      offset: const Offset(0.0, -14.76),
                      child: Center(
                        child: Stack(
                          children: [
                            SvgPicture.asset('assets/Frame.svg'),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: context
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
                                              .sleepSuming!
                                              .lastScore ==
                                          null
                                      ? Image.asset("assets/NoData.png")
                                      : context
                                                  .watch<HomePageProvider>()
                                                  .mainPageBiometricData!
                                                  .sleepSuming!
                                                  .lastScore! >
                                              context
                                                  .watch<HomePageProvider>()
                                                  .mainPageBiometricData!
                                                  .sleepSuming!
                                                  .thisScore
                                          ? Image.asset("assets/Down.png")
                                          : context
                                                      .watch<HomePageProvider>()
                                                      .mainPageBiometricData!
                                                      .sleepSuming!
                                                      .lastScore! ==
                                                  context
                                                      .watch<HomePageProvider>()
                                                      .mainPageBiometricData!
                                                      .sleepSuming!
                                                      .thisScore
                                              ? Image.asset("assets/Same.png")
                                              : Image.asset("assets/Up.png")
                                  : Image.asset("assets/NoData.png"),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
            Container(
                width: deviceWidth - 57,
                decoration: BoxDecoration(
                    color: CustomColors.systemGrey7,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.fromLTRB(23, 22.5, 23, 22.5),
                child: getMessage()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 26, 0, 10),
                    child: const Text('수면 호전 목표치',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400))),
                RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                      TextSpan(
                          text: context
                                          .watch<HomePageProvider>()
                                          .mainPageBiometricData !=
                                      null &&
                                  context
                                          .watch<HomePageProvider>()
                                          .mainPageBiometricData!
                                          .userBiometricData !=
                                      null
                              ? '3'
                              : "0",
                          style: const TextStyle(
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 42,
                          )),
                      const TextSpan(
                          text: '개월 ',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          )),
                      TextSpan(
                          text: context
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
                                  .sleepSuming!
                                  .sumScore
                                  .toString()
                              : "0",
                          style: const TextStyle(
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 42,
                          )),
                      const TextSpan(
                          text: '점',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          )),
                    ]))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
