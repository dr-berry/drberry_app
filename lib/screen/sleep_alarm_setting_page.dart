import 'dart:convert';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/screen/music_bar.dart';
import 'package:drberry_app/screen/sleep_alarm_make_page.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepAlarmSettingPage extends StatefulWidget {
  const SleepAlarmSettingPage({super.key});

  @override
  State<SleepAlarmSettingPage> createState() => _SleepAlarmSettingPageState();
}

class _SleepAlarmSettingPageState extends State<SleepAlarmSettingPage> {
  Future<List<dynamic>>? datas;
  final BoxController _controller = BoxController();
  final Server _server = Server();

  Future<List<dynamic>> getDatas() async {
    final response = await _server.getAlarms("SLEEP").then((res) {
      return res.data;
    }).catchError((err) {
      return [];
    });

    // result.add(AlarmData(
    //   alarmData: {
    //     "weekOfNum": [1, 3, 5],
    //     "musicInfo": {
    //       "imageAssets": "assets/digital.jpg",
    //       "musicAssets": "assets/alarm-clock-going-off.mp3",
    //       "title": "Test Alarm Sound",
    //     },
    //     "time": '오전 6:30 - 오전 7:30',
    //   },
    //   alarmSettings: AlarmSettings(
    //     id: 0,
    //     dateTime: DateTime.now(),
    //     assetAudioPath: "assets/alarm-clock-going-off.mp3",
    //   ),
    // ));

    return response;
  }

  String getKoreanWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '유효하지 않은 요일';
    }
  }

  List<Widget> getAlarmWidgets(double deviceWidth, List<dynamic> list) {
    print(list);
    List<Widget> result = [];

    for (var i = 0; i < list.length; i++) {
      print(list[i]);
      Map<String, dynamic> music;
      int alarmType;
      String time;
      List<String> weekday;
      print(list[i]['musicTitle']);
      try {
        music = musicList.firstWhere((element) {
          print(element['title']);
          print(list[i]['musicTitle']);
          return element['title'] == list[i]['musicTitle'];
        });
      } catch (e) {
        print(e);
      }
      music = musicList.firstWhere((element) => element['title'] == list[i]['musicTitle']);
      // music = {};
      print(music);
      alarmType = 0;
      final start = DateTime.fromMillisecondsSinceEpoch(int.parse(list[i]['startDate'].toString()), isUtc: true);
      final end = DateTime.fromMillisecondsSinceEpoch(int.parse(list[i]['endDate'].toString()), isUtc: true);
      final dateFormat = DateFormat("HH:mm");
      time = '${dateFormat.format(start)} ~ ${dateFormat.format(end)}';
      weekday = (list[i]['weekdays'] as List<dynamic>)
          .map((res) => getKoreanWeekday(int.parse(res["alarmWeekday"].toString())))
          .toList();

      result.add(
        Container(
          width: deviceWidth,
          height: 174,
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SwipeActionCell(
            key: ObjectKey(list[i]),
            trailingActions: [
              SwipeAction(
                onTap: (value) async {
                  await _server.deleteAlarm(int.parse(list[i]['alarmId'].toString())).then((res) {
                    setState(() {
                      datas = getDatas();
                    });
                  });
                },
                widthSpace: 92,
                title: '삭제',
                icon: SvgPicture.asset('assets/trash.svg'),
                style: const TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
            child: Material(
              color: const Color(0xFFF9F9F9),
              child: InkWell(
                onTap: () {
                  if (list[i] is AlarmData) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeSleepAlarmPage(
                          alarmData: list[i],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MakeSleepAlarmPage(
                          alarmData: list[i],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 126,
                            height: 126,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomColors.systemGrey6,
                              image: DecorationImage(
                                image: AssetImage(music['imageAssets']),
                                fit: BoxFit.cover,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 13,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Text(
                                        music['title'],
                                        style: const TextStyle(
                                          fontFamily: "SF-Pro",
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                alarmType == 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: CustomColors.lightGreen,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                          child: Text(
                                            'AI 알림',
                                            style: TextStyle(
                                              fontFamily: "Pretendard",
                                              fontSize: 11,
                                              color: CustomColors.lightGreen2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: CustomColors.lightBlue,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                          child: Text(
                                            '일반알림',
                                            style: TextStyle(
                                              fontFamily: "Pretendard",
                                              fontSize: 11,
                                              color: CustomColors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 6),
                                Text(
                                  time,
                                  style: const TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 17,
                                    color: CustomColors.secondaryBlack,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: (deviceWidth - 40) / 2,
                              height: 1,
                              color: const Color(0xFFE5E5EA),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset('assets/calendar_small.svg'),
                                      const SizedBox(width: 7),
                                      const Text(
                                        '반복 주기',
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          color: Color(0xFF8E8E93),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        weekday.join(','),
                                        style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    datas = getDatas();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: const Color(0xFFF9F9F9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            // controller.open(DateTimePickerType.time, DateTime.now());
          },
          iconSize: 18,
        ),
        title: const Text(
          "수면 테라피 리스트",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: CustomColors.secondaryBlack,
          ),
        ),
      ),
      body: MusicBar(
        controller: _controller,
        oldBackground: const Color(0xFFF9F9F9),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      '자동으로 재생되는 AI 수면 테라피',
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.secondaryBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          final isChange = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MakeSleepAlarmPage(),
                            ),
                          );

                          if (isChange != null && isChange) {
                            setState(() {
                              datas = getDatas();
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE5E5EA),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: deviceWidth - 32,
                          height: 108,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/sleep_teraphy.svg'),
                              const SizedBox(height: 8),
                              const Text(
                                '새로운 수면 테라피 만들기',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 15,
                                  color: CustomColors.secondaryBlack,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                FutureBuilder(
                  future: datas,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      print("error");
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      print("wating");
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: getAlarmWidgets(deviceWidth, snapshot.data!),
                      );
                    }
                  },
                ),
                // ...getAlarmWidgets(deviceWidth),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
