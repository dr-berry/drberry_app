import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

class WakeAlarmSettingPage extends StatefulWidget {
  const WakeAlarmSettingPage({super.key});

  @override
  State<WakeAlarmSettingPage> createState() => _WakeAlarmSettingPageState();
}

class _WakeAlarmSettingPageState extends State<WakeAlarmSettingPage> {
  List<Map<String, dynamic>> list = [
    {
      "time": "오전 6:30  ~ 오전 7:30",
      "weekOfNum": ["토", "일"],
      "snooze": ["1m", "3m", "5m"],
      "alarmType": 0,
    },
    {
      "time": "오전 6:30",
      "weekOfNum": ["토", "일"],
      "snooze": ["1m", "3m", "5m"],
      "alarmType": 1,
    },
    {
      "time": "오전 6:30  ~ 오전 7:30",
      "weekOfNum": ["토", "일"],
      "snooze": ["1m", "3m", "5m"],
      "alarmType": 0,
    },
    {
      "time": "오전 7:30",
      "weekOfNum": ["토", "일"],
      "snooze": ["1m", "3m", "5m"],
      "alarmType": 1,
    },
  ];

  List<Widget> getAlarmWidgets(double deviceWidth) {
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
                  onTap: (value) {},
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
                          ),
                        ),
                        const SizedBox(width: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  list[i]['alarmType'] == 0
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
                                    list[i]['time'],
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
                              Column(
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
                                        (list[i]['weekOfNum'] as List<String>).join(','),
                                        style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 15,
                                          color: CustomColors.secondaryBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
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
                                        (list[i]['snooze'] as List<String>).join(','),
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
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ),
      );
    }

    return result;
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
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: const Column(
                  children: [
                    Row(
                      children: [
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
                    SizedBox(height: 8),
                    Row(
                      children: [
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
                    )
                  ],
                ),
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
                      onTap: () {},
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
              ...getAlarmWidgets(deviceWidth),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
