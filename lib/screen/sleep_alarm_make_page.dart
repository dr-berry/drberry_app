import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/provider/global_provider.dart';
import 'package:drberry_app/screen/music_bar.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MakeSleepAlarmPage extends StatefulWidget {
  dynamic alarmData;
  final Function() refresh;

  MakeSleepAlarmPage({
    super.key,
    required this.refresh,
    this.alarmData,
  });

  @override
  State<MakeSleepAlarmPage> createState() => _MakeSleepAlarmPageState();
}

class _MakeSleepAlarmPageState extends State<MakeSleepAlarmPage> {
  TimeOfDay? _selectStartTime;
  TimeOfDay? _selectEndTime;
  List<int> _selectCircleDate = [];
  final List<int> _savedCircleDate = [];
  final List<int> _selectSnoozeData = [];
  final List<int> _savedSnoozeDate = [];
  int _musicIndex = -1;
  final ValueNotifier<bool> _circleDate = ValueNotifier(false);
  final ValueNotifier<bool> _snooseDate = ValueNotifier(false);
  final List<dynamic> _savedAlarmData = [];
  final BoxController _controller = BoxController();

  final Server _server = Server();

  void setAlarmData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final alarmDatasStr = pref.getString("sleepDatas");

    if (alarmDatasStr != null) {
      final savedAlarmDatas = jsonDecode(alarmDatasStr);

      print(savedAlarmDatas.runtimeType);
      _savedAlarmData.addAll(savedAlarmDatas);
      print(_savedAlarmData);
    }
  }

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
    if (widget.alarmData != null) {
      print(widget.alarmData);
      final start =
          DateTime.fromMillisecondsSinceEpoch(int.parse(widget.alarmData['startDate'].toString()), isUtc: true);
      final end = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.alarmData['endDate'].toString()), isUtc: true);
      _selectStartTime = TimeOfDay(hour: start.hour, minute: start.minute);
      _selectEndTime = TimeOfDay(hour: end.hour, minute: end.minute);
      _circleDate.value = widget.alarmData['weekdays'].isNotEmpty;
      _selectCircleDate =
          (widget.alarmData['weekdays'] as List<dynamic>).map((e) => int.parse(e['alarmWeekday'].toString())).toList();
      _musicIndex = musicList.indexWhere((element) => element['title'] == widget.alarmData['musicTitle'].toString());
    }

    super.initState();

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
    final readProv = context.read<GlobalPageProvider>();

    return Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          toolbarHeight: 64,
          backgroundColor: context.watch<GlobalPageProvider>().background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              // controller.open(DateTimePickerType.time, DateTime.now());
            },
            iconSize: 18,
          ),
          title: const Text(
            "수면 테라피 만들기",
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
                if (_selectStartTime == null || _selectEndTime == null) {
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
                print(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                  DateTime(
                    now.year,
                    now.month,
                    now.day,
                    _selectStartTime!.hour,
                    _selectStartTime!.minute,
                  ),
                ));
                print(DateFormat("yyyy-MM-dd HH:mm:ss").format(
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
                ));

                int musicIndex = _musicIndex;
                if (_musicIndex == -1) {
                  musicIndex = 2;
                }

                if (widget.alarmData == null) {
                  await _server.setAlarm(
                    "SLEEP",
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
                    musicList[musicIndex]['title']!,
                    _selectSnoozeData,
                    _selectCircleDate,
                  );
                } else {
                  await _server.updateAlarm(
                    int.parse(widget.alarmData['alarmId'].toString()),
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
                    musicList[musicIndex]['title']!,
                    _selectSnoozeData,
                    _selectCircleDate,
                  );
                }

                await widget.refresh();

                Future.delayed(Duration.zero, () {
                  Navigator.pop(context, true);
                });
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
        body: MusicBar(
            controller: _controller,
            oldBackground: const Color(0xFFF9F9F9),
            child: SafeArea(
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
                        '수면 음원을 선택해주세요',
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
                                                color: _musicIndex == index
                                                    ? CustomColors.lightGreen2
                                                    : const Color(0xFFD1D1D6),
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
                                          ),
                                          if (musicList[index]['title'] == 'Meditation Melody')
                                            Positioned(
                                              top: 12,
                                              left: 12,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: CustomColors.lightGreen2,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.check_mark_circled,
                                                      size: 14,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      '추천!',
                                                      style: TextStyle(
                                                        fontFamily: "Pretendard",
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
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
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        final idx = pref.getInt('lastMusicIdx');

                                        if (soundPlayer.isPlaying) {
                                          stopBackgroundAudio();
                                          readProv.setIsPlay(false);
                                          if (idx != null && idx != index) {
                                            try {
                                              await playBackgroundAudio(musicList[index]['musicAssets']!);
                                              context.read<GlobalPageProvider>().setIsMusicbar(true);
                                              if (_controller.isBoxVisible) {
                                                _controller.showBox();
                                              }
                                            } catch (e) {
                                              await soundPlayer.openAudioSession();
                                              await playBackgroundAudio(musicList[index]['musicAssets']!);
                                            }
                                            readProv.setIsPlay(true);
                                          }
                                        } else {
                                          readProv.setIsPlay(true);
                                          try {
                                            await playBackgroundAudio(musicList[index]['musicAssets']!);
                                          } catch (e) {
                                            await soundPlayer.openAudioSession();
                                            await playBackgroundAudio(musicList[index]['musicAssets']!);
                                          }
                                        }

                                        if (idx != null) {
                                          await pref.remove('lastMusicIdx');
                                        }
                                        print(_controller.isBoxVisible);

                                        await pref.setInt('lastMusicIdx', index);
                                        Future.delayed(Duration.zero, () {
                                          context.read<GlobalPageProvider>().setIsMusicbar(true);
                                          context.read<GlobalPageProvider>().setMusicIdx(index);
                                          Provider.of<GlobalPageProvider>(context, listen: false).setHeight(73.0);
                                        });
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
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.repeat,
                                  color: CustomColors.secondaryBlack,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'AI 자동 수면 음원 재생',
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
                                    '${_selectStartTime!.hour < 10 ? '0${_selectStartTime!.hour}' : _selectStartTime!.hour}:${_selectStartTime!.minute < 10 ? '0${_selectStartTime!.minute}' : _selectStartTime!.minute} - ${_selectEndTime!.hour < 10 ? '0${_selectEndTime!.hour}' : _selectEndTime!.hour}:${_selectEndTime!.minute < 10 ? '0${_selectEndTime!.minute}' : _selectEndTime!.minute} 해당 수면 시간에 앱에서 알람이 울립니다.',
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
                                          initialTime: _selectStartTime != null ? _selectStartTime! : TimeOfDay.now(),
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
                                          // int start = time.hour * 60 + time.minute;
                                          // int end = _selectEndTime!.hour * 60 + _selectEndTime!.minute;

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
                                          initialTime: _selectStartTime != null ? _selectStartTime! : TimeOfDay.now(),
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

                                        // if (_selectStartTime != null && time != null) {
                                        //   int start = _selectStartTime!.hour * 60 + _selectStartTime!.minute;
                                        //   int end = time.hour * 60 + time.minute;

                                        //   if (start > end) {
                                        //     Future.delayed(Duration.zero, () {
                                        //       showPlatformDialog(
                                        //         context: context,
                                        //         builder: (context) {
                                        //           return BasicDialogAlert(
                                        //             title: const Text(
                                        //               '시간 설정 실패',
                                        //               style: TextStyle(fontFamily: "Pretendard"),
                                        //             ),
                                        //             content: const Text(
                                        //               '끝 시간이 처음보다 나중으로 설정해주세요.',
                                        //               style: TextStyle(fontFamily: "Pretnedard"),
                                        //             ),
                                        //             actions: [
                                        //               BasicDialogAction(
                                        //                 title: const Text(
                                        //                   '확인',
                                        //                   style: TextStyle(
                                        //                     fontFamily: "Pretendard",
                                        //                     color: CustomColors.blue,
                                        //                   ),
                                        //                 ),
                                        //                 onPressed: () {
                                        //                   Navigator.pop(context);
                                        //                 },
                                        //               )
                                        //             ],
                                        //           );
                                        //         },
                                        //       );
                                        //     });
                                        //     return;
                                        //   }
                                        // }

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
                      const SizedBox(height: 42),
                      const SizedBox(height: 63),
                    ],
                  ),
                ),
              ),
            )));
  }
}
