import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class SleepAlarmPage extends StatefulWidget {
  AlarmSettings? alarmSettings;
  dynamic alarmData;

  SleepAlarmPage({super.key, this.alarmSettings});

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

  bool _isStop = false;
  bool _pause = true;

  setAlarmData() async {
    final response = await server.getSleepAlarm(widget.alarmSettings!.id);
    setState(() {
      startDate = DateTime.fromMillisecondsSinceEpoch(int.parse(response.data['startDate'].toString()), isUtc: true);
      endDate = DateTime.fromMillisecondsSinceEpoch(int.parse(response.data['endDate'].toString()), isUtc: true);
    });
  }

  @override
  void initState() {
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
                        const Text(
                          '수면구간',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.systemWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          child: Container(
                            width: deviceWidth - 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: CustomColors.systemWhite.withOpacity(0.6),
                            ),
                            height: 32,
                            child: const Center(
                              child: Text(
                                '오전 06:30 - 오전 7:30',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors.secondaryBlack,
                                ),
                              ),
                            ),
                          ),
                        )
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
                                "${startDate!.hour < 12 ? '오전' : '오후'} ${startDate!.hour}:${startDate!.minute} ~ ${endDate!.hour < 12 ? '오전' : '오후'} ${endDate!.hour}:${endDate!.minute}",
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: CustomColors.lightGreen,
                                ),
                                onPressed: () async {
                                  _pause = !_pause;
                                  if (!_isStop) {
                                    if (widget.alarmSettings != null) {
                                      await Alarm.stop(widget.alarmSettings!.id);
                                    }

                                    _isStop = true;
                                  } else {
                                    if (widget.alarmSettings != null) {
                                      if (_pause) {
                                        await playBackgroundAudio(widget.alarmSettings!.assetAudioPath);
                                      } else {
                                        stopBackgroundAudio();
                                      }
                                    }
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  _pause ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                                  size: 32,
                                  color: CustomColors.lightGreen2,
                                ),
                              )
                            ],
                          )),
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
