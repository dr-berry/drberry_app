import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SegmentText extends StatefulWidget {
  const SegmentText({super.key});

  @override
  State<SegmentText> createState() => SegmentTextState();
}

class SegmentTextState extends State<SegmentText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "캘린더",
          style: TextStyle(
              fontFamily: "SF-Pro",
              fontWeight: context.watch<CalendarPageProvider>().pageIndex == 0 ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
              color: context.watch<CalendarPageProvider>().pageIndex == 0
                  ? CustomColors.lightGreen2
                  : CustomColors.secondaryBlack),
        ),
        Text(
          "그래프",
          style: TextStyle(
              fontFamily: "SF-Pro",
              fontWeight: context.watch<CalendarPageProvider>().pageIndex == 1 ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
              color: context.watch<CalendarPageProvider>().pageIndex == 1
                  ? CustomColors.lightGreen2
                  : CustomColors.secondaryBlack),
        ),
      ],
    );
  }
}
