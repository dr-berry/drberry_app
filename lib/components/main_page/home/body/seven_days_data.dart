import 'package:drberry_app/custom/custom_chart/day_line_chart.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SevenDaysData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;

  const SevenDaysData({super.key, required this.defaultBoxDecoration});

  @override
  State<SevenDaysData> createState() => _SevenDaysDataState();
}

class _SevenDaysDataState extends State<SevenDaysData> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 28, 12, 26),
        width: deviceWidth - 32,
        decoration: widget.defaultBoxDecoration,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 32),
                child: const Text(
                  '최근 7일 수면 호전도',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Center(
                child: RepaintBoundary(
              child: CustomPaint(
                  painter: DayLineChart(
                      data: context
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
                              .sevenWeekData!
                          : [
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 6)).month}/${DateTime.now().subtract(const Duration(days: 6)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 5)).month}/${DateTime.now().subtract(const Duration(days: 5)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 4)).month}/${DateTime.now().subtract(const Duration(days: 4)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 3)).month}/${DateTime.now().subtract(const Duration(days: 3)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 2)).month}/${DateTime.now().subtract(const Duration(days: 2)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().subtract(const Duration(days: 1)).month}/${DateTime.now().subtract(const Duration(days: 1)).day}"),
                              SevenWeekData(
                                  sleepScore: -1,
                                  date:
                                      "${DateTime.now().month}/${DateTime.now().day}")
                            ]),
                  size: Size(deviceWidth - 56, 215)),
            ))
          ],
        ),
      ),
    );
  }
}
