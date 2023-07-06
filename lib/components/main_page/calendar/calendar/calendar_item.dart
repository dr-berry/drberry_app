import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar/month_days_widget.dart';
import 'package:drberry_app/components/main_page/calendar/calendar/week_month_widget.dart';
import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:flutter/material.dart';

class CalendarItem extends StatefulWidget {
  final int index;
  final Month month;
  final int segment;
  final ValueNotifier<int> controller;

  const CalendarItem(
      {super.key, required this.index, required this.month, required this.segment, required this.controller});

  @override
  State<CalendarItem> createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
          padding: const EdgeInsets.only(top: 24),
          margin: const EdgeInsets.only(bottom: 8),
          color: CustomColors.systemWhite,
          width: deviceWidth,
          height: 140 + (((deviceWidth / 7) * (861 / deviceWidth)) * 6),
          child: SizedBox(
            // height: deviceHeight + 50,
            // color: CustomColors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        "${widget.month.month}월",
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w700,
                            color: CustomColors.systemBlack),
                      ),
                    ),
                  ],
                ),
                const WeekMonthWidget(),
                MonthDaysWidget(
                    index: widget.index, month: widget.month, segment: widget.segment, controller: widget.controller),
                const SizedBox(height: 9),
                Container(
                  height: 1,
                  color: CustomColors.systemGrey6,
                ),
                const SizedBox(height: 13),
              ],
            ),
          )),
    );
  }
}
