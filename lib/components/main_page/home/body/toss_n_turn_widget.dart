import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/toss_chart_widget.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TossNTurnWidget extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const TossNTurnWidget({super.key, required this.defaultBoxDecoration});

  @override
  State<TossNTurnWidget> createState() => _TossNTurnWidgetState();
}

class _TossNTurnWidgetState extends State<TossNTurnWidget> {
  final GlobalKey _tossNTurnKey = GlobalKey();
  double height = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox box = _tossNTurnKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        height = box.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    Widget setTossDetail() {
      List<Widget> widgets = [];
      List<Widget> states = [];

      var count = ['20회 이하', '20-30회', '30-40회'];
      var state = ['적음', '정상', '많은'];

      for (var i = 0; i < count.length; i++) {
        widgets.add(Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, i == count.length ? 0 : 8),
          padding: EdgeInsets.zero,
          child: Text(
            count[i],
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: CustomColors.systemGrey2, fontFamily: 'Pretendard'),
          ),
        ));

        states.add(Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, i == count.length ? 0 : 8),
          padding: EdgeInsets.zero,
          child: Text(
            state[i],
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF8E8E93), fontFamily: 'Pretendard'),
          ),
        ));
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
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [...states],
                  ))
            ],
          ));
    }

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
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '뒤척임',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          RepaintBoundary(
            child: CustomPaint(
                painter: TossChart(Size(deviceWidth - 80, 155),
                    tossNTurnGraph: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                            context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.read<HomePageProvider>().mainPageBiometricData!.tossNTurnGraph!
                        : [],
                    tossNTurnGraphY: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                            context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.read<HomePageProvider>().mainPageBiometricData!.tossNTurnGraphY!
                        : TossNTurnGraphY(minToss: "0", maxToss: "0")),
                size: Size(deviceWidth - 80, 155)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 28, 0, 16),
            width: deviceWidth - 66,
            height: 1,
            color: CustomColors.systemGrey5,
          ),
          Row(
            key: _tossNTurnKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: const Text(
                      '뒤척임 점수',
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
                                        .tossNTurnDetailData!
                                        .tossNTurnScore
                                        .toDouble()
                                    : 0,
                                strokeWidth: deviceWidth * 0.035),
                            size: Size(deviceWidth * 0.28, deviceWidth * 0.28)),
                      )),
                ],
              ),
              Container(
                width: 1,
                height: height,
                margin: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                color: CustomColors.systemGrey6,
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
                            child: const Text(
                              '뒤척임 횟수',
                              style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                            child: Text(
                              context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? '${context.read<HomePageProvider>().mainPageBiometricData!.tossNTurnDetailData!.tossNTurnCnt}회'
                                  : "0회",
                              style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
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
                                  '뒤척임 비율',
                                  style: TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                child: Text(
                                  context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                          context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData !=
                                              null
                                      ? '${context.read<HomePageProvider>().mainPageBiometricData!.tossNTurnDetailData!.tossNTurnPercent}%'
                                      : "0%",
                                  style: const TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 28,
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
                      width: (deviceWidth - 80) / 2,
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                      color: CustomColors.systemGrey5),
                  const Text('뒤척임 기준',
                      style: TextStyle(
                          color: CustomColors.secondaryBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Pretendard')),
                  setTossDetail()
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }
}
