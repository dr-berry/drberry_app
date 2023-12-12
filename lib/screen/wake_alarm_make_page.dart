import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WakeAlarmMakePage extends StatefulWidget {
  AlarmData? alarmData;
  dynamic aiAlarmData;

  WakeAlarmMakePage({super.key, this.alarmData, this.aiAlarmData});

  @override
  State<WakeAlarmMakePage> createState() => _WakeAlarmMakePageState();
}

class _WakeAlarmMakePageState extends State<WakeAlarmMakePage> {
  TimeOfDay? _selectTime;
  List<int> _selectCircleDate = [];
  final List<int> _savedCircleDate = [];
  List<int> _selectSnoozeData = [];
  final List<int> _savedSnoozeDate = [];
  int _musicIndex = -1;
  final ValueNotifier<bool> _circleDate = ValueNotifier(false);
  final ValueNotifier<bool> _snooseDate = ValueNotifier(false);
  List<dynamic> _savedAlarmData = [];
  final ValueNotifier<int> _segmentController = ValueNotifier(1);
  TimeOfDay? _selectStartTime;
  TimeOfDay? _selectEndTime;

  final Server _server = Server();

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
      "imageAssets": "assets/fire.png",
      "musicAssets": "assets/crackling fireplace.mp3",
      "blur": "LEFX0DE20M^j03XS\$*ni0g\$%~BIV",
      "title": "Crackling Fireplace",
    },
    {
      "imageAssets": "assets/rain.png",
      "musicAssets": "assets/gentle rain.mp3",
      "title": "Gentle Rain",
    },
    {
      "imageAssets": "assets/melody.png",
      "musicAssets": "assets/meditation melody.mp3",
      "title": "Meditation Melody",
    },
    {
      "imageAssets": "assets/pink.png",
      "musicAssets": "assets/pink noise.mp3",
      "title": "Pink Noise",
    },
    {
      "imageAssets": "assets/ocean.png",
      "musicAssets": "assets/ocean waves.mp3",
      "title": "Ocean Waves",
    },
    {
      "imageAssets": "assets/thunder.png",
      "musicAssets": "assets/thunder rain.mp3",
      "title": "Thunder Rain",
    },
    {
      "imageAssets": "assets/white.jpg",
      "musicAssets": "assets/white noise.mp3",
      "title": "White Noise",
    },
    {
      "imageAssets": "assets/digital.jpg",
      "musicAssets": "assets/alarm-clock-going-off.mp3",
      "title": "Digital",
    },
    {
      "imageAssets": "assets/beep.png",
      "musicAssets": "assets/beep.mp3",
      "title": "Beep",
    },
    {
      "imageAssets": "assets/car.jpg",
      "musicAssets": "assets/car.mp3",
      "title": "Car Siren",
    },
    {
      "imageAssets": "assets/chiptone.jpg",
      "musicAssets": "assets/chiptune.mp3",
      "title": "Chiptune",
    },
    {
      "imageAssets": "assets/cyber.jpg",
      "musicAssets": "assets/cyber-alarm.mp3",
      "title": "Cyber",
    },
    {
      "imageAssets": "assets/old_clock.jpg",
      "musicAssets": "assets/old_alarm.mp3",
      "title": "Old",
    },
    {
      "imageAssets": "assets/rising sun.jpg",
      "musicAssets": "assets/oversimplefied.mp3",
      "title": "Rising Sun",
    },
    {
      "imageAssets": "assets/siren.jpg",
      "musicAssets": "assets/psycho-siren.mp3",
      "title": "Siren",
    },
    {
      "imageAssets": "assets/ringtone.jpg",
      "musicAssets": "assets/ringtone.mp3",
      "title": "Ringtone",
    },
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
    if (widget.aiAlarmData != null) {
      print(widget.alarmData);
      final start =
          DateTime.fromMillisecondsSinceEpoch(int.parse(widget.aiAlarmData['startDate'].toString()), isUtc: true);
      final end = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.aiAlarmData['endDate'].toString()), isUtc: true);
      _selectStartTime = TimeOfDay(hour: start.hour, minute: start.minute);
      _selectEndTime = TimeOfDay(hour: end.hour, minute: end.minute);
      _circleDate.value = widget.aiAlarmData['weekdays'].isNotEmpty;
      _selectCircleDate = (widget.aiAlarmData['weekdays'] as List<dynamic>)
          .map((e) => int.parse(e['alarmWeekday'].toString()))
          .toList();
      _segmentController.value = 0;
      _musicIndex = musicList.indexWhere((element) => element['title'] == widget.aiAlarmData['musicTitle'].toString());

      _selectSnoozeData =
          (widget.aiAlarmData['snoozes'] as List<dynamic>).map((e) => int.parse(e['snoozeMinute'].toString())).toList();
      _snooseDate.value = widget.aiAlarmData['snoozes'].isNotEmpty;
    }

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

    if (widget.alarmData != null) {
      setState(() {
        if (widget.alarmData!.alarmData['snooze'].isNotEmpty) {
          _snooseDate.value = true;
        }

        if (widget.alarmData!.alarmData['weekOfNum'].isNotEmpty) {
          _circleDate.value = true;
        }

        widget.alarmData!.alarmData['weekOfNum'].forEach((e) {
          _selectCircleDate.add(e);
        });
        widget.alarmData!.alarmData['snooze'].forEach((e) {
          _selectSnoozeData.add(e);
        });
        _musicIndex = musicList.indexWhere(
          (element) => element['title'] == widget.alarmData?.alarmData['musicInfo']['title'],
        );

        print(widget.alarmData!.alarmSettings.dateTime);
        _selectTime = TimeOfDay(
            hour: widget.alarmData!.alarmSettings.dateTime.hour,
            minute: widget.alarmData!.alarmSettings.dateTime.minute);
      });
    }
  }

  DateTime setAlarm() {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(now.year, now.month, now.day, _selectTime!.hour, _selectTime!.minute);

    if (_selectCircleDate.isEmpty) {
      if (alarmTime.isBefore(now)) {
        return alarmTime.add(const Duration(days: 1));
      } else {
        return alarmTime;
      }
    } else {
      int todayWeekday = now.weekday; // Monday is 1, Sunday is 7
      bool todayIncluded = _selectCircleDate.contains(todayWeekday);

      if (todayIncluded && alarmTime.isBefore(now)) {
        // 오늘을 제외하고 가장 가까운 다음 반복 주기 계산
        List<int> nextRepeatDays = List.from(_selectCircleDate)..remove(todayWeekday);
        int daysUntilNextAlarm =
            nextRepeatDays.map((weekday) => (weekday - todayWeekday + 7) % 7).reduce((a, b) => min(a, b));
        return alarmTime.add(Duration(days: daysUntilNextAlarm));
      } else if (todayIncluded) {
        return alarmTime;
      } else {
        int daysUntilNextAlarm =
            _selectCircleDate.map((weekday) => (weekday - todayWeekday + 7) % 7).reduce((a, b) => min(a, b));
        return alarmTime.add(Duration(days: daysUntilNextAlarm));
      }
    }
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
          "기상 알람 설정",
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
              if (_segmentController.value == 1) {
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

                if (widget.alarmData != null) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  final jsonStr = pref.getString('alarmDatas');
                  List<AlarmData> alarmDatas = [];
                  print(widget.alarmData?.alarmData);

                  // await Alarm.stop(widget.alarmData!.alarmSettings.id);

                  // widget.alarmData!.alarmData['snoozeIds'].forEach((e) async {
                  //   await Alarm.stop(e);
                  //   print(e);
                  // });

                  if (jsonStr != null) {
                    final parsedJson = jsonDecode(jsonStr);
                    for (var i = 0; i < parsedJson.length; i++) {
                      alarmDatas.add(AlarmData.fromJson(parsedJson[i]));
                    }
                  }

                  var alarms = alarmDatas.where(
                    (element) => widget.alarmData!.alarmSettings.id != element.alarmSettings.id,
                  );

                  final alarmDatasJson = alarms.toList().map((e) => e.toJson()).toList();

                  final removeStr = jsonEncode(alarmDatasJson);
                  await pref.remove("alarmDatas");
                  await pref.setString("alarmDatas", removeStr);
                  print(alarms.toList());
                  setState(() {
                    _savedAlarmData = [];
                    _savedAlarmData.addAll(jsonDecode(removeStr));
                  });

                  // Future.delayed(Duration.zero, () {
                  //   Navigator.pop(context, true);
                  // });
                }

                final alarms = Alarm.getAlarms();
                var now = DateTime.now();
                var selectTime = DateTime(now.year, now.month, now.day, _selectTime!.hour, _selectTime!.minute);

                alarms.where((element) {
                  return element.dateTime.hour == selectTime.hour && element.dateTime.minute == selectTime.minute;
                }).forEach((e) async {
                  await Alarm.stop(e.id);
                });

                List<int> snoozeIds = [];
                AlarmSettings alarmSettings;

                final alarmTime = setAlarm();
                var id = widget.alarmData != null
                    ? widget.alarmData!.alarmSettings.id
                    : int.parse(
                        "${alarmTime.hour}${alarmTime.month}${alarmTime.day}${alarmTime.hour}${alarmTime.minute}");

                alarmSettings = AlarmSettings(
                  id: id,
                  dateTime: alarmTime,
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
                print(alarmSettings);

                for (var i = 0; i < _selectSnoozeData.length; i++) {
                  var snoozeTime = alarmTime.add(Duration(minutes: _selectSnoozeData[i] + i + 1));

                  final snoozeId = id + i + 1;

                  final alarmSettings = AlarmSettings(
                    id: snoozeId,
                    dateTime: snoozeTime,
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

                AlarmData alarmData = AlarmData(
                  alarmData: {
                    "alarm": 'WAKE',
                    "snooze": _selectSnoozeData,
                    "weekOfNum": _selectCircleDate,
                    "alarmType": "일반알림",
                    "snoozeIds": snoozeIds,
                    "musicInfo": musicList[_musicIndex],
                    "time":
                        '${alarmTime.hour < 10 ? '0${alarmTime.hour}' : alarmTime.hour}:${alarmTime.minute < 10 ? '0${alarmTime.minute}' : alarmTime.minute}',
                  },
                  alarmSettings: alarmSettings,
                );

                SharedPreferences pref = await SharedPreferences.getInstance();
                _savedAlarmData.add(alarmData.toJson());
                await pref.setString("alarmDatas", jsonEncode(_savedAlarmData));

                Future.delayed(Duration.zero, () {
                  Navigator.pop(context, true);
                });
              } else {
                print(_segmentController.value);
                if (_selectStartTime == null || _selectEndTime == null || _musicIndex == -1) {
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

                final now = DateTime.now();
                if (widget.aiAlarmData == null) {
                  await _server.setAlarm(
                    "WAKE",
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(
                      DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _selectStartTime!.hour,
                        _selectStartTime!.minute,
                      ),
                    ),
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(
                      DateTime(
                        now.year,
                        now.month,
                        (_selectStartTime!.hour * 60) + _selectStartTime!.minute >
                                _selectEndTime!.hour * 60 + _selectEndTime!.minute
                            ? now.day + 1
                            : now.day,
                        _selectEndTime!.hour,
                        _selectEndTime!.minute,
                      ),
                    ),
                    musicList[_musicIndex]['title']!,
                    _selectSnoozeData,
                    _selectCircleDate,
                  );
                } else {
                  await _server.updateAlarm(
                    int.parse(widget.aiAlarmData['alarmId'].toString()),
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(
                      DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _selectStartTime!.hour,
                        _selectStartTime!.minute,
                      ),
                    ),
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(
                      DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _selectEndTime!.hour,
                        _selectEndTime!.minute,
                      ),
                    ),
                    musicList[_musicIndex]['title']!,
                    _selectSnoozeData,
                    _selectCircleDate,
                  );
                }

                Future.delayed(Duration.zero, () {
                  Navigator.pop(context, true);
                });
              }
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
                                        color: CustomColors.systemGrey6,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            musicList[index]['imageAssets']!,
                                          ),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
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
                                    await playBackgroundAudio(musicList[index]['musicAssets']!);
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
                        width: deviceWidth,
                        color: Colors.white,
                        child: Center(
                          child: AdvancedSegment(
                            controller: _segmentController,
                            backgroundColor: const Color.fromRGBO(118, 118, 128, 0.12),
                            segments: const {0: "AI알람", 1: "일반알람"},
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 33),
                      ValueListenableBuilder(
                        valueListenable: _segmentController,
                        builder: (context, value, child) {
                          if (value == 1) {
                            return Column(
                              children: [
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
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/wake.svg'),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '기상구간 설정',
                                      style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontSize: 20,
                                        color: CustomColors.secondaryBlack,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                _selectStartTime != null && _selectEndTime != null
                                    ? const SizedBox(height: 12)
                                    : Container(),
                                _selectStartTime != null && _selectEndTime != null
                                    ? Text(
                                        '${_selectStartTime!.hour < 10 ? '0${_selectStartTime!.hour}' : _selectStartTime!.hour}:${_selectStartTime!.minute < 10 ? '0${_selectStartTime!.minute}' : _selectStartTime!.minute} - ${_selectEndTime!.hour < 10 ? '0${_selectEndTime!.hour}' : _selectEndTime!.hour}:${_selectEndTime!.minute < 10 ? '0${_selectEndTime!.minute}' : _selectEndTime!.minute} 해당 기상 시간에 앱에서 알람이 울립니다.',
                                        style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          color: CustomColors.secondaryBlack,
                                          overflow: TextOverflow.clip,
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Material(
                                        color: CustomColors.systemWhite,
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          onTap: () async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  _selectStartTime != null ? _selectStartTime! : TimeOfDay.now(),
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

                                            if (_selectEndTime != null && time != null) {
                                              int start = time.hour * 60 + time.minute;
                                              int end = _selectEndTime!.hour * 60 + _selectEndTime!.minute;

                                              // if (start > end) {
                                              //   Future.delayed(Duration.zero, () {
                                              //     showPlatformDialog(
                                              //       context: context,
                                              //       builder: (context) {
                                              //         return BasicDialogAlert(
                                              //           title: const Text(
                                              //             '시간 설정 실패',
                                              //             style: TextStyle(fontFamily: "Pretendard"),
                                              //           ),
                                              //           content: const Text(
                                              //             '첫 시간이 끝시간 보다 앞으로 설정해주세요.',
                                              //             style: TextStyle(fontFamily: "Pretnedard"),
                                              //           ),
                                              //           actions: [
                                              //             BasicDialogAction(
                                              //               title: const Text(
                                              //                 '확인',
                                              //                 style: TextStyle(
                                              //                   fontFamily: "Pretendard",
                                              //                   color: CustomColors.blue,
                                              //                 ),
                                              //               ),
                                              //               onPressed: () {
                                              //                 Navigator.pop(context);
                                              //               },
                                              //             )
                                              //           ],
                                              //         );
                                              //       },
                                              //     );
                                              //   });
                                              //   return;
                                              // }
                                            }

                                            if (time != null) {
                                              setState(() {
                                                _selectStartTime = time;
                                              });
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            height: 52,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 1,
                                                color: const Color(0xFFE5E5EA),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _selectStartTime != null
                                                    ? '${_selectStartTime!.hour > 12 ? '오후' : '오전'} ${_selectStartTime!.hour < 10 ? '0${_selectStartTime!.hour}' : _selectStartTime!.hour}:${_selectStartTime!.minute < 10 ? '0${_selectStartTime!.minute}' : _selectStartTime!.minute}'
                                                    : '오후 12:00',
                                                style: _selectStartTime != null
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
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '-',
                                      style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontSize: 17,
                                        color: CustomColors.secondaryBlack,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Material(
                                        color: CustomColors.systemWhite,
                                        borderRadius: BorderRadius.circular(5),
                                        child: InkWell(
                                          onTap: () async {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  _selectStartTime != null ? _selectStartTime! : TimeOfDay.now(),
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

                                            if (_selectStartTime != null && time != null) {
                                              int start = _selectStartTime!.hour * 60 + _selectStartTime!.minute;
                                              int end = time.hour * 60 + time.minute;

                                              if (start > end) {
                                                Future.delayed(Duration.zero, () {
                                                  showPlatformDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return BasicDialogAlert(
                                                        title: const Text(
                                                          '시간 설정 실패',
                                                          style: TextStyle(fontFamily: "Pretendard"),
                                                        ),
                                                        content: const Text(
                                                          '끝 시간이 처음보다 나중으로 설정해주세요.',
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
                                                });
                                                return;
                                              }
                                            }

                                            if (time != null) {
                                              setState(() {
                                                _selectEndTime = time;
                                              });
                                            }
                                          },
                                          borderRadius: BorderRadius.circular(5),
                                          child: Container(
                                            height: 52,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                width: 1,
                                                color: const Color(0xFFE5E5EA),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                _selectEndTime != null
                                                    ? '${_selectEndTime!.hour > 12 ? '오후' : '오전'} ${_selectEndTime!.hour < 10 ? '0${_selectEndTime!.hour}' : _selectEndTime!.hour}:${_selectEndTime!.minute < 10 ? '0${_selectEndTime!.minute}' : _selectEndTime!.minute}'
                                                    : '오전 1:00',
                                                style: _selectEndTime != null
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
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          }
                        },
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
                widget.alarmData != null
                    ? Center(
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              final jsonStr = pref.getString('alarmDatas');
                              List<AlarmData> alarmDatas = [];

                              await Alarm.stop(widget.alarmData!.alarmSettings.id);

                              widget.alarmData!.alarmData['snoozeIds'].forEach((e) async {
                                await Alarm.stop(e);
                                print(e);
                              });

                              if (jsonStr != null) {
                                final parsedJson = jsonDecode(jsonStr);
                                for (var i = 0; i < parsedJson.length; i++) {
                                  alarmDatas.add(AlarmData.fromJson(parsedJson[i]));
                                }
                              }

                              alarmDatas.removeWhere(
                                (element) => widget.alarmData!.alarmSettings.id == element.alarmSettings.id,
                              );

                              final alarmDatasJson = alarmDatas.map((e) => e.toJson()).toList();
                              final removeStr = jsonEncode(alarmDatasJson);
                              await pref.setString("alarmDatas", removeStr);

                              Future.delayed(Duration.zero, () {
                                Navigator.pop(context, true);
                              });
                            },
                            child: Container(
                              height: 48,
                              width: deviceWidth - 90,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: CustomColors.redorangeRed,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.transparent,
                              ),
                              child: const Text(
                                '수면 테라피 삭제',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w400,
                                  color: CustomColors.redorangeRed,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 63),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
