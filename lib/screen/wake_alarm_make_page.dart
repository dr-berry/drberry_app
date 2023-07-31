import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WakeAlarmMakePage extends StatefulWidget {
  const WakeAlarmMakePage({super.key});

  @override
  State<WakeAlarmMakePage> createState() => _WakeAlarmMakePageState();
}

class _WakeAlarmMakePageState extends State<WakeAlarmMakePage> {
  FlutterSoundPlayer soundPlayer = FlutterSoundPlayer(logLevel: Level.nothing);
  TimeOfDay? _selectTime;
  final List<int> _selectCircleDate = [];
  final List<int> _savedCircleDate = [];
  final List<int> _selectSnoozeData = [];
  final List<int> _savedSnoozeDate = [];
  int _musicIndex = -1;
  final ValueNotifier<bool> _circleDate = ValueNotifier(false);
  final ValueNotifier<bool> _snooseDate = ValueNotifier(false);
  final List<dynamic> _savedAlarmData = [];

  void setAlarmData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final alarmDatasStr = pref.getString("alarmDatas");

    if (alarmDatasStr != null) {
      final savedAlarmDatas = jsonDecode(alarmDatasStr);

      print(savedAlarmDatas.runtimeType);
      _savedAlarmData.addAll(savedAlarmDatas);
      print(_savedAlarmData);
    }
  }

  List<Map<String, String>> musicList = [
    {
      "imageAssets": "assets/digital_alarm.jpg",
      "musicAssets": "assets/alarm-clock-going-off.mp3",
      "title": "Test Alarm Sound",
    }
  ];

  Future<File> getAssetFile(String assetPath) async {
    // Load the asset as a byte array.
    ByteData byteData = await rootBundle.load(assetPath);

    // Get a temporary directory to store the file.
    Directory tempDir = await getTemporaryDirectory();

    // Generate a file path in the temporary directory.
    String filePath = '${tempDir.path}/temp_asset.mp3';

    // Write the byte data to the file.
    await File(filePath).writeAsBytes(byteData.buffer.asUint8List());

    // Return a File object for the file.
    return File(filePath);
  }

  Future<void> playBackgroundAudio(String path) async {
    // print("실행은 함 ㅇㅇ");
    await soundPlayer.openAudioSession();
    print('실행함 ㅇㅅㅇ');
    final file = await getAssetFile(path);

    await soundPlayer.startPlayer(fromURI: file.path);
  }

  void stopBackgroundAudio() async {
    await soundPlayer.stopPlayer();
    await soundPlayer.closeAudioSession();
  }

  @override
  void initState() {
    super.initState();
    setAlarmData();

    _snooseDate.addListener(() {
      if (!_snooseDate.value) {
        setState(() {
          _savedSnoozeDate.addAll(_selectSnoozeData);
          _selectSnoozeData.clear();
        });
      } else {
        if (_savedSnoozeDate.isNotEmpty) {
          setState(() {
            _selectSnoozeData.addAll(_savedSnoozeDate);
            _savedSnoozeDate.clear();
          });
        }
      }
    });

    _circleDate.addListener(() {
      if (!_circleDate.value) {
        setState(() {
          _savedCircleDate.addAll(_selectCircleDate);
          _selectCircleDate.clear();
        });
      } else {
        if (_savedCircleDate.isNotEmpty) {
          setState(() {
            _selectCircleDate.addAll(_savedCircleDate);
            _savedCircleDate.clear();
          });
        }
      }
    });
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
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.systemGrey2,
            ),
            onPressed: () async {
              if (_selectTime == null || _musicIndex == -1) {
                showPlatformDialog(
                  context: context,
                  builder: (context) {
                    return BasicDialogAlert(
                      title: const Text(
                        '알람 설정 실패',
                        style: TextStyle(fontFamily: "Pretendard"),
                      ),
                      content: const Text(
                        '시간과 음원을 설정해주세요.',
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
                return;
              }

              final alarms = Alarm.getAlarms();
              var now = DateTime.now();
              var selectTime = DateTime(now.year, now.month, now.day, _selectTime!.hour, _selectTime!.minute);
              var id = int.parse("${now.hour}${now.month}${now.day}${now.hour}${now.minute}${now.second}");

              alarms.where((element) {
                return element.dateTime.hour == selectTime.hour && element.dateTime.minute == selectTime.minute;
              }).forEach((e) async {
                await Alarm.stop(e.id);
              });

              List<int> snoozeIds = [];
              AlarmSettings alarmSettings;

              if (_selectCircleDate.isEmpty) {
                alarmSettings = AlarmSettings(
                  id: id,
                  dateTime: now.add(const Duration(days: 1)),
                  assetAudioPath: musicList[_musicIndex]['musicAssets']!,
                  loopAudio: true,
                  fadeDuration: 5,
                  vibrate: true,
                  notificationTitle: 'This time to wake',
                  notificationBody: '설정하신 알람입니다! 일어나세요!!',
                  enableNotificationOnKill: true,
                  stopOnNotificationOpen: false,
                );

                await Alarm.set(alarmSettings: alarmSettings);
              } else {
                if (selectTime.isAfter(now) && selectTime.weekday == now.weekday) {
                  alarmSettings = AlarmSettings(
                    id: id,
                    dateTime:
                        DateTime(now.year, now.month, now.day, selectTime.hour, selectTime.minute, selectTime.second),
                    assetAudioPath: musicList[_musicIndex]['musicAssets']!,
                    loopAudio: false,
                    fadeDuration: 5,
                    vibrate: false,
                    notificationTitle: 'This time to wake',
                    notificationBody: '설정하신 알람입니다! 일어나세요!!',
                    enableNotificationOnKill: true,
                    stopOnNotificationOpen: false,
                  );

                  await Alarm.set(alarmSettings: alarmSettings);
                } else {
                  int target = now.weekday;
                  int closedWeek = _selectCircleDate.reduce(
                    (a, b) => (target - a).abs() < (target - b).abs() ? a : b,
                  );

                  DateTime targetDate = now;
                  if (closedWeek < now.weekday) {
                    targetDate = now.add(Duration(days: now.weekday - closedWeek));
                  } else if (closedWeek > 6) {
                    targetDate = now.add(Duration(days: now.weekday - closedWeek + 7));
                  } else {
                    targetDate = now.add(const Duration(days: 7));
                  }

                  alarmSettings = AlarmSettings(
                    id: id,
                    dateTime: targetDate,
                    assetAudioPath: musicList[_musicIndex]['musicAssets']!,
                    loopAudio: false,
                    fadeDuration: 5,
                    vibrate: false,
                    notificationTitle: 'This time to wake',
                    notificationBody: '설정하신 알람입니다! 일어나세요!!',
                    enableNotificationOnKill: true,
                    stopOnNotificationOpen: false,
                  );

                  await Alarm.set(alarmSettings: alarmSettings);
                }
              }

              if (_selectSnoozeData.isNotEmpty) {
                for (var i = 0; i < _selectSnoozeData.length; i++) {
                  final settedAlarm = alarms.where((element) {
                    return element.dateTime.hour == selectTime.hour && element.dateTime.minute == selectTime.minute;
                  });

                  if (settedAlarm.isNotEmpty) {
                    continue;
                  }
                  DateTime selectedDate;

                  if (_selectCircleDate.isEmpty) {
                    selectedDate = now.add(const Duration(days: 1)).add(Duration(minutes: now.minute + i + (i + 1)));
                  } else {
                    if (selectTime.isAfter(now) && selectTime.weekday == now.weekday) {
                      selectedDate = DateTime(now.year, now.month, now.day, selectTime.hour,
                          selectTime.minute + i + (i + 1), selectTime.second);
                    } else {
                      int target = now.weekday;
                      int closedWeek = _selectCircleDate.reduce(
                        (a, b) => (target - a).abs() < (target - b).abs() ? a : b,
                      );

                      DateTime targetDate = now;
                      if (closedWeek < now.weekday) {
                        targetDate = now.add(Duration(days: now.weekday - closedWeek));
                      } else if (closedWeek > 6) {
                        targetDate = now.add(Duration(days: now.weekday - closedWeek + 7));
                      }

                      targetDate.add(Duration(minutes: targetDate.minute + i + (i + 1)));
                      selectedDate = targetDate;
                    }
                  }

                  final snoozeId = id + i + 1;

                  final alarmSettings = AlarmSettings(
                    id: snoozeId,
                    dateTime: selectedDate,
                    assetAudioPath: musicList[_musicIndex]['musicAssets']!,
                    loopAudio: false,
                    fadeDuration: 5,
                    vibrate: false,
                    notificationTitle: 'This time to sleep',
                    notificationBody: '설정하신 스누즈 알림입니다! 어서 일어나세요!',
                    enableNotificationOnKill: true,
                    stopOnNotificationOpen: false,
                  );

                  await Alarm.set(alarmSettings: alarmSettings);
                  snoozeIds.add(snoozeId);
                }
              }

              AlarmData alarmData = AlarmData(
                alarmData: {
                  "snooze": _selectSnoozeData,
                  "weekOfNum": _selectCircleDate,
                  "alarmType": "일반알림",
                  "snoozeIds": snoozeIds,
                  "musicInfo": musicList[_musicIndex],
                  "time":
                      '${_selectTime!.hour < 10 ? '0${_selectTime!.hour}' : _selectTime!.hour}:${_selectTime!.minute < 10 ? '0${_selectTime!.minute}' : _selectTime!.minute}',
                },
                alarmSettings: alarmSettings,
              );

              SharedPreferences pref = await SharedPreferences.getInstance();
              _savedAlarmData.add(alarmData.toJson());
              await pref.setString("alarmDatas", jsonEncode(_savedAlarmData));

              // ignore: use_build_context_synchronously
              Navigator.pop(context, true);
            },
            child: const Text(
              '완료',
              style: TextStyle(
                fontFamily: "Pretendard",
                color: CustomColors.secondaryBlack,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 16,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '기상 음원을 선택해주세요',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 22,
                    color: CustomColors.secondaryBlack,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 165.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_musicIndex == index) {
                                    _musicIndex = -1;
                                  } else {
                                    _musicIndex = index;
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 165,
                                height: 165,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 165.w,
                                      height: 165.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: CustomColors.lightGreen2,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            musicList[index]['imageAssets']!,
                                          ),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color:
                                              _musicIndex == index ? CustomColors.lightGreen2 : const Color(0xFFD1D1D6),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: CustomColors.systemWhite,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              musicList[index]['title']!,
                              style: const TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: CustomColors.secondaryBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Material(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () async {
                                  if (soundPlayer.isPlaying) {
                                    stopBackgroundAudio();
                                  } else {
                                    await playBackgroundAudio(musicList[index]['musicAssets']!);
                                  }
                                },
                                child: Icon(
                                  CupertinoIcons.speaker_3,
                                  color: CustomColors.secondaryBlack,
                                  size: 28.w,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(width: 12);
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: deviceWidth - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.systemWhite,
                  ),
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 33,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 104,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color.fromRGBO(118, 118, 118, 0.12),
                        ),
                        child: Center(
                          child: Container(
                            width: 100,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomColors.systemWhite,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.04),
                                  offset: Offset(0, 3),
                                  blurRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.12),
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '일반알람',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 13,
                                  color: CustomColors.lightGreen2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 33),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.time_solid,
                            color: CustomColors.secondaryBlack,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '시간 설정',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 20,
                              color: CustomColors.secondaryBlack,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _selectTime != null ? const SizedBox(height: 12) : Container(),
                      _selectTime != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${_selectTime!.hour < 10 ? '0${_selectTime!.hour}' : _selectTime!.hour}:${_selectTime!.minute < 10 ? '0${_selectTime!.minute}' : _selectTime!.minute} 해당 수면 시간에 앱에서 알람이 울립니다.',
                                  style: const TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 15,
                                    color: CustomColors.secondaryBlack,
                                  ),
                                )
                              ],
                            )
                          : Container(),
                      const SizedBox(height: 40),
                      Material(
                        color: CustomColors.systemWhite,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: _selectTime != null ? _selectTime! : TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.input,
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: CustomColors.lightGreen2,
                                      background: CustomColors.lightGreen, // your color here
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            print(time);

                            if (time != null) {
                              setState(() {
                                _selectTime = time;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            height: 52,
                            width: deviceWidth - 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFE5E5EA),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _selectTime != null
                                    ? '${_selectTime!.hour > 12 ? '오후' : '오전'} ${_selectTime!.hour < 10 ? '0${_selectTime!.hour}' : _selectTime!.hour}:${_selectTime!.minute < 10 ? '0${_selectTime!.minute}' : _selectTime!.minute}'
                                    : '시간 선택',
                                style: _selectTime != null
                                    ? const TextStyle(
                                        fontFamily: "Pretendard",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: CustomColors.secondaryBlack,
                                      )
                                    : const TextStyle(
                                        fontFamily: "Pretendard",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Color(0xFFAEAEB2),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: deviceWidth - 32,
                  height: 169.429,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.systemWhite,
                  ),
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 28,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/calendar_small.svg',
                                color: CustomColors.secondaryBlack,
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '반복 주기',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          AdvancedSwitch(
                            controller: _circleDate,
                            activeColor: CustomColors.lightGreen2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      SizedBox(
                        width: deviceWidth - 64,
                        height: (deviceWidth - 100) / 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...[1, 2, 3, 4, 5, 6, 7].map(
                              (e) {
                                return GestureDetector(
                                  onTap: () {
                                    if (_circleDate.value) {
                                      setState(() {
                                        if (_selectCircleDate.contains(e)) {
                                          _selectCircleDate.removeWhere((element) => element == e);
                                        } else {
                                          _selectCircleDate.add(e);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: (deviceWidth - 100) / 7,
                                    height: (deviceWidth - 100) / 7,
                                    decoration: BoxDecoration(
                                      color: _selectCircleDate.contains(e)
                                          ? CustomColors.lightGreen2
                                          : const Color(0xFFF2F2F7),
                                      borderRadius: BorderRadius.circular(((deviceWidth - 100) / 7) / 2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        getKoreanWeekday(e),
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: _selectCircleDate.contains(e)
                                              ? CustomColors.systemWhite
                                              : CustomColors.systemBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: deviceWidth - 32,
                  height: 169.429,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.systemWhite,
                  ),
                  padding: const EdgeInsets.only(
                    top: 28,
                    bottom: 28,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/snooze.svg',
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '스누즈',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  color: CustomColors.secondaryBlack,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          AdvancedSwitch(
                            controller: _snooseDate,
                            activeColor: CustomColors.lightGreen2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 42),
                      SizedBox(
                        width: deviceWidth - 64,
                        height: (deviceWidth - 100) / 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...[1, 2, 3, 4, 5, 7, 9].map(
                              (e) {
                                return GestureDetector(
                                  onTap: () {
                                    if (_snooseDate.value) {
                                      setState(() {
                                        if (_selectSnoozeData.contains(e)) {
                                          _selectSnoozeData.removeWhere((element) => element == e);
                                        } else {
                                          _selectSnoozeData.add(e);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: (deviceWidth - 100) / 7,
                                    height: (deviceWidth - 100) / 7,
                                    decoration: BoxDecoration(
                                      color: _selectSnoozeData.contains(e)
                                          ? CustomColors.lightGreen2
                                          : const Color(0xFFF2F2F7),
                                      borderRadius: BorderRadius.circular(((deviceWidth - 100) / 7) / 2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${e}m',
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: _selectSnoozeData.contains(e)
                                              ? CustomColors.systemWhite
                                              : CustomColors.systemBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                const SizedBox(height: 63),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
