import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:drberry_app/custom/custom_chart/circular_chart.dart';
import 'package:flutter/material.dart';

class MonthDaysWidget extends StatelessWidget {
  final int index;
  final List<Day> dayData;

  const MonthDaysWidget({Key? key, required this.index, required this.dayData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    var days = dayData;
    if (days[6].day == 0) {
      days = days.sublist(7);
    }

    return Expanded(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: (1 / (861 / deviceWidth)),
        ),
        itemCount: days.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, idx) {
          return days[idx].day > 0
              ? Material(
                  color: CustomColors.systemWhite,
                  child: InkWell(
                      onTap: () {
                        print("tap!");
                      },
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  (days[idx].day).toString(),
                                  style: const TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8E8E93)),
                                ),
                                const SizedBox(height: 13),
                                RepaintBoundary(
                                  child: CustomPaint(
                                      painter: CircularChart(
                                          percentage: days[idx].score.toDouble() < 0 ? 0 : days[idx].score.toDouble(),
                                          isScoreState: false,
                                          strokeWidth: 5.5),
                                      size: const Size(30, 30)),
                                ),
                                const SizedBox(height: 13),
                                Text(
                                  days[idx].score < 0 ? "-" : "${days[idx].score}",
                                  style: const TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors.systemBlack),
                                ),
                              ]),
                          _buildPositioned(deviceWidth, days, idx),
                        ],
                      )),
                )
              : _buildRow(deviceWidth, days, idx);
        },
      ),
    );
  }

  Widget _buildPositioned(double deviceWidth, List<Day> days, int idx) {
    if ((days.length <= 35 && idx < 28) || (days.length > 35 && idx < 35)) {
      if (idx % 7 == 0) {
        return Positioned(
          bottom: 0,
          right: 0,
          child: _buildRow(deviceWidth, days, idx),
        );
      } else {
        return Positioned(
          bottom: 0,
          left: 0,
          child: _buildRow(deviceWidth, days, idx),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildRow(double deviceWidth, List<Day> days, int idx) {
    if ((idx <= 35 && idx < 28) || (idx > 35 && idx < 35)) {
      return Row(
        mainAxisAlignment: idx % 7 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: idx == 0 || (idx + 1) % 7 == 0 || idx % 7 == 0 ? deviceWidth / 7 - 20 : deviceWidth / 7,
            height: 1,
            color: const Color(0xFFE5E5EA),
          )
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
