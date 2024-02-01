import 'dart:io';
import 'dart:typed_data';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/provider/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicBar extends StatefulWidget {
  final Widget child;
  final Color oldBackground;
  final BoxController controller;

  const MusicBar({
    super.key,
    required this.child,
    required this.oldBackground,
    required this.controller,
  });

  @override
  State<MusicBar> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar> with SingleTickerProviderStateMixin {
  Color background = const Color(0xFFF9F9F9);
  AnimationController? _animationController;
  Animation<double>? _animation;
  double position = 0.0;
  double height = 73.0;

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
      whenFinished: () => play(file),
    );
  }

  void stopBackgroundAudio() async {
    await soundPlayer.stopPlayer();
    await soundPlayer.closeAudioSession();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addListener(() {
        print(_animation);
        widget.controller.setPosition(_animation!.value);
      });

    _animationController!.reverse();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final musicIndex = pref.getInt('lastMusicIdx');

      if (soundPlayer.isPlaying || soundPlayer.isOpen()) {
        context.read<GlobalPageProvider>().setIsPlay(true);
      }

      print("music bar : ${context.read<GlobalPageProvider>().isMusicBar}");

      // ignore: use_build_context_synchronously
      if (context.read<GlobalPageProvider>().isMusicBar) {
        if (musicIndex != null) {
          context.read<GlobalPageProvider>().setMusicIdx(musicIndex);
        } else {
          await pref.setInt('lastMusicIdx', 0);
        }
      } else {
        context.read<GlobalPageProvider>().setHeight(0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final watchProv = context.watch<GlobalPageProvider>();
    final readProv = context.read<GlobalPageProvider>();

    // if (readProv.isMusicBar && height < 73) {
    //   setState(() {
    //     height = 73.0;
    //   });
    //   print("박스 켜져랏!");
    //   readProv.setIsPlay(true);
    // }
    return Consumer<GlobalPageProvider>(
      builder: (context, value, child) {
        return SlidingBox(
          controller: widget.controller,
          minHeight: value.height,
          maxHeight: deviceHeight,
          borderRadius: BorderRadius.zero,
          draggableIconVisible: false,
          draggable: false,
          onBoxSlide: (position) {
            if (position == 1.0) {
              background = readProv.setBackground(const Color(0xFFEDEDED));
            } else {
              background = readProv.setBackground(widget.oldBackground);
            }
          },
          body: GestureDetector(
            onVerticalDragEnd: (details) {
              if (widget.controller.getPosition == 1) {
                if (details.velocity.pixelsPerSecond.dy > 0) {
                  // widget.controller.setPosition(0);
                  _animationController?.reverse();
                }
              }
              print(details.velocity.pixelsPerSecond.dy);
            },
            child: Container(
              height: deviceHeight,
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              onPressed: () {
                                // widget.controller.hideBox();
                                widget.controller.closeBox();
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                        image: AssetImage(musicList[watchProv.musicIdx]['imageAssets']!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    musicList[watchProv.musicIdx]['title']!,
                                    style: const TextStyle(
                                      fontFamily: "SF-Pro",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 70,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        if (soundPlayer.isPlaying || soundPlayer.isOpen()) {
                                          readProv.setIsPlay(false);
                                          stopBackgroundAudio();
                                        } else {
                                          readProv.setIsPlay(true);
                                          try {
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          } catch (e) {
                                            await soundPlayer.openAudioSession();
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        !watchProv.isPlay ? CupertinoIcons.play_arrow_solid : CupertinoIcons.pause_fill,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        SharedPreferences pref = await SharedPreferences.getInstance();
                                        if (watchProv.musicIdx == musicList.length - 1) {
                                          pref.setInt('lastMusicIdx', 0);
                                          readProv.setMusicIdx(0);
                                          if (soundPlayer.isPlaying) {
                                            stopBackgroundAudio();
                                          }
                                          await soundPlayer.openAudioSession();
                                          try {
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          } catch (e) {
                                            await soundPlayer.openAudioSession();
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          }
                                        } else {
                                          pref.setInt('lastMusicIdx', watchProv.musicIdx + 1);
                                          readProv.setMusicIdx(watchProv.musicIdx + 1);
                                          if (soundPlayer.isPlaying) {
                                            stopBackgroundAudio();
                                          }
                                          try {
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          } catch (e) {
                                            await soundPlayer.openAudioSession();
                                            await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.forward_fill,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 174),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      height: deviceHeight - 110,
                      child: ListView.builder(
                        itemCount: musicList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            // padding: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 20),
                            color: index == watchProv.musicIdx ? const Color(0xFFF9F9F9) : CustomColors.systemWhite,
                            child: Material(
                              color: index == watchProv.musicIdx ? const Color(0xFFF9F9F9) : CustomColors.systemWhite,
                              child: InkWell(
                                onTap: () async {
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setInt('lastMusicIdx', index);

                                  if (soundPlayer.isPlaying) {
                                    stopBackgroundAudio();
                                    readProv.setIsPlay(false);
                                  }
                                  readProv.setIsPlay(true);
                                  readProv.setMusicIdx(index);
                                  try {
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  } catch (e) {
                                    await soundPlayer.openAudioSession();
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  }
                                },
                                child: SizedBox(
                                  height: 64,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  musicList[index]['imageAssets']!,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            musicList[index]['title']!,
                                            style: const TextStyle(
                                              fontFamily: "SF-Pro",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          collapsed: true,
          collapsedBody: GestureDetector(
            onVerticalDragEnd: (details) {
              if (widget.controller.getPosition == 0) {
                if (details.velocity.pixelsPerSecond.dy > 0) {
                  // widget.controller.hideBox();
                  readProv.setHeight(0.0);
                  readProv.setIsMusicbar(false);
                  if (soundPlayer.isPlaying) {
                    stopBackgroundAudio();
                    readProv.setIsPlay(false);
                  }
                } else {
                  // widget.controller.setPosition(1);
                  widget.controller.showBox();
                  _animationController?.forward();
                }
              } else {
                _animationController?.forward();
              }
              print(details.velocity.pixelsPerSecond.dy);
            },
            onTap: () {
              _animationController?.forward();
              widget.controller.showBox();
            },
            child: Container(
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
                // color: Colors.amber,
              ),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 4,
                          width: 100,
                          decoration: BoxDecoration(
                            color: CustomColors.systemGrey2,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: AssetImage(musicList[watchProv.musicIdx]['imageAssets']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              musicList[watchProv.musicIdx]['title']!,
                              style: const TextStyle(
                                fontFamily: "SF-Pro",
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (soundPlayer.isPlaying || soundPlayer.isOpen()) {
                                  readProv.setIsPlay(false);
                                  stopBackgroundAudio();
                                } else {
                                  readProv.setIsPlay(true);
                                  try {
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  } catch (e) {
                                    await soundPlayer.openAudioSession();
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  }
                                }
                              },
                              icon: Icon(
                                !watchProv.isPlay ? CupertinoIcons.play_arrow_solid : CupertinoIcons.pause_fill,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                if (watchProv.musicIdx == musicList.length - 1) {
                                  pref.setInt('lastMusicIdx', 0);
                                  readProv.setMusicIdx(0);
                                  if (soundPlayer.isPlaying) {
                                    stopBackgroundAudio();
                                  }
                                  await soundPlayer.openAudioSession();
                                  try {
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  } catch (e) {
                                    await soundPlayer.openAudioSession();
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  }
                                } else {
                                  pref.setInt('lastMusicIdx', watchProv.musicIdx + 1);
                                  readProv.setMusicIdx(watchProv.musicIdx + 1);
                                  if (soundPlayer.isPlaying) {
                                    stopBackgroundAudio();
                                  }
                                  try {
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  } catch (e) {
                                    await soundPlayer.openAudioSession();
                                    await playBackgroundAudio(musicList[watchProv.musicIdx]['musicAssets']!);
                                  }
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.forward_fill,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          color: const Color(0xFFEDEDED),
          backdrop: Backdrop(body: widget.child),
        );
      },
    );
  }
}
