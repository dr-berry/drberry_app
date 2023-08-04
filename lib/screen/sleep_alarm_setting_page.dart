import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/screen/make_sleep_alarm_page.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SleepAlarmSettingPage extends StatefulWidget {
  const SleepAlarmSettingPage({super.key});

  @override
  State<SleepAlarmSettingPage> createState() => _SleepAlarmSettingPageState();
}

class _SleepAlarmSettingPageState extends State<SleepAlarmSettingPage> {
  Future<List<AlarmData>>? datas;

  Future<List<AlarmData>> getDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<AlarmData> result = [];
    final sleepDatasStr = pref.getString("sleepDatas");

    if (sleepDatasStr != null && sleepDatasStr != '[]') {
      final savedsleepDatas = jsonDecode(sleepDatasStr) as List<dynamic>;
      print(savedsleepDatas[0].runtimeType);
      for (var i = 0; i < savedsleepDatas.length; i++) {
        result.add(AlarmData.fromJson(savedsleepDatas[i]));
      }
    }

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

    return result;
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

  List<Widget> getAlarmWidgets(double deviceWidth, List<AlarmData> list) {
    List<Widget> result = [];

    for (var i = 0; i < list.length; i++) {
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
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  final jsonStr = pref.getString('sleepDatas');
                  List<AlarmData> sleepDatas = [];

                  await Alarm.stop(list[i].alarmSettings.id);

                  if (jsonStr != null) {
                    final parsedJson = jsonDecode(jsonStr);
                    for (var i = 0; i < parsedJson.length; i++) {
                      sleepDatas.add(AlarmData.fromJson(parsedJson[i]));
                    }
                  }

                  sleepDatas.removeWhere(
                    (element) => list[i].alarmSettings.id == element.alarmSettings.id,
                  );

                  final sleepDatasJson = sleepDatas.map((e) => e.toJson()).toList();
                  final removeStr = jsonEncode(sleepDatasJson);
                  await pref.setString("sleepDatas", removeStr);

                  value(true);
                  setState(() {
                    datas = getDatas();
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
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: const Color(0xFFF9F9F9),
                  child: Row(
                    children: [
                      Container(
                        width: 126,
                        height: 126,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CustomColors.blue,
                          image: DecorationImage(
                            image: AssetImage(list[i].alarmData['musicInfo']['imageAssets']),
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list[i].alarmData['time'],
                              style: const TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 17,
                                color: CustomColors.secondaryBlack,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Container(
                              width: (deviceWidth - 40) / 2,
                              height: 1,
                              color: const Color(0xFFE5E5EA),
                            ),
                            const SizedBox(height: 9),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/calendar_small.svg',
                                  color: CustomColors.lightGreen2,
                                ),
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
                                  (list[i].alarmData['weekOfNum'].map((element) => getKoreanWeekday(element)))
                                              .toList()
                                              .length >
                                          6
                                      ? '월 ~ 일'
                                      : (list[i].alarmData['weekOfNum'].map((element) => getKoreanWeekday(element)))
                                          .join(','),
                                  style: const TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 15,
                                    overflow: TextOverflow.clip,
                                    color: CustomColors.secondaryBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
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
      body: SafeArea(
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
    );
  }
}
