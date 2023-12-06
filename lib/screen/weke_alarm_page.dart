import 'dart:convert';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';

class WakeAlarmPage extends StatefulWidget {
  AlarmSettings? alarmSettings;

  WakeAlarmPage({super.key, this.alarmSettings});

  @override
  State<WakeAlarmPage> createState() => _WakeAlarmPageState();
}

class _WakeAlarmPageState extends State<WakeAlarmPage> {
  Future<List<AlarmData>> getDatas() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<AlarmData> result = [];
    final alarmDatasStr = pref.getString("alarmDatas");

    if (alarmDatasStr != null && alarmDatasStr != '[]') {
      final savedAlarmDatas = jsonDecode(alarmDatasStr) as List<dynamic>;
      print(savedAlarmDatas[0].runtimeType);
      for (var i = 0; i < savedAlarmDatas.length; i++) {
        result.add(AlarmData.fromJson(savedAlarmDatas[i]));
      }
    }

    return result;
  }

  DateTime setNextAlarm(DateTime selectedTime, List<dynamic> repeatDays) {
    DateTime now = DateTime.now();
    DateTime nextAlarmTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    if (repeatDays.isEmpty) {
      // 반복 주기가 없는 경우, 일주일 후에 알람 설정
      return nextAlarmTime.add(const Duration(days: 7));
    } else {
      int todayWeekday = now.weekday; // Monday is 1, Sunday is 7
      List<int> futureDays =
          repeatDays.map((day) => int.parse(day.toString())).where((day) => day > todayWeekday).toList();

      if (futureDays.isNotEmpty) {
        // 현재 요일 이후의 가장 가까운 반복 주기에 알람 설정
        int daysUntilNextAlarm = futureDays.reduce(min) - todayWeekday;
        return nextAlarmTime.add(Duration(days: daysUntilNextAlarm));
      } else {
        // 다음 주의 첫 번째 반복 주기에 알람 설정
        int daysUntilNextAlarm = 7 - todayWeekday + repeatDays.map((day) => int.parse(day.toString())).reduce(min);
        return nextAlarmTime.add(Duration(days: daysUntilNextAlarm));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF94E8B5),
      body: Stack(
        children: [
          Positioned(
            child: SvgPicture.asset(
              'assets/wake_alarm_background.svg',
              width: deviceWidth,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  '좋은 아침 입니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: CustomColors.secondaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  '${DateTime.now().hour > 12 ? '오후' : '오전'} ${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour}:${DateTime.now().minute}',
                  style: const TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 52,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.secondaryBlack,
                  ),
                ),
              ),
              const SizedBox(height: 42),
              // Center(
              //   child: RichText(
              //     text: const TextSpan(
              //       children: [
              //         TextSpan(
              //           text: 'Today  ',
              //           style: TextStyle(
              //             fontFamily: "SF-Pro",
              //             fontSize: 17,
              //             fontWeight: FontWeight.w600,
              //             color: CustomColors.systemWhite,
              //           ),
              //         ),
              //         TextSpan(
              //           text: '날씨 -5°C',
              //           style: TextStyle(
              //             fontFamily: "Pretendard",
              //             fontSize: 17,
              //             fontWeight: FontWeight.w600,
              //             color: CustomColors.secondaryBlack,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SafeArea(
              child: SliderButton(
                alignLabel: Alignment.center,
                backgroundColor: CustomColors.lightGreen,
                baseColor: CustomColors.lightGreen2,
                highlightedColor: CustomColors.lightGreen,
                width: deviceWidth - 40,
                label: const Text(
                  '기상하기',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 17,
                    color: CustomColors.lightGreen2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                height: 70,
                buttonSize: 58,
                buttonColor: CustomColors.lightGreen2,
                action: () async {
                  final alarmList = await getDatas();
                  List<AlarmData> targetList =
                      alarmList.where((element) => element.alarmSettings.id == widget.alarmSettings!.id).toList();

                  for (var element in targetList) {
                    final circleList = element.alarmData['weekOfNum'];
                    final snoozeIds = element.alarmData['snoozeIds'];
                    final snoozeList = element.alarmData['snooze'];

                    //부모 알람 중지
                    await Alarm.stop(element.alarmSettings.id);

                    if (snoozeIds.isNotEmpty) {
                      snoozeIds.forEach((element) async {
                        await Alarm.stop(element);
                      });
                    }

                    final alarmTime = setNextAlarm(element.alarmSettings.dateTime, circleList);

                    AlarmSettings oldAlarm = element.alarmSettings;
                    AlarmSettings newAlarm;
                    newAlarm = AlarmSettings(
                      id: oldAlarm.id,
                      dateTime: alarmTime,
                      assetAudioPath: oldAlarm.assetAudioPath,
                      loopAudio: oldAlarm.loopAudio,
                      vibrate: oldAlarm.vibrate,
                      fadeDuration: oldAlarm.fadeDuration,
                      notificationBody: oldAlarm.notificationBody,
                      notificationTitle: oldAlarm.notificationTitle,
                      enableNotificationOnKill: oldAlarm.enableNotificationOnKill,
                      stopOnNotificationOpen: oldAlarm.stopOnNotificationOpen,
                    );

                    await Alarm.set(alarmSettings: newAlarm);

                    for (var i = 0; i < snoozeList.length; i++) {
                      DateTime snoozeDate = alarmTime.add(Duration(minutes: snoozeList[i] + (i + 1)));
                      AlarmSettings snoozeAlarm = AlarmSettings(
                        id: snoozeIds[i],
                        dateTime: snoozeDate,
                        assetAudioPath: oldAlarm.assetAudioPath,
                        loopAudio: oldAlarm.loopAudio,
                        vibrate: oldAlarm.vibrate,
                        fadeDuration: oldAlarm.fadeDuration,
                        notificationTitle: oldAlarm.notificationTitle,
                        notificationBody: oldAlarm.notificationBody,
                        enableNotificationOnKill: oldAlarm.enableNotificationOnKill,
                        stopOnNotificationOpen: oldAlarm.stopOnNotificationOpen,
                      );

                      await Alarm.set(alarmSettings: snoozeAlarm);
                    }

                    AlarmData newAlarmData = AlarmData(
                      alarmData: element.alarmData,
                      alarmSettings: newAlarm,
                    );

                    for (var i = 0; i < alarmList.length; i++) {
                      if (alarmList[i].alarmSettings.id == newAlarmData.alarmSettings.id) {
                        alarmList[i] = newAlarmData;
                      }
                    }

                    final alarmListJson = alarmList.map<Map<String, dynamic>>((e) => e.toJson()).toList();

                    final alarmListJsonStr = jsonEncode(alarmListJson);

                    SharedPreferences pref = await SharedPreferences.getInstance();
                    await pref.remove('alarmDatas');
                    await pref.setString('alarmDatas', alarmListJsonStr);
                  }

                  Navigator.pop(context);
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                      transform: GradientRotation(180),
                      colors: [
                        Color(0xFF39C270),
                        Color(0xFF94E8B5),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: CustomColors.systemWhite,
                    size: 28,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
