import 'dart:math';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar/calendar_item.dart';
import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Day {
  int day;
  int score;

  Day({required this.day, required this.score});
}

class Month {
  int year;
  int month;
  List<Day> days;

  Month({required this.year, required this.month, required this.days});
}

class CalendarPage extends StatefulWidget {
  final double deviceWidth;

  const CalendarPage({super.key, required this.deviceWidth});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final ValueNotifier<int> _segmentController = ValueNotifier(0);
  ScrollController? _controller;
  Future<List<Month>>? _isCall;
  TabController? _tabController;
  final int _segment = 0;

  @override
  void initState() {
    super.initState();

    var controller = ScrollController(
        initialScrollOffset: (148 + (((widget.deviceWidth / 7) * (861 / widget.deviceWidth)) * 6)) * 6,
        keepScrollOffset: false);

    _controller = controller;
    _tabController = TabController(length: 6, vsync: this);

    _isCall = getCalendarData();
  }

  Future<List<Month>> getCalendarData() async {
    DateTime firstDate = DateTime(DateTime.now().year, DateTime.now().month - 6, 1);
    List<Month> cal = [];

    for (var i = 0; i < 13; i++) {
      List<Day> days = [];
      DateTime thisMonth = DateTime(firstDate.year, firstDate.month + i + 1, 1).subtract(const Duration(days: 1));
      Month month;
      var first = DateTime(thisMonth.year, thisMonth.month, 1);
      if (DateFormat("E요일", "ko_KR").format(first) != "월요일") {
        for (var j = 0; j < first.weekday; j++) {
          days.add(Day(day: 0, score: -1));
          // print(
          //     "${DateFormat("E요일", "ko_KR").format(first)} : ${first.weekday} : ${DateFormat("E요일", "ko_KR").format(first) != "월요일"}");
        }
      }
      for (var j = 0; j < thisMonth.day; j++) {
        days.add(Day(day: j + 1, score: -1));
      }

      for (var j = 0; j < days.length % 7; j++) {
        days.add(Day(day: 0, score: 0));
      }
      month = Month(year: thisMonth.year, month: thisMonth.month, days: days);
      cal.add(month);
    }

    return cal;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    print("rendering!");

    return FutureBuilder(
      future: _isCall,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.expand(
            child: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const SizedBox.expand(
              child: Text(
                "Cannot load Calendar",
                style: TextStyle(fontFamily: "SF-Pro", fontWeight: FontWeight.w600, fontSize: 20),
              ),
            );
          } else {
            // context.read<CalendarPageProvider>().setCalendarData(snapshot.data!);
            return Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: _segmentController,
                  builder: (context, value, child) {
                    if (value == 0) {
                      return Container(
                        padding: const EdgeInsets.only(top: 115),
                        child: CustomScrollView(
                          controller: _controller,
                          slivers: [
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return CalendarItem(
                                  index: index,
                                  month: snapshot.data![index],
                                  segment: _segment,
                                );
                              },
                              childCount: snapshot.data!.length,
                            ))
                          ],
                        ),
                      );
                    } else {
                      return SizedBox.expand(
                        child: Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: deviceWidth,
                      height: 115,
                      color: CustomColors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: deviceWidth,
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              color: Colors.white,
                              child: Center(
                                  child: AdvancedSegment(
                                controller: _segmentController,
                                backgroundColor: const Color.fromRGBO(118, 118, 128, 0.12),
                                segments: const {0: "캘린더", 1: "그래프"},
                                activeStyle: const TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: CustomColors.lightGreen2),
                                inactiveStyle: const TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: CustomColors.secondaryBlack,
                                ),
                                animationDuration: const Duration(milliseconds: 250),
                                itemPadding: const EdgeInsets.only(left: 30, right: 30, top: 7, bottom: 7),
                                shadow: const [
                                  BoxShadow(blurRadius: 8, color: Color.fromRGBO(0, 0, 0, 0.12), offset: Offset(0, 3)),
                                  BoxShadow(blurRadius: 1, color: Color.fromRGBO(0, 0, 0, 0.04), offset: Offset(0, 3))
                                ],
                              ))),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                color: Colors.white,
                              ),
                              child: DefaultTabController(
                                length: 6,
                                child: TabBar(
                                  isScrollable: true,
                                  tabs: [
                                    Text(
                                      "수면 스코어",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 0
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                    Text(
                                      "수면패턴",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 1
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                    Text(
                                      "기상 품질",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 2
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                    Text(
                                      "심박수",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 3
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                    Text(
                                      "코골이",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 4
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                    Text(
                                      "뒤척임",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: context.watch<CalendarPageProvider>().pageIndex != 5
                                              ? FontWeight.w400
                                              : FontWeight.w600),
                                    ),
                                  ],
                                  indicator: const ContainerTabIndicator(
                                      height: 2,
                                      radius: BorderRadius.all(Radius.circular(2)),
                                      color: CustomColors.secondaryBlack,
                                      padding: EdgeInsets.only(top: 16)),
                                  onTap: (value) {
                                    print(value);
                                    context.read<CalendarPageProvider>().setIndex(value);
                                  },
                                  controller: _tabController,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            );
          }
        }
      },
    );
  }
}
