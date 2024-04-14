import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:dio/dio.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SleepAlarmPage extends StatefulWidget {
  AlarmSettings? alarmSettings;
  dynamic alarmData;
  dynamic music;

  SleepAlarmPage({super.key, this.alarmSettings, this.music});

  @override
  State<SleepAlarmPage> createState() => _SleepAlarmPageState();
}

class _SleepAlarmPageState extends State<SleepAlarmPage> {
  VideoPlayerController? _controller;
  FlutterSoundPlayer soundPlayer = FlutterSoundPlayer();
  dynamic alarmData;
  Server server = Server();
  DateTime? startDate;
  DateTime? endDate;
  String musicTitle = "";

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

  Future<void> play(File file) async {
    await soundPlayer.startPlayer(
      fromURI: file.path,
      whenFinished: () => play(file),
    );
  }

  Future<void> playBackgroundAudio(String path) async {
    // print("실행은 함 ㅇㅇ");
    await soundPlayer.openAudioSession();
    print('실행함 ㅇㅅㅇ');
    final file = await getAssetFile(path);

    await soundPlayer.startPlayer(
      fromURI: file.path,
      whenFinished: () {
        play(file);
      },
    );
  }

  void stopBackgroundAudio() async {
    await soundPlayer.stopPlayer();
    await soundPlayer.closeAudioSession();
  }

  final bool _isStop = false;
  bool _pause = true;

  setAlarmData() async {
    // print(widget.alarmSettings?.id);
    // await server.getSleepAlarm(int.parse(widget.alarmSettings!.id.toString())).then((response) {
    //   print(response.data);
    //   setState(() {
    //     startDate = DateTime.fromMillisecondsSinceEpoch(int.parse(response.data['startDate'].toString()), isUtc: true);
    //     endDate = DateTime.fromMillisecondsSinceEpoch(int.parse(response.data['endDate'].toString()), isUtc: true);
    //     musicTitle = response.data['musicTitle'];
    //   });
    // }).catchError((err) {
    //   print(err);
    // });
    // print("-000--0-0-0-0-0-00-");
    // print(startDate);
    // print(endDate);
    // print("-000--0-0-0-0-0-00-");
  }

  @override
  void initState() {
    setAlarmData();
    super.initState();
    _controller = VideoPlayerController.asset('assets/sleep_background.mp4')
      ..initialize().then(
        (value) {
          _controller?.play();
          _controller?.setVolume(0);
          _controller?.setLooping(true);
          setState(() {});
        },
      );

    playBackgroundAudio(widget.music['musicAssets']);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 73, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.arrowtriangle_down_circle_fill,
                          size: 40,
                          color: CustomColors.systemGrey4,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '취침 시간입니다.',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.systemWhite,
                          ),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          '${DateTime.now().hour < 12 ? '오전' : '오후'} ${DateFormat('HH:mm').format(DateTime.now())}',
                          style: const TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 50,
                            color: CustomColors.systemWhite,
                          ),
                        ),
                        const SizedBox(height: 48),
                        // const Text(
                        //   '수면구간',
                        //   style: TextStyle(
                        //     fontFamily: "Pretendard",
                        //     fontSize: 17,
                        //     fontWeight: FontWeight.w500,
                        //     color: CustomColors.systemWhite,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     vertical: 6,
                        //     horizontal: 12,
                        //   ),
                        //   child: Container(
                        //     width: deviceWidth - 200,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(7),
                        //       color: CustomColors.systemWhite.withOpacity(0.6),
                        //     ),
                        //     height: 32,
                        //     child: Center(
                        //       child: Text(
                        //         '${startDate != null && startDate!.hour < 12 ? "오전" : "오후"} ${DateFormat('HH:mm').format(startDate!)} - ${endDate != null && endDate!.hour < 12 ? "오전" : "오후"} ${DateFormat('HH:mm').format(endDate!)}',
                        //         style: const TextStyle(
                        //           fontFamily: "Pretendard",
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w600,
                        //           color: CustomColors.secondaryBlack,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              CustomColors.systemWhite.withOpacity(0.83),
                              CustomColors.systemWhite.withOpacity(0.33),
                              CustomColors.systemWhite.withOpacity(0.33),
                            ],
                          ),
                          border: Border.all(
                            width: 1,
                            color: CustomColors.systemWhite,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: deviceWidth - 32,
                        height: 135,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.music['title']}",
                              style: const TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: CustomColors.lightGreen,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _pause = !_pause;
                                    });
                                    // if (!_isStop) {
                                    //   if (widget.alarmSettings != null) {
                                    //     await Alarm.stop(widget.alarmSettings!.id);
                                    //   }

                                    //   _isStop = true;
                                    // } else {
                                    //   if (widget.alarmSettings != null) {
                                    //     if (_pause) {
                                    //       await playBackgroundAudio(widget.alarmSettings!.assetAudioPath);
                                    //     } else {
                                    //       stopBackgroundAudio();
                                    //     }
                                    //   }
                                    // }
                                    // setState(() {});
                                    if (_pause) {
                                      playBackgroundAudio(widget.music['musicAssets']);
                                    } else {
                                      stopBackgroundAudio();
                                    }
                                  },
                                  icon: Icon(
                                    _pause ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                                    size: 32,
                                    color: CustomColors.lightGreen2,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Material(
                                  color: CustomColors.lightGreen,
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // SvgPicture.asset("assets/power.svg"),
                                          Icon(
                                            CupertinoIcons.stop,
                                            color: CustomColors.lightGreen2,
                                            size: 32,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      Server server = Server();
                                      final state = await server.deviceState().then(
                                        (value) {
                                          return value.data;
                                        },
                                      ).catchError((err) {
                                        return {"state": "disconnected"};
                                      });

                                      Future.delayed(Duration.zero, () {
                                        showPlatformDialog(
                                          context: context,
                                          builder: (context) => BasicDialogAlert(
                                            title: const Text(
                                              '수면을 종료하시겠습니까?',
                                              style: TextStyle(fontFamily: "Pretendard"),
                                            ),
                                            content: const Text(
                                              '수면이 종료되고 수면 패턴을 저장합니다.',
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
                                                  context.read<HomePageProvider>().setSleepState(false);
                                                  Navigator.pop(context);

                                                  await server.endSleepWithDummy().then((value) {
                                                    showPlatformDialog(
                                                      context: context,
                                                      builder: (context) => BasicDialogAlert(
                                                        title: const Text(
                                                          '저장 완료',
                                                          style: TextStyle(fontFamily: "Pretendard"),
                                                        ),
                                                        content: const Text(
                                                          '수면데이터 저장이 선공적으로 완료되었습니다.',
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
                                                  }).catchError((err) {
                                                    print(err);
                                                    if (err is DioException) {
                                                      if (err.response?.statusCode == 400) {
                                                        showPlatformDialog(
                                                          context: context,
                                                          builder: (context) => BasicDialogAlert(
                                                            title: const Text(
                                                              '저장 실패',
                                                              style: TextStyle(fontFamily: "Pretendard"),
                                                            ),
                                                            content: const Text(
                                                              '수면 데이터가 너무 적어 저장하지 못했습니다.',
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
                                                    showPlatformDialog(
                                                      context: context,
                                                      builder: (context) => BasicDialogAlert(
                                                        title: const Text(
                                                          '데이터 저장 실패..',
                                                          style: TextStyle(fontFamily: "Pretendard"),
                                                        ),
                                                        content: Text(
                                                          err.toString(),
                                                          style: const TextStyle(fontFamily: "Pretnedard"),
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
                                                  });
                                                },
                                              ),
                                              BasicDialogAction(
                                                title: const Text(
                                                  '취소',
                                                  style: TextStyle(
                                                    fontFamily: "Pretendard",
                                                    color: CustomColors.red,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
