import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SleepTimeData extends StatefulWidget {
  final BoxDecoration defaultBoxDecoration;
  const SleepTimeData({super.key, required this.defaultBoxDecoration});

  @override
  State<SleepTimeData> createState() => _SleepTimeDataState();
}

class _SleepTimeDataState extends State<SleepTimeData> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (deviceWidth - 47) / 2,
            padding: const EdgeInsets.fromLTRB(28, 24, 0, 21),
            margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            decoration: widget.defaultBoxDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/deep_sleep_time_icon.svg'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text(
                        '딥수면 시간',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'Pretendard'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                            ? context
                                .watch<HomePageProvider>()
                                .mainPageBiometricData!
                                .simpleSleepData!
                                .deepSleepTimeDiff
                            : "-",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, fontFamily: 'SF-Pro'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            width: (deviceWidth - 47) / 2,
            padding: const EdgeInsets.fromLTRB(28, 24, 0, 21),
            margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/sleep_time_icon.svg'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text(
                        '잠들기까지',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'Pretendard'),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        context.watch<HomePageProvider>().mainPageBiometricData != null &&
                                context.watch<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                            ? context
                                .watch<HomePageProvider>()
                                .mainPageBiometricData!
                                .simpleSleepData!
                                .whenSleepTimeDiff
                            : "-",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, fontFamily: 'SF-Pro'),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
