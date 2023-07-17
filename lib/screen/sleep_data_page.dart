import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/sleep_data/sleep_data_bottom_sheet.dart';
import 'package:flutter/material.dart';

class SleepDataPage extends StatefulWidget {
  const SleepDataPage({super.key});

  @override
  State<SleepDataPage> createState() => _SleepDataPageState();
}

class _SleepDataPageState extends State<SleepDataPage> {
  @override
  Widget build(BuildContext context) {
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
          "수면 데이터 전송",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: CustomColors.secondaryBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '수면데이터',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Material(
                  color: CustomColors.systemWhite,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const SleepDataBottomSheet();
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFE5E5EA),
                          width: 1,
                        ),
                      ),
                      height: 68,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 17, right: 25),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '전체 수면 리포트 내보내기',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              color: CustomColors.systemBlack,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
