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
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void getSleepState() async {
    final sleepState = await server.getSleepState();
    // setState(() {
    //   _sleepState = sleepState.data;
    // });
    print("getSleepState");
    print(sleepState.data);
    context.read<HomePageProvider>().setSleepState(bool.parse(sleepState.data));
  }

  void getPadOff() async {
    final pref = await SharedPreferences.getInstance();
    final isPO = pref.getBool("isPadOff");

    print("lsajdfhlkasdhflkjahfkljasdlkufjahsdlkjfhakfhalksjdfhjk");

    if (isPO != null) {
      showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
          title: const Text(
            '수면을 종료하시겠습니까?',
            style: TextStyle(fontFamily: "Pretendard"),
          ),
          content: const Text(
            '패드에서 떨어진지 10분이 지났습니다. 수면 종료를 원할시 확인을 눌러주세요.',
            style: TextStyle(fontFamily: "Pretnedard"),
          ),
          actions: [
            BasicDialogAction(
              title: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  color: CustomColors.blue,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

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
    getPadOff();
    getSleepState();
    super.initState();
    _controller.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      server.getMainPage(context.read<HomePageProvider>().serverDate, -1).then((res) {
        print(context.read<HomePageProvider>().serverDate);
        print(res.data);

        MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson(res.data);

        // print(mainPageBiometricData.sleepPatternGraphData);

        context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration =
        BoxDecoration(color: CustomColors.systemWhite, borderRadius: BorderRadius.circular(15));

    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: [
          MainPageHeader(
            controller: controller,
            today: context.watch<HomePageProvider>().today,
            setToday: (val) {
              setState(() {
                _today = val;
              });
              context.read<HomePageProvider>().setServerDate(DateFormat('yyyy-MM-dd').format(val));
            },
          ),
          TodayShortData(
            defaultBoxDecoration: defaultBoxDecoration,
            today: DateFormat('yyyy-MM-dd').format(_today),
          ),
          SleepTimeData(defaultBoxDecoration: defaultBoxDecoration),
          SevenDaysData(defaultBoxDecoration: defaultBoxDecoration),
          WeeklyChangeData(defaultBoxDecoration: defaultBoxDecoration),
          context.watch<HomePageProvider>().mainPageBiometricData != null &&
                  context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
              ? SleepBetterWidget(defaultBoxDecoration: defaultBoxDecoration)
              : Container(),
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
      ),
    );
  }
}
