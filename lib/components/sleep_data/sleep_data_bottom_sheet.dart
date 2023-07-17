import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/screen/export_biometric_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepDataBottomSheet extends StatefulWidget {
  const SleepDataBottomSheet({super.key});

  @override
  State<SleepDataBottomSheet> createState() => _SleepDataBottomSheetState();
}

class _SleepDataBottomSheetState extends State<SleepDataBottomSheet> {
  int _isChecked = 0;
  DateTime? _selectStartDate;
  DateTime? _selectEndDate;

  DateTime? _lastMonthStart;
  DateTime? _lastMonthEnd;

  DateTime? _lastQuarterStart;
  DateTime? _lastQuarterEnd;

  @override
  void initState() {
    super.initState();

    DateTime today = DateTime.now();
    DateTime lastMonthStart = DateTime(today.year, today.month - 1, 1);
    DateTime lastMonthEnd = DateTime(today.year, today.month, 1).subtract(const Duration(days: 1));

    int lastQuarter;

    if (today.month < 4) {
      lastQuarter = 4;
    } else if (today.month < 7) {
      lastQuarter = 1;
    } else if (today.month < 10) {
      lastQuarter = 2;
    } else {
      lastQuarter = 3;
    }

    int year = (lastQuarter == 4) ? today.year - 1 : today.year;

    DateTime startOfLastQuarter = DateTime(year, lastQuarter * 3 - 2, 1);
    DateTime endOfLastQuarter = DateTime(year, lastQuarter * 3 + 1, 1).subtract(const Duration(days: 1));

    setState(() {
      _lastMonthStart = lastMonthStart;
      _lastMonthEnd = lastMonthEnd;
      _lastQuarterStart = startOfLastQuarter;
      _lastQuarterEnd = endOfLastQuarter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: deviceHeight * 0.55,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: CustomColors.systemWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '기간 선택',
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.systemBlack,
                        ),
                      ),
                      Material(
                        child: InkWell(
                          child: Container(
                            color: Colors.transparent,
                            width: 24,
                            height: 24,
                            child: const Icon(
                              color: Colors.transparent,
                              Icons.arrow_back_ios,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: CustomColors.systemWhite,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_isChecked == 2) {
                          _selectEndDate = null;
                          _selectStartDate = null;
                        }

                        _isChecked = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 27, right: 27),
                      height: 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_isChecked == 2) {
                                      _selectEndDate = null;
                                      _selectStartDate = null;
                                    }

                                    _isChecked = 0;
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _isChecked == 0 ? CustomColors.lightGreen2 : CustomColors.systemGrey2,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: CustomColors.systemWhite,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '지난 달',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 15,
                                  color: CustomColors.secondaryBlack,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${_lastMonthStart == null ? '' : DateFormat('MM월 dd일').format(_lastMonthStart!)} ~ ${_lastMonthEnd == null ? '' : DateFormat('MM월 dd일, yyyy').format(_lastMonthEnd!)}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                              color: CustomColors.secondaryBlack,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 27),
                  height: 1,
                  color: const Color(0xFFE5E5EA),
                ),
                Material(
                  color: CustomColors.systemWhite,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_isChecked == 2) {
                          _selectEndDate = null;
                          _selectStartDate = null;
                        }

                        _isChecked = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 27, right: 27),
                      height: 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_isChecked == 2) {
                                      _selectEndDate = null;
                                      _selectStartDate = null;
                                    }

                                    _isChecked = 1;
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _isChecked == 1 ? CustomColors.lightGreen2 : CustomColors.systemGrey2,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: CustomColors.systemWhite,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '지난 분기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 15,
                                  color: CustomColors.secondaryBlack,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${_lastQuarterStart == null ? '' : DateFormat('MM월 dd일').format(_lastQuarterStart!)} ~ ${_lastQuarterEnd == null ? '' : DateFormat('MM월 dd일, yyyy').format(_lastQuarterEnd!)}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                              color: CustomColors.secondaryBlack,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 27),
                  height: 1,
                  color: const Color(0xFFE5E5EA),
                ),
                Material(
                  color: CustomColors.systemWhite,
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _isChecked = 2;
                      });

                      final datepicker = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                  primary: CustomColors.lightGreen2,
                                  onPrimary: CustomColors.lightGreen,
                                  secondary: CustomColors.lightGreen),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: CustomColors.lightGreen2,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (datepicker == null) {
                        setState(() {
                          _isChecked = 0;
                        });
                      }

                      setState(() {
                        _selectStartDate = datepicker!.start;
                        _selectEndDate = datepicker.end;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 27, right: 27),
                      height: 76,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isChecked = 2;
                                  });

                                  final datepicker = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                              primary: CustomColors.lightGreen2,
                                              onPrimary: CustomColors.lightGreen,
                                              secondary: CustomColors.lightGreen),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: CustomColors.lightGreen2,
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (datepicker == null) {
                                    setState(() {
                                      _isChecked = 0;
                                    });
                                  }

                                  setState(() {
                                    _selectStartDate = datepicker!.start;
                                    _selectEndDate = datepicker.end;
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _isChecked == 2 ? CustomColors.lightGreen2 : CustomColors.systemGrey2,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: CustomColors.systemWhite,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '지정 범위',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 15,
                                  color: CustomColors.secondaryBlack,
                                ),
                              )
                            ],
                          ),
                          Text(
                            _selectStartDate == null || _selectEndDate == null
                                ? ''
                                : '${DateFormat('MM월 dd일').format(_selectStartDate!)} ~ ${DateFormat('MM월 dd일, yyyy').format(_selectEndDate!)}',
                            style: const TextStyle(
                              fontFamily: 'Pretendard',
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
            Material(
                color: CustomColors.lightGreen2,
                borderRadius: BorderRadius.circular(13),
                child: InkWell(
                  onTap: () {
                    switch (_isChecked) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExportBiometricPage(
                              start: DateFormat('yyyy-MM-dd').format(_lastMonthStart!),
                              end: DateFormat('yyyy-MM-dd').format(_lastMonthEnd!),
                            ),
                          ),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExportBiometricPage(
                              start: DateFormat('yyyy-MM-dd').format(_lastQuarterStart!),
                              end: DateFormat('yyyy-MM-dd').format(_lastQuarterEnd!),
                            ),
                          ),
                        );
                        break;
                      case 2:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExportBiometricPage(
                              start: DateFormat('yyyy-MM-dd').format(_selectEndDate!),
                              end: DateFormat('yyyy-MM-dd').format(_selectEndDate!),
                            ),
                          ),
                        );
                        break;
                    }
                  },
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    width: deviceWidth - 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    alignment: Alignment.center,
                    height: 60,
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        color: CustomColors.systemWhite,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
