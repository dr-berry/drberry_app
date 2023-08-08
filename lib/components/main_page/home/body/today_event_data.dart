import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodayEventData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const TodayEventData({super.key, required this.defaultBoxDecoration});

  @override
  State<TodayEventData> createState() => _TodayEventDataState();
}

class _TodayEventDataState extends State<TodayEventData> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    String getType() {
      final provider = context.watch<HomePageProvider>().mainPageBiometricData!.todayEvent!;
      switch (provider.scoreType) {
        case 'HEART_BEAT':
          return '심박수';
        case "TOSS_N_MOVE":
          return "뒤척임";
        case "WAKE_QUALITY":
          return "기상품질";
        case "SLEEP_PATTERN":
          return "수면패턴";
        case "NOSING":
          return "코골이";
        default:
          return "코골이";
      }
    }

    String getMessage() {
      final event = context.watch<HomePageProvider>().mainPageBiometricData!.todayEvent!;

      print('${event.scoreDiff} ${event.lastDayScore} ${event.thisDayScore}');

      return '${getType()} 점수가 어제보다 ${event.scoreDiff}점 ${event.lastDayScore! > event.thisDayScore! ? "떨어졌습니다." : "높아졌습니다!"}';
    }

    return Center(
      child: Container(
        width: deviceWidth - 32,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        padding: const EdgeInsets.fromLTRB(12.5, 30, 20, 33),
        decoration: widget.defaultBoxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: const Text('Today Event',
                  style: TextStyle(fontFamily: 'SF-Pro', fontWeight: FontWeight.w400, fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  width: 120,
                  height: 120,
                  child: RepaintBoundary(
                      child: CustomPaint(
                          painter: ArcChart(
                              percentage: context
                                  .watch<HomePageProvider>()
                                  .mainPageBiometricData!
                                  .todayEvent!
                                  .thisDayScore!
                                  .toDouble(),
                              description: getType(),
                              strokeWidth: deviceWidth * 0.03),
                          size: Size(deviceWidth * 0.3, deviceWidth * 0.3))),
                ),
                Container(
                  width: deviceWidth - 220,
                  constraints: BoxConstraints(maxWidth: deviceWidth - 169),
                  child: Text(
                    getMessage(),
                    style: const TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
