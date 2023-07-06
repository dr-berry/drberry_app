import 'package:dio/dio.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:drberry_app/custom/custom_chart/circular_chart.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthDaysWidget extends StatefulWidget {
  final int index;
  final Month month;
  final int segment;
  final ValueNotifier<int> controller;

  const MonthDaysWidget(
      {Key? key, required this.index, required this.month, required this.segment, required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MonthDaysWidgetState();
}

class _MonthDaysWidgetState extends State<MonthDaysWidget> {
  Future<List<CalendarData>>? calendarData;
  Server server = Server();

  Future<List<CalendarData>> getCalender() async {
    final data = server.getCalendar(widget.month.month).then((res) {
      // print(res.data);
      return CalendarData.fromJsonList(res.data);
    }).catchError((err) {
      // print(err);
      return <CalendarData>[];
    });

    return data;
  }

  @override
  void initState() {
    super.initState();
    calendarData = getCalender();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    var days = widget.month.days;
    if (widget.month.days[6].day == 0) {
      days = days.sublist(7);
    }

    return FutureBuilder(
      future: calendarData,
      builder: (context, snapshot) {
        // print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (snapshot.hasError) {
          return const SizedBox.expand(
            child: Text(
              "Cannot load Calendar",
              style: TextStyle(fontFamily: "SF-Pro", fontWeight: FontWeight.w600, fontSize: 20),
            ),
          );
        } else {
          return Expanded(
              child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: (1 / (861 / deviceWidth)),
            ),
            itemCount: days.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, idx) {
              final stringfyToday = DateFormat(
                "yyyy-MM-dd",
              ).format(DateTime(widget.month.year, widget.month.month, days[idx].day));

              int index = snapshot.data!.indexWhere((element) {
                return element.date == stringfyToday;
              });

              int score = 0;
              final provider = context.watch<CalendarPageProvider>();
              // print("=====seg=====");
              // print(provider.pageIndex);
              // print("=====seg=====");

              if (index >= 0) {
                switch (provider.pageIndex) {
                  case 0:
                    score = snapshot.data![index].sleepScore;
                    break;
                  case 1:
                    score = snapshot.data![index].sleepPatternScore;
                    break;
                  case 2:
                    score = snapshot.data![index].wakeScore;
                    break;
                  case 3:
                    score = snapshot.data![index].heartRateScore;
                    break;
                  case 4:
                    score = snapshot.data![index].nosingScore;
                    break;
                  case 5:
                    score = snapshot.data![index].tossNTurnScore;
                    break;
                  default:
                    score = 0;
                }
              }
              // print(provider.pageIndex);

              return days[idx].day > 0
                  ? Material(
                      color: CustomColors.systemWhite,
                      child: InkWell(
                          onTap: () {
                            context
                                .read<CalendarPageProvider>()
                                .setSelectedDate(widget.month.year, widget.month.month, days[idx].day);

                            widget.controller.value = 1;
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      (days[idx].day).toString(),
                                      style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF8E8E93)),
                                    ),
                                    const SizedBox(height: 13),
                                    RepaintBoundary(
                                      child: CustomPaint(
                                          painter: CircularChart(
                                              percentage: score.toDouble(), isScoreState: false, strokeWidth: 5.5),
                                          size: const Size(30, 30)),
                                    ),
                                    const SizedBox(height: 13),
                                    Text(
                                      index < 0 ? "-" : "$score",
                                      style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: CustomColors.systemBlack),
                                    ),
                                  ]),
                              _buildPositioned(deviceWidth, days, idx),
                            ],
                          )),
                    )
                  : _buildRow(deviceWidth, days, idx);
            },
          ));
        }
      },
    );
  }

  Widget _buildPositioned(double deviceWidth, List<Day> days, int idx) {
    if ((days.length <= 35 && idx < 28) || (days.length > 35 && idx < 35)) {
      if (idx % 7 == 0) {
        return Positioned(
          bottom: 0,
          right: 0,
          child: _buildRow(deviceWidth, days, idx),
        );
      } else {
        return Positioned(
          bottom: 0,
          left: 0,
          child: _buildRow(deviceWidth, days, idx),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildRow(double deviceWidth, List<Day> days, int idx) {
    if ((idx <= 35 && idx < 28) || (idx > 35 && idx < 35)) {
      return Row(
        mainAxisAlignment: idx % 7 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: idx == 0 || (idx + 1) % 7 == 0 || idx % 7 == 0 ? deviceWidth / 7 - 20 : deviceWidth / 7,
            height: 1,
            color: const Color(0xFFE5E5EA),
          )
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
