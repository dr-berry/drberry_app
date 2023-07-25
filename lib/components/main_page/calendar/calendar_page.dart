import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar/calendar_item.dart';
import 'package:drberry_app/components/main_page/calendar/history_graph/history_graph_page.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:drberry_app/server/server.dart';
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
  final ValueNotifier<int> _graphController = ValueNotifier(0);
  final int _segment = 0;
  Server server = Server();

  Future<List<CalendarData>> getCalender(int month) async {
    final data = server.getCalendar(month).then((res) {
      // print(res.data);
      return CalendarData.fromJsonList(res.data);
    }).catchError((err) {
      // print(err);
      return <CalendarData>[];
    });

    return data;
  }

  Future<void> getHistories() async {
    final today = context.read<CalendarPageProvider>().selectedDate;

    await server.getHistories(today).then((value) {
      List<History> result = [];
      List<History> weekResult = [];
      List<History> monthResult = [];

      result.add(History.fromJson(value.data['day']['sleepScore']));
      result.add(History.fromJson(value.data['day']['sleepPattern']));
      result.add(History.fromJson(value.data['day']['wake']));
      result.add(History.fromJson(value.data['day']['heartBeat']));
      result.add(History.fromJson(value.data['day']['snoring']));
      result.add(History.fromJson(value.data['day']['toss']));

      weekResult.add(History.fromJson(value.data['week']['sleepScore']));
      weekResult.add(History.fromJson(value.data['week']['sleepPattern']));
      weekResult.add(History.fromJson(value.data['week']['wake']));
      weekResult.add(History.fromJson(value.data['week']['heartBeat']));
      weekResult.add(History.fromJson(value.data['week']['snoring']));
      weekResult.add(History.fromJson(value.data['week']['toss']));

      monthResult.add(History.fromJson(value.data['month']['sleepScore']));
      monthResult.add(History.fromJson(value.data['month']['sleepPattern']));
      monthResult.add(History.fromJson(value.data['month']['wake']));
      monthResult.add(History.fromJson(value.data['month']['heartBeat']));
      monthResult.add(History.fromJson(value.data['month']['snoring']));
      monthResult.add(History.fromJson(value.data['month']['toss']));

      print("${result.toString()}, ${weekResult.toString()}, ${monthResult.toString()}");

      if (result.isEmpty && weekResult.isEmpty && monthResult.isEmpty) {
        context.read<CalendarPageProvider>().setHistoryList(null);
        context.read<CalendarPageProvider>().setWeekHistoryList(null);
        context.read<CalendarPageProvider>().setMonthHistoryList(null);
      } else {
        context.read<CalendarPageProvider>().setHistoryList(result);
        context.read<CalendarPageProvider>().setWeekHistoryList(weekResult);
        context.read<CalendarPageProvider>().setMonthHistoryList(monthResult);
      }
    }).catchError((err) {
      print(err);
      context.read<CalendarPageProvider>().setHistoryList(null);
      context.read<CalendarPageProvider>().setWeekHistoryList(null);
      context.read<CalendarPageProvider>().setMonthHistoryList(null);
    });
  }

  @override
  void initState() {
    super.initState();

    var controller = ScrollController(
        initialScrollOffset: (148 + (((widget.deviceWidth / 7) * (861 / widget.deviceWidth)) * 6)) * 6,
        keepScrollOffset: false);

    _controller = controller;
    _tabController = TabController(length: 6, vsync: this);

    _isCall = getCalendarData();

    _segmentController.addListener(() {
      if (_segmentController.value == 1) {
        getHistories();
      }
    });
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
                style: TextStyle(
                  fontFamily: "SF-Pro",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
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
                                  controller: _segmentController,
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
                      return context.watch<CalendarPageProvider>().historyList == null &&
                              context.watch<CalendarPageProvider>().weekHistoryList == null &&
                              context.watch<CalendarPageProvider>().monthHistoryList == null
                          ? const Center(
                              child: Text(
                                '아직 데이터가 없습니다..',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 15,
                                  color: CustomColors.systemGrey2,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : context.watch<CalendarPageProvider>().historyList!.isEmpty &&
                                  context.watch<CalendarPageProvider>().weekHistoryList!.isEmpty &&
                                  context.watch<CalendarPageProvider>().monthHistoryList!.isEmpty
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: CustomColors.lightGreen2,
                                    strokeWidth: 2,
                                  ),
                                )
                              : TabBarView(
                                  controller: _tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![0],
                                      history: context.watch<CalendarPageProvider>().historyList![0],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![0],
                                      graphController: _graphController,
                                    ),
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![1],
                                      history: context.watch<CalendarPageProvider>().historyList![1],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![1],
                                      graphController: _graphController,
                                    ),
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![2],
                                      history: context.watch<CalendarPageProvider>().historyList![2],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![2],
                                      graphController: _graphController,
                                    ),
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![3],
                                      history: context.watch<CalendarPageProvider>().historyList![3],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![3],
                                      graphController: _graphController,
                                    ),
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![4],
                                      history: context.watch<CalendarPageProvider>().historyList![4],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![4],
                                      graphController: _graphController,
                                    ),
                                    HistoryGraphPage(
                                      weekHistory: context.watch<CalendarPageProvider>().weekHistoryList![5],
                                      history: context.watch<CalendarPageProvider>().historyList![5],
                                      monthHistory: context.watch<CalendarPageProvider>().monthHistoryList![5],
                                      graphController: _graphController,
                                    )
                                  ],
                                );
                    }
                  },
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: deviceWidth,
                      height: 115,
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
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Color.fromRGBO(0, 0, 0, 0.12),
                                    offset: Offset(0, 3),
                                  ),
                                  BoxShadow(
                                    blurRadius: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.04),
                                    offset: Offset(0, 3),
                                  )
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
                                      "수면 패턴",
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
