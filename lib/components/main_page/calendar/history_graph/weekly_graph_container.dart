import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/history_stick_chart.dart';
import 'package:drberry_app/custom/custom_chart/history_wave_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/Data.dart';

class WeeklyGraphContainer extends StatefulWidget {
  final History weekHistory;

  const WeeklyGraphContainer({super.key, required this.weekHistory});

  @override
  State<WeeklyGraphContainer> createState() => _WeeklyGraphContainerState();
}

class _WeeklyGraphContainerState extends State<WeeklyGraphContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        final deviceWidth = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Container(
              width: deviceWidth - 32,
              margin: EdgeInsets.only(bottom: 51.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: CustomColors.systemWhite,
              ),
              padding: EdgeInsets.only(top: 22.h, left: 12, bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    child: CustomPaint(
                      painter: HistoryStickChart(
                        size: Size((deviceWidth - 63), ((deviceWidth - 63) * 0.6606060606060606).h),
                        datas: widget.weekHistory.graph,
                        labels: widget.weekHistory.labels,
                      ),
                      size: Size((deviceWidth - 63).w, ((deviceWidth - 63) * 0.6606060606060606).h),
                    ),
                  ),
                  SizedBox(height: 29.h),
                  Container(
                    padding: const EdgeInsets.only(left: 4, right: 16),
                    child: Container(
                      width: deviceWidth - 64,
                      height: 1,
                      color: const Color(0xFFF2F2F7),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                      padding: const EdgeInsets.only(right: 16, left: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                child: Text(
                                  '평균 수면 스코어',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(10, 30.h, 0, 10.h),
                                  child: RepaintBoundary(
                                    child: CustomPaint(
                                        painter: ArcChart(
                                            percentage: widget.weekHistory.detail.avgScore.toDouble(),
                                            strokeWidth: deviceWidth * 0.035),
                                        size: Size((deviceWidth * 0.28).w, (deviceWidth * 0.18).h)),
                                  )),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 145.h,
                            margin: EdgeInsets.fromLTRB(20, 0, 15.w, 0),
                            color: CustomColors.systemGrey5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 6.h),
                                child: Text(
                                  '최고 스코어',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: (deviceWidth - 80.w) / 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 12.h),
                                      child: Text(
                                        widget.weekHistory.detail.maxScore.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w400,
                                            color: CustomColors.lightGreen2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 1,
                                  width: (deviceWidth - 80) / 2,
                                  margin: EdgeInsets.fromLTRB(0, 4.h, 0, 12.h),
                                  color: CustomColors.systemGrey5),
                              Text('날짜',
                                  style: TextStyle(
                                      color: CustomColors.secondaryBlack,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Pretendard')),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
                                child: Text(
                                  widget.weekHistory.detail.maxScoreDate,
                                  style: TextStyle(
                                    color: CustomColors.secondaryBlack,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
