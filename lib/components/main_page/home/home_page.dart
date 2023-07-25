import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/home/body/heart_rate_widget.dart';
import 'package:drberry_app/components/main_page/home/body/seven_days_data.dart';
import 'package:drberry_app/components/main_page/home/body/sleep_better_widget.dart';
import 'package:drberry_app/components/main_page/home/body/sleep_pattern_widget.dart';
import 'package:drberry_app/components/main_page/home/body/sleep_score_ring_data.dart';
import 'package:drberry_app/components/main_page/home/body/sleep_time_data.dart';
import 'package:drberry_app/components/main_page/home/body/snoring_widget.dart';
import 'package:drberry_app/components/main_page/home/body/today_event_data.dart';
import 'package:drberry_app/components/main_page/home/body/today_short_data.dart';
import 'package:drberry_app/components/main_page/home/body/toss_n_turn_widget.dart';
import 'package:drberry_app/components/main_page/home/body/wakeup_quality_widget.dart';
import 'package:drberry_app/components/main_page/home/body/weekly_change_data.dart';
import 'package:drberry_app/components/main_page/home/header/main_page_header.dart';
import 'package:drberry_app/custom/custom_chart/categority/categority_widget.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/Data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  final controller = BoardDateTimeController();
  OverlayEntry? overlayEntry;
  final GlobalKey<CategorityWidgetState> _snoringKey = GlobalKey<CategorityWidgetState>();
  final Server server = Server();
  DateTime _today = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.userScrollDirection != ScrollDirection.idle) {
      _snoringKey.currentState?.removeAllEntries();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      server.getMainPage(DateFormat("yyyy-MM-dd").format(DateTime.now()), -1).then((res) {
        // print(res.data);

        MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson(res.data);

        context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration =
        BoxDecoration(color: CustomColors.systemWhite, borderRadius: BorderRadius.circular(15));

    return BoardDateTimeBuilder(
        controller: controller,
        pickerType: DateTimePickerType.date,
        options: BoardDateTimeOptions(backgroundColor: CustomColors.systemGrey6, activeColor: CustomColors.lightGreen2),
        builder: (context) {
          return SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: [
                  MainPageHeader(
                    controller: controller,
                    today: _today,
                  ),
                  TodayShortData(
                    defaultBoxDecoration: defaultBoxDecoration,
                    today: DateFormat('yyyy-MM-dd').format(_today),
                  ),
                  SleepTimeData(defaultBoxDecoration: defaultBoxDecoration),
                  SevenDaysData(defaultBoxDecoration: defaultBoxDecoration),
                  WeeklyChangeData(defaultBoxDecoration: defaultBoxDecoration),
                  SleepBetterWidget(defaultBoxDecoration: defaultBoxDecoration),
                  SleepScoreRingData(defaultBoxDecoration: defaultBoxDecoration),
                  context.watch<HomePageProvider>().mainPageBiometricData != null &&
                          context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null &&
                          context.watch<HomePageProvider>().mainPageBiometricData!.todayEvent!.lastDayScore != null
                      ? TodayEventData(defaultBoxDecoration: defaultBoxDecoration)
                      : Container(),
                  SleepPatternWidget(defaultBoxDecoration: defaultBoxDecoration),
                  WakeupQualityWidget(defaultBoxDecoration: defaultBoxDecoration),
                  HeartRateWidget(defaultBoxDecoration: defaultBoxDecoration),
                  TossNTurnWidget(defaultBoxDecoration: defaultBoxDecoration),
                  SnoringWidget(
                    defaultBoxDecoration: defaultBoxDecoration,
                    snoringKey: _snoringKey,
                  ),
                ],
              ));
        },
        onChange: (val) async {
          setState(() {
            _today = val;
          });
          await server.getMainPage(DateFormat("yyyy-MM-dd").format(val), -1).then((res) {
            // print(res.data);
            try {
              MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson(res.data);

              context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
            } catch (e) {
              MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson({
                "userBiometricData": null,
                "components": [],
                "isMultipleData": false,
              });

              context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
              print(e);
            }
          }).catchError((err) {
            MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson({
              "userBiometricData": null,
              "components": [],
              "isMultipleData": false,
            });

            context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
            print(err);
          });
        });
  }
}
