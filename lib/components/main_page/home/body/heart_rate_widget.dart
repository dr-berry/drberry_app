import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/wave_line_chart.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartRateWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const HeartRateWidget({super.key, required this.defaultBoxDecoration});

  @override
  State<HeartRateWidget> createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget> {
  final GlobalKey _heartRateKey = GlobalKey();
  double height = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox box = _heartRateKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        height = box.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: deviceWidth - 32,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                    '심박수',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
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
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                child: RepaintBoundary(
                    child: CustomPaint(
                  painter: WaveLineChart(
                      size: Size(deviceWidth - 32 - (12 + 19), 180),
                      datas: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                              context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                          ? context.read<HomePageProvider>().mainPageBiometricData!.heartRateGraph!
                          : [],
                      y: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                              context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                          ? context.read<HomePageProvider>().mainPageBiometricData!.heartRateGraphY!
                          : HeartRateGraphY(maxHeartRate: "0", minHeartRate: "0"),
                      labels: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                              context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                          ? context.read<HomePageProvider>().mainPageBiometricData!.heartRateGraphX!
                          : []),
                  size: Size(deviceWidth - 32 - (12 + 19), 180),
                ))),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 28, 0, 16),
              width: deviceWidth - 66,
              height: 1,
              color: CustomColors.systemGrey5,
            ),
            Row(
              key: _heartRateKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: const Text(
                        '심박수 점수',
                        style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 30, 0, 10),
                        child: RepaintBoundary(
                          child: CustomPaint(
                              painter: ArcChart(
                                  percentage: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                          context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData !=
                                              null
                                      ? context
                                          .read<HomePageProvider>()
                                          .mainPageBiometricData!
                                          .heartRateDetailData!
                                          .heartRateScore
                                          .toDouble()
                                      : 0,
                                  strokeWidth: deviceWidth * 0.035),
                              size: Size(deviceWidth * 0.28, deviceWidth * 0.18)),
                        )),
                  ],
                ),
                Container(
                  width: 1,
                  height: height,
                  margin: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  color: CustomColors.systemGrey5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                      child: const Text(
                        '평균 심박수',
                        style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      width: (deviceWidth - 80) / 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                            child: Text(
                              context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? "${context.read<HomePageProvider>().mainPageBiometricData!.heartRateDetailData!.avgHeartRate}bpm"
                                  : "0bpm",
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: CustomColors.lightGreen2),
                            ),
                          ),
                          // Container(
                          //     width: 47,
                          //     height: 30,
                          //     decoration: BoxDecoration(
                          //         color: CustomColors.lightBlue,
                          //         border: Border.all(
                          //             color: CustomColors.blue,
                          //             width: 1.0,
                          //             style: BorderStyle.solid),
                          //         borderRadius: BorderRadius.circular(15)),
                          //     child: const Center(
                          //       child: Text(
                          //         '보통',
                          //         style: TextStyle(
                          //             color: CustomColors.secondaryBlack,
                          //             fontSize: 13,
                          //             fontFamily: 'Pretendard',
                          //             fontWeight: FontWeight.w400),
                          //       ),
                          //     ))
                        ],
                      ),
                    ),
                    Container(
                        height: 1,
                        width: (deviceWidth - 80) / 2,
                        margin: const EdgeInsets.fromLTRB(0, 4, 0, 12),
                        color: CustomColors.systemGrey5),
                    const Text('범위',
                        style: TextStyle(
                            color: CustomColors.secondaryBlack,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard')),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                      child: Text(
                          context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                  context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                              ? context
                                  .read<HomePageProvider>()
                                  .mainPageBiometricData!
                                  .heartRateDetailData!
                                  .heartBeatRange
                              : "0bpm ~ 0bpm",
                          style: const TextStyle(
                              color: CustomColors.secondaryBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard')),
                    )
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
