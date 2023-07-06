import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/history_wave_chart.dart';
import 'package:flutter/material.dart';

class HistoryGraphPage extends StatefulWidget {
  final ValueNotifier<int> graphController;

  const HistoryGraphPage({super.key, required this.graphController});

  @override
  State<HistoryGraphPage> createState() => _HistoryGraphPageState();
}

class _HistoryGraphPageState extends State<HistoryGraphPage> {
  final GlobalKey _historyKey = GlobalKey();
  double height = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox box = _historyKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        height = box.size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: widget.graphController,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 115),
            Container(
              padding: const EdgeInsets.only(top: 26, bottom: 28, left: 100, right: 100),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () {
                    widget.graphController.value = 0;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: value == 0 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(
                      "주",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "WorkSans",
                          fontWeight: FontWeight.w400,
                          color: CustomColors.secondaryBlack),
                    ),
                  ),
                ),
                const SizedBox(width: 45),
                GestureDetector(
                  onTap: () {
                    widget.graphController.value = 1;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: value == 1 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(
                      "월",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "WorkSans",
                          fontWeight: FontWeight.w400,
                          color: CustomColors.secondaryBlack),
                    ),
                  ),
                ),
                const SizedBox(width: 45),
                GestureDetector(
                  onTap: () {
                    widget.graphController.value = 2;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: value == 2 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(
                      "년",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "WorkSans",
                          fontWeight: FontWeight.w400,
                          color: CustomColors.secondaryBlack),
                    ),
                  ),
                )
              ]),
            ),
            Expanded(
              child: Container(
                width: deviceWidth - 32,
                margin: const EdgeInsets.only(bottom: 51),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: CustomColors.systemWhite),
                padding: const EdgeInsets.only(top: 22, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RepaintBoundary(
                      child: CustomPaint(
                        painter: HistoryLineChart(
                          size: Size(deviceWidth - 63, 218),
                          datas: [60, 75, 82, 72, 80, 55, 90],
                          labels: [
                            "5/1",
                            "5/2",
                            "5/3",
                            "5/4",
                            "5/5",
                            "5/6",
                            "5/7",
                          ],
                        ),
                        size: Size(deviceWidth - 63, 218),
                      ),
                    ),
                    const SizedBox(height: 29),
                    Container(
                      padding: const EdgeInsets.only(left: 4, right: 16),
                      child: Container(
                        width: deviceWidth - 64,
                        height: 1,
                        color: const Color(0xFFF2F2F7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                        padding: const EdgeInsets.only(right: 16, left: 4),
                        child: Row(
                          key: _historyKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                  child: const Text(
                                    '평균 수면 스코어',
                                    style:
                                        TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.fromLTRB(10, 30, 0, 10),
                                    child: RepaintBoundary(
                                      child: CustomPaint(
                                          painter: ArcChart(percentage: 83, strokeWidth: deviceWidth * 0.035),
                                          size: Size(deviceWidth * 0.28, deviceWidth * 0.18)),
                                    )),
                              ],
                            ),
                            Container(
                              width: 1,
                              height: height,
                              margin: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                              color: CustomColors.systemGrey5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  child: const Text(
                                    '최고 스코어',
                                    style:
                                        TextStyle(fontFamily: 'Pretendard', fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: (deviceWidth - 80) / 2,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                        child: const Text(
                                          "82",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 28,
                                              fontWeight: FontWeight.w400,
                                              color: CustomColors.lightGreen2),
                                        ),
                                      ),
                                      // Container(
                                      //     width: 47,
                                      //     height: 30,
                                      //     decoration: BoxDecoration(
                                      //         color: CustomColors.lightBlue,
                                      //         border: Border.all(
                                      //             color: CustomColors.blue,
                                      //             width: 1.0,
                                      //             style: BorderStyle.solid),
                                      //         borderRadius: BorderRadius.circular(15)),
                                      //     child: const Center(
                                      //       child: Text(
                                      //         '보통',
                                      //         style: TextStyle(
                                      //             color: CustomColors.secondaryBlack,
                                      //             fontSize: 13,
                                      //             fontFamily: 'Pretendard',
                                      //             fontWeight: FontWeight.w400),
                                      //       ),
                                      //     ))
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 1,
                                    width: (deviceWidth - 80) / 2,
                                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 12),
                                    color: CustomColors.systemGrey5),
                                const Text('날짜',
                                    style: TextStyle(
                                        color: CustomColors.secondaryBlack,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Pretendard')),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                  child: const Text("5월 5일",
                                      style: TextStyle(
                                          color: CustomColors.secondaryBlack,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Pretendard')),
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
