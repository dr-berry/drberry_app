import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/home/modal/select_modal_bottom_sheet.dart';
import 'package:drberry_app/custom/custom_chart/circular_chart.dart';
import 'package:drberry_app/custom/custom_chart/gauge_chart.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TodayShortData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;
  final String today;
  const TodayShortData({super.key, required this.defaultBoxDecoration, required this.today});

  @override
  State<TodayShortData> createState() => _TodayShortDataState();
}

class _TodayShortDataState extends State<TodayShortData> {
  Server server = Server();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
        child: Container(
      width: deviceWidth - 32,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
      decoration: widget.defaultBoxDecoration,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 13, 0, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.transparent,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent;
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/select_data_icon.svg',
                      color: Colors.transparent,
                    ),
                  ),
                  const Text(
                    'Today 수면 스코어',
                    style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.systemBlack,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400),
                  ),
                  context.watch<HomePageProvider>().mainPageBiometricData != null &&
                          context.watch<HomePageProvider>().mainPageBiometricData!.isMultipleData != null &&
                          context.watch<HomePageProvider>().mainPageBiometricData!.isMultipleData!
                      ? IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SelectModalBottomSheet(
                                  selectDate: widget.today,
                                );
                              },
                            );
                          },
                          icon: SvgPicture.asset('assets/select_data_icon.svg'),
                        )
                      : IconButton(
                          color: Colors.transparent,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.transparent;
                                }
                                return null;
                              },
                            ),
                          ),
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/select_data_icon.svg',
                            color: Colors.transparent,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 47),
                    child: RepaintBoundary(
                      child: CustomPaint(
                          painter: CircularChart(
                              percentageTextSize: 47,
                              percentage: context.read<HomePageProvider>().mainPageBiometricData != null &&
                                      context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? double.parse(
                                      "${context.read<HomePageProvider>().mainPageBiometricData!.simpleSleepData!.sleepScore}")
                                  : 0,
                              scoreStateTextSize: 17,
                              backgroundColor: CustomColors.systemGrey5),
                          size: const Size(185, 185)),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: const Text('총 수면시간',
                        style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.systemBlack,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                    child: Text(
                      context.watch<HomePageProvider>().mainPageBiometricData != null &&
                              context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                          ? context.watch<HomePageProvider>().mainPageBiometricData!.simpleSleepData!.totalSleepTime
                          : "-",
                      style: const TextStyle(
                          fontSize: 24,
                          color: CustomColors.systemBlack,
                          fontFamily: 'SF-Pro',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 69),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: GaugeChart(
                              data: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? context.watch<HomePageProvider>().mainPageBiometricData!.sleepHistoryGague!
                                  : [],
                              start: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? context
                                      .watch<HomePageProvider>()
                                      .mainPageBiometricData!
                                      .simpleSleepData!
                                      .measurementStartTime
                                  : "",
                              end: context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                      context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                                  ? context
                                      .watch<HomePageProvider>()
                                      .mainPageBiometricData!
                                      .simpleSleepData!
                                      .measurementEndTime
                                  : "",
                              size: 28),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
