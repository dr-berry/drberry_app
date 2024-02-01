import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/dio.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:drberry_app/components/main_page/home/home_page.dart';
import 'package:drberry_app/components/main_page/profile/profile_page.dart';
import 'package:drberry_app/components/main_page/sleep_pad/sleep_pad_page.dart';
import 'package:drberry_app/provider/global_provider.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/screen/music_bar.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollcontroller = ScrollController();
  final controller = PageController(initialPage: 0);
  Color background = const Color(0xFFF9F9F9);
  final BoxController _controller = BoxController();
  final bool _sleepState = false;
  Server server = Server();
  bool isPadOff = false;
  double _index = 0;

  void getSleepState() async {
    final sleepState = await server.getSleepState();
    // setState(() {
    //   _sleepState = sleepState.data;
    // });
    context.read<HomePageProvider>().setSleepState(bool.parse(sleepState.data));
  }

  @override
  void initState() {
    getSleepState();
    controller.addListener(() {
      setState(() {
        _index = controller.offset;
      });
      print("offset");
      print(controller.page);
      print("offset");
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isLoadingStart = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<GlobalPageProvider>().background,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/home.png")), label: "홈"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/history.png")), label: "히스토리"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/pad.png")), label: "수면패드"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/profile.png")), label: "프로필")
          ],
          selectedLabelStyle:
              const TextStyle(fontFamily: 'Pretendard', fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFFAEAEB2),
          unselectedLabelStyle: const TextStyle(
              fontFamily: 'Pretendard', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFFAEAEB2)),
          iconSize: 28,
          onTap: (value) {
            if (isLoadingStart) {
              Future.delayed(Duration.zero, () {
                showPlatformDialog(
                  context: context,
                  builder: (context) => BasicDialogAlert(
                    title: const Text(
                      '수면 시작중',
                      style: TextStyle(fontFamily: "Pretendard"),
                    ),
                    content: const Text(
                      '수면 및 기록 준비중입니다. 잠시만 기다려주세요.',
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
              });
              return;
            }
            print(value);

            print("=========");
            print(_controller.getPosition);
            print("=========");
            if (value == 2 || value == 3 || value == 1 || value == 0) {
              context.read<GlobalPageProvider>().setIsMusicbar(false);
              _controller.hideBox();
            } else {
              context.read<GlobalPageProvider>().setIsMusicbar(true);
              _controller.setPosition(0);
              if (!_controller.isBoxVisible) {
                _controller.showBox();
              }
            }

            if (value != 0 && context.read<MainPageProvider>().pageIndx == 0) {
              _scrollcontroller.dispose();
            } else {
              _scrollcontroller = ScrollController();
            }

            if (value == 0 && context.read<MainPageProvider>().pageIndx == 0) {
              _scrollcontroller.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
              );
            }

            context.read<MainPageProvider>().setIndex(value);
            controller.jumpToPage(value);
          },
          currentIndex: context.watch<MainPageProvider>().pageIndx,
          backgroundColor: const Color(0xFFFFFFFF),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: context.watch<GlobalPageProvider>().background,
        ),
      ),
      body: MusicBar(
        controller: _controller,
        oldBackground: background,
        child: Stack(
          children: [
            SafeArea(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                onPageChanged: (value) {
                  print("value $value");
                  switch (value) {
                    case 0:
                      context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                      setState(() {
                        background = const Color(0xFFF9F9F9);
                      });
                      break;
                    case 1:
                      context.read<GlobalPageProvider>().setBackground(const Color(0xFFFFFFFF));
                      setState(() {
                        background = const Color(0xffffffff);
                      });
                      break;
                    case 2:
                      context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                      setState(() {
                        background = const Color(0xFFF9F9F9);
                      });
                      break;
                    default:
                      context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                      setState(() {
                        background = const Color(0xFFF9F9F9);
                      });
                  }
                  context.read<MainPageProvider>().setIndex(value);
                },
                children: [
                  HomePage(
                    controller: _scrollcontroller,
                  ),
                  CalendarPage(
                    deviceWidth: MediaQuery.of(context).size.width,
                  ),
                  const SleepPadPage(),
                  const ProfilePage()
                ],
              ),
            ),
            if (isLoadingStart)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withAlpha(70),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularCountDownTimer(
                        width: 60,
                        height: 60,
                        duration: 5,
                        fillColor: CustomColors.systemGrey3,
                        ringColor: CustomColors.lightGreen2,
                        onComplete: () {
                          print("끝!");
                          getSleepState();
                          setState(() {
                            isLoadingStart = false;
                          });
                        },
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Pretendard",
                        ),
                        isReverse: true,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "수면 및 기록 준비중입니다...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isLoading)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withAlpha(70),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "수면 종료 및 데이터 처리중",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        color: CustomColors.lightGreen2,
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: _index == 0
          ? SizedBox(
              // margin: const EdgeInsets.only(bottom: 70),
              width: 124,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: CustomColors.lightGreen2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/power.svg"),
                    const SizedBox(
                      width: 3,
                    ),
                    context.watch<HomePageProvider>().sleepState
                        ? const Text(
                            "수면종료",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "수면시작",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                  ],
                ),
                onPressed: () async {
                  if (isLoadingStart) {
                    Future.delayed(Duration.zero, () {
                      showPlatformDialog(
                        context: context,
                        builder: (context) => BasicDialogAlert(
                          title: const Text(
                            '수면 시작중',
                            style: TextStyle(fontFamily: "Pretendard"),
                          ),
                          content: const Text(
                            '수면 및 기록 준비중입니다. 잠시만 기다려주세요.',
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
                                getSleepState();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    });
                    return;
                  }

                  Server server = Server();
                  final state = await server.deviceState().then(
                    (value) {
                      return value.data;
                    },
                  ).catchError((err) {
                    return {"state": "disconnected"};
                  });

                  if (state['state'] == "disconnected") {
                    Future.delayed(Duration.zero, () {
                      showPlatformDialog(
                        context: context,
                        builder: (context) => BasicDialogAlert(
                          title: const Text(
                            '디바이스 연결 에러',
                            style: TextStyle(fontFamily: "Pretendard"),
                          ),
                          content: const Text(
                            '디바이스의 인터넷, 물리적 선 연결에 문제가 있습니다 한번더 확인해 주세요',
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
                    });
                    return;
                  }

                  // if (!context.read<HomePageProvider>().sleepState && state['state'] != 'padOn') {
                  //   Future.delayed(Duration.zero, () {
                  //     showPlatformDialog(
                  //       context: context,
                  //       builder: (context) => BasicDialogAlert(
                  //         title: const Text(
                  //           '수면 시작 실패',
                  //           style: TextStyle(fontFamily: "Pretendard"),
                  //         ),
                  //         content: const Text(
                  //           '수면을 시작하려면 닥터베리 패드에 누워 On Pad 상태에서만 가능합니다. 패드에 누워 수면을 시작해주세요!',
                  //           style: TextStyle(fontFamily: "Pretnedard"),
                  //         ),
                  //         actions: [
                  //           BasicDialogAction(
                  //             title: const Text(
                  //               '확인',
                  //               style: TextStyle(
                  //                 fontFamily: "Pretendard",
                  //                 color: CustomColors.blue,
                  //               ),
                  //             ),
                  //             onPressed: () async {
                  //               Navigator.pop(context);
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   });
                  //   return;
                  // }

                  if (context.read<HomePageProvider>().sleepState) {
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
                                setState(() {
                                  isLoading = true;
                                });
                                Navigator.pop(context);
                                await server.endSleep().then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: const Text(
                                        "수면 종료",
                                        style: TextStyle(fontFamily: "Pretendard"),
                                      ),
                                      content: const Text(
                                        "수면이 종료되었습니다",
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
                                            setState(() {
                                              isLoading = false;
                                            });
                                            getSleepState();
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
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                getSleepState();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
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
                                            getSleepState();
                                            setState(() {
                                              isLoadingStart = false;
                                            });
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
                  } else {
                    Future.delayed(Duration.zero, () {
                      showPlatformDialog(
                        context: context,
                        builder: (context) => BasicDialogAlert(
                          title: const Text(
                            '수면을 시작하시겠습니까?',
                            style: TextStyle(fontFamily: "Pretendard"),
                          ),
                          content: const Text(
                            '수면이 시작됩니다.',
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
                                setState(() {
                                  isLoadingStart = true;
                                });
                                Navigator.pop(context);
                                await server.startSleep();
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
                  }
                },
              ),
            )
          : Container(),
    );
  }
}
