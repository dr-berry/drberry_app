import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/screen/wake_alarm_make_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmData {
  AlarmSettings alarmSettings;
  Map<String, dynamic> alarmData;

  AlarmData({
    required this.alarmData,
    required this.alarmSettings,
  });

  factory AlarmData.fromJson(Map<String, dynamic> jsonData) {
    var json = jsonData['alarmSettings'];

    // print('===========');
    // print(json);
    // print(DateTime.fromMicrosecondsSinceEpoch(json['dateTime']));
    // print('===========');

    return AlarmData(
      alarmData: jsonData['alarmData'],
      alarmSettings: AlarmSettings(
        id: json['id'],
        dateTime: DateTime.fromMicrosecondsSinceEpoch(json['dateTime']),
        assetAudioPath: json['assetAudioPath'],
        loopAudio: json['loopAudio'],
        vibrate: json['vibrate'],
        fadeDuration: json['fadeDuration'],
        notificationBody: json['notificationBody'],
        notificationTitle: json['notificationTitle'],
        enableNotificationOnKill: json['enableNotificationOnKill'],
        stopOnNotificationOpen: json['stopOnNotificationOpen'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "alarmSettings": alarmSettings,
      "alarmData": alarmData,
    };
  }
}

class WakeAlarmSettingPage extends StatefulWidget {
  const WakeAlarmSettingPage({super.key});

  @override
  State<WakeAlarmSettingPage> createState() => _WakeAlarmSettingPageState();
}

class _WakeAlarmSettingPageState extends State<WakeAlarmSettingPage> {
  Future<List<dynamic>>? datas;

  final Server _server = Server();

  DateTime setAlarm(List<int> selectCircleDate, int hour, int minute) {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

    if (selectCircleDate.isEmpty) {
      if (alarmTime.isBefore(now)) {
        return alarmTime.add(const Duration(days: 1));
      } else {
        return alarmTime;
      }
    } else {
      int todayWeekday = now.weekday; // Monday is 1, Sunday is 7
      bool todayIncluded = selectCircleDate.contains(todayWeekday);

      if (todayIncluded && alarmTime.isBefore(now)) {
        // 오늘을 제외하고 가장 가까운 다음 반복 주기 계산
        List<int> nextRepeatDays = List.from(selectCircleDate)..remove(todayWeekday);
        int daysUntilNextAlarm =
            nextRepeatDays.map((weekday) => (weekday - todayWeekday + 7) % 7).reduce((a, b) => min(a, b));
        return alarmTime.add(Duration(days: daysUntilNextAlarm));
      } else if (todayIncluded) {
        return alarmTime;
      } else {
        int daysUntilNextAlarm =
            selectCircleDate.map((weekday) => (weekday - todayWeekday + 7) % 7).reduce((a, b) => min(a, b));
        return alarmTime.add(Duration(days: daysUntilNextAlarm));
      }
    }
  }

  Future<List<dynamic>> getDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<AlarmData> result = [];
    final alarmDatasStr = pref.getString("alarmDatas");

    if (alarmDatasStr != null && alarmDatasStr != '[]') {
      final savedAlarmDatas = jsonDecode(alarmDatasStr) as List<dynamic>;
      // print(savedAlarmDatas[0].runtimeType);
      for (var i = 0; i < savedAlarmDatas.length; i++) {
        print("getDATAS");
        result.add(AlarmData.fromJson(savedAlarmDatas[i]));
        print(savedAlarmDatas[i]);
        print("getDATAS");
        // print("===sajdf====");
        // print(savedAlarmDatas[i]);
      }
    }

    final response = await _server.getAlarms("WAKE").then((res) {
      return res.data;
    }).catchError((err) {
      return [];
    });
    // // print(response);

    // print([...result, ...response]);

    return [...result, ...response];
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
    // print(list);
    List<Widget> result = [];

    for (var i = 0; i < list.length; i++) {
      // print(list[i]);
      Map<String, dynamic> music;
      int alarmType;
      String time;
      List<String> weekday;
      List<String> snooze;

      // // print(list[i].alarmData['weekOfNum']);

      if (list[i] is AlarmData) {
        music = (list[i] as AlarmData).alarmData['musicInfo'];
        // print(music);
        alarmType = 1;
        time = list[i].alarmData['time'];
        weekday = (list[i].alarmData['weekOfNum'] as List<dynamic>).map((element) {
          return getKoreanWeekday(element);
        }).toList();
        snooze = (list[i].alarmData['snooze'] as List<dynamic>).map((element) => "${element}m").toList();
      } else {
        // print(list[i]['musicTitle']);
        try {
          music = wakeMusicList.firstWhere((element) {
            // print(element['title']);
            // print(list[i]['musicTitle']);
            return element['title'] == list[i]['musicTitle'];
          });
        } catch (e) {
          // print(e);
        }
        music = wakeMusicList.firstWhere((element) => element['title'] == list[i]['musicTitle']);
        // music = {};
        // print(music);
        alarmType = 0;
        final start = DateTime.fromMillisecondsSinceEpoch(int.parse(list[i]['startDate'].toString()), isUtc: true);
        final end = DateTime.fromMillisecondsSinceEpoch(int.parse(list[i]['endDate'].toString()), isUtc: true);
        final dateFormat = DateFormat("HH:mm");
        time = '${dateFormat.format(start)} ~ ${dateFormat.format(end)}';
        // print(list[i]['weekdays'].map((res) => int.parse(res["alarmWeekday"].toString())));
        // print(list[i]['snoozes'].map((res) => int.parse(res['snoozeMinute'].toString())));
        final numberWeekday =
            (list[i]['weekdays'] as List<dynamic>).map((res) => int.parse(res["alarmWeekday"].toString())).toList();

        numberWeekday.sort();
        weekday = numberWeekday.map((res) => getKoreanWeekday(res)).toList();

        final numberSnooze =
            (list[i]['snoozes'] as List<dynamic>).map((res) => int.parse(res['snoozeMinute'].toString())).toList();

        numberSnooze.sort();
        snooze = numberSnooze.map((res) => '${res}m').toList();
      }

      result.add(
        Stack(
          children: [
            Container(
              width: deviceWidth,
              height: 174,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SwipeActionCell(
                key: ObjectKey(list[i]),
                trailingActions: [
                  SwipeAction(
                    onTap: (value) async {
                      if (list[i] is AlarmData) {
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        final jsonStr = pref.getString('alarmDatas');
                        List<AlarmData> alarmDatas = [];

                        await Alarm.stop(list[i].alarmSettings.id);

                        list[i].alarmData['snoozeIds'].forEach((e) async {
                          await Alarm.stop(e);
                          // print(e);
                        });

                        if (jsonStr != null) {
                          final parsedJson = jsonDecode(jsonStr);
                          for (var i = 0; i < parsedJson.length; i++) {
                            alarmDatas.add(AlarmData.fromJson(parsedJson[i]));
                          }
                        }

                        alarmDatas.removeWhere(
                          (element) => list[i].alarmSettings.id == element.alarmSettings.id,
                        );

                        final alarmDatasJson = alarmDatas.map((e) => e.toJson()).toList();
                        final removeStr = jsonEncode(alarmDatasJson);
                        await pref.setString("alarmDatas", removeStr);

                        value(true);
                        setState(() {
                          datas = getDatas();
                        });
                      } else {
                        await _server.deleteAlarm(int.parse(list[i]['alarmId'].toString())).then((res) {
                          setState(() {
                            datas = getDatas();
                          });
                        });
                      }
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
                    onTap: () async {
                      if (list[i] is AlarmData) {
                        var isChange = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WakeAlarmMakePage(
                              alarmData: list[i],
                            ),
                          ),
                        ).then((value) {
                          setState(() {
                            datas = getDatas();
                          });
                        });

                        // if (isChange != null && isChange) {
                        //   setState(() {
                        //     datas = getDatas();
                        //   });
                        // }
                      } else {
                        var isChange = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WakeAlarmMakePage(
                              aiAlarmData: list[i],
                            ),
                          ),
                        ).then((value) {
                          setState(() {
                            datas = getDatas();
                          });
                        });

                        // if (isChange != null && isChange) {
                        //   setState(() {
                        //     datas = getDatas();
                        //   });
                        // }
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
                          Expanded(
                            child: Stack(
                              children: [
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset('assets/snooze.svg'),
                                                const SizedBox(width: 7),
                                                const Text(
                                                  '스누즈',
                                                  style: TextStyle(
                                                    fontFamily: "Pretendard",
                                                    fontSize: 15,
                                                    color: Color(0xFF8E8E93),
                                                  ),
                                                ),
                                                const SizedBox(width: 7),
                                                Text(
                                                  snooze.join(','),
                                                  style: const TextStyle(
                                                    fontFamily: "Pretendard",
                                                    fontSize: 15,
                                                    color: CustomColors.secondaryBlack,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: CupertinoSwitch(
                                    value: list[i] is AlarmData
                                        ? bool.parse(list[i].alarmData['isActive'].toString())
                                        : list[i]['isActive'],
                                    onChanged: (value) async {
                                      // print("=====");
                                      // // print(list[i]['alarmId']);
                                      // print(list[i]);
                                      // print('=====');
                                      if (list[i] is AlarmData) {
                                        print("======ALARM_DARA======");
                                        print(list[i].alarmData['isActive']);
                                        print("======ALARM_DARA======");
                                        if ((list[i] as AlarmData).alarmData['isActive'] ?? false) {
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          final jsonStr = pref.getString('alarmDatas');
                                          List<AlarmData> alarmDatas = [];

                                          await Alarm.stop((list[i] as AlarmData).alarmSettings.id);

                                          (list[i] as AlarmData).alarmData['snoozeIds'].forEach((e) async {
                                            await Alarm.stop(e);
                                            // print(e);
                                          });

                                          if (jsonStr != null) {
                                            final parsedJson = jsonDecode(jsonStr);
                                            for (var i = 0; i < parsedJson.length; i++) {
                                              alarmDatas.add(AlarmData.fromJson(parsedJson[i]));
                                            }
                                          }

                                          alarmDatas = alarmDatas.map(
                                            (e) {
                                              if (e.alarmSettings.id == (list[i] as AlarmData).alarmSettings.id) {
                                                e.alarmData['isActive'] = false;
                                                print("=================zzzzzz===================");
                                                print(e.alarmData);
                                                print("=================zzzzzz===================");
                                              }
                                              return e;
                                            },
                                          ).toList();

                                          final alarmDatasJson = alarmDatas.map((e) => e.toJson()).toList();
                                          final removeStr = jsonEncode(alarmDatasJson);
                                          await pref.setString("alarmDatas", removeStr);

                                          print(pref.getString("alarmDatas"));

                                          datas = getDatas();
                                          print("=========RESULT=========");
                                          print(list[i].alarmData);
                                          print("=========RESULT=========");

                                          // setState(() {
                                          //   (list[i] as AlarmData).alarmData['isActive'] = false;
                                          // });
                                        } else {
                                          final alarm = list[i] as AlarmData;

                                          final alarmSettings = AlarmSettings(
                                            dateTime: setAlarm(
                                              (list[i].alarmData['weekOfNum'] as List<dynamic>)
                                                  .map((e) => int.parse(e.toString()))
                                                  .toList(),
                                              list[i].alarmSettings.dateTime.hour,
                                              list[i].alarmSettings.dateTime.minute,
                                            ),
                                            id: alarm.alarmSettings.id,
                                            assetAudioPath: alarm.alarmSettings.assetAudioPath,
                                            loopAudio: alarm.alarmSettings.loopAudio,
                                            fadeDuration: alarm.alarmSettings.fadeDuration,
                                            vibrate: alarm.alarmSettings.vibrate,
                                            notificationTitle: alarm.alarmSettings.notificationTitle,
                                            notificationBody: alarm.alarmSettings.notificationBody,
                                            enableNotificationOnKill: alarm.alarmSettings.enableNotificationOnKill,
                                            stopOnNotificationOpen: alarm.alarmSettings.stopOnNotificationOpen,
                                          );

                                          await Alarm.set(alarmSettings: alarmSettings);

                                          var alarmTime = alarmSettings.dateTime;
                                          print(list[i] as AlarmData);

                                          for (var i = 0; i < alarm.alarmData['snooze'].length; i++) {
                                            var snoozeTime =
                                                alarmTime.add(Duration(minutes: alarm.alarmData['snooze'][i] + i + 1));

                                            final alarmSettings = AlarmSettings(
                                              id: alarm.alarmData['snooze'][i],
                                              dateTime: snoozeTime,
                                              assetAudioPath: alarm.alarmSettings.assetAudioPath,
                                              loopAudio: false,
                                              fadeDuration: 5,
                                              vibrate: false,
                                              notificationTitle: 'This time to sleep',
                                              notificationBody: '설정하신 스누즈 알림입니다! 어서 일어나세요!',
                                              enableNotificationOnKill: true,
                                              stopOnNotificationOpen: false,
                                            );

                                            await Alarm.set(alarmSettings: alarmSettings);
                                          }
                                        }

                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        final jsonStr = pref.getString('alarmDatas');
                                        List<AlarmData> alarmDatas = [];

                                        if (jsonStr != null) {
                                          final parsedJson = jsonDecode(jsonStr);
                                          for (var i = 0; i < parsedJson.length; i++) {
                                            alarmDatas.add(AlarmData.fromJson(parsedJson[i]));
                                          }
                                        }

                                        alarmDatas = alarmDatas.map(
                                          (e) {
                                            if (e.alarmSettings.id == (list[i] as AlarmData).alarmSettings.id) {
                                              final alarm = list[i] as AlarmData;
                                              e.alarmData['isActive'] = true;
                                              e.alarmSettings = AlarmSettings(
                                                dateTime: setAlarm(
                                                  (list[i].alarmData['weekOfNum'] as List<dynamic>)
                                                      .map((e) => int.parse(e.toString()))
                                                      .toList(),
                                                  list[i].alarmSettings.dateTime.hour,
                                                  list[i].alarmSettings.dateTime.minute,
                                                ),
                                                id: alarm.alarmSettings.id,
                                                assetAudioPath: alarm.alarmSettings.assetAudioPath,
                                                loopAudio: alarm.alarmSettings.loopAudio,
                                                fadeDuration: alarm.alarmSettings.fadeDuration,
                                                vibrate: alarm.alarmSettings.vibrate,
                                                notificationTitle: alarm.alarmSettings.notificationTitle,
                                                notificationBody: alarm.alarmSettings.notificationBody,
                                                enableNotificationOnKill: alarm.alarmSettings.enableNotificationOnKill,
                                                stopOnNotificationOpen: alarm.alarmSettings.stopOnNotificationOpen,
                                              );
                                            }
                                            return e;
                                          },
                                        ).toList();

                                        final alarmDatasJson = alarmDatas.map((e) => e.toJson()).toList();
                                        final removeStr = jsonEncode(alarmDatasJson);
                                        await pref.setString("alarmDatas", removeStr);

                                        setState(() {
                                          (list[i] as AlarmData).alarmData['isActive'] = true;
                                        });
                                      } else {
                                        await _server.updateAlarmActive(int.parse(list[i]['alarmId'].toString())).then(
                                          (res) {
                                            // print("===========");
                                            // print(list[i]['isActive'].runtimeType);
                                            // print(value);
                                            // print(bool.parse(value.toString()));
                                            // print("===========");
                                            // setState(() {
                                            //   list[i]['isActive'] = bool.parse(value.toString());
                                            // });
                                            for (var idx = 0; idx < list.length; idx++) {
                                              if (list[idx] is! AlarmData) {
                                                if (i == idx) {
                                                  setState(() {
                                                    list[i]['isActive'] = bool.parse(value.toString());
                                                  });
                                                } else {
                                                  setState(() {
                                                    list[idx]['isActive'] = false;
                                                  });
                                                }
                                              }
                                            }
                                          },
                                        );
                                      }
                                    },
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
          ],
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
          "기상 알람 리스트",
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
                    '산뜻한 AI 기상 알람',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.secondaryBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    '가장 좋은 컨디션에 깨워드려요.',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8E8E93),
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
                            builder: (context) => WakeAlarmMakePage(),
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
                            SvgPicture.asset('assets/add_alarm.svg'),
                            const SizedBox(height: 8),
                            const Text(
                              '새로운 기상 알람 만들기',
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
                    // print(snapshot.error);
                    // print("error");
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    // print("wating");
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
