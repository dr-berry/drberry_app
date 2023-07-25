import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/screen/permission_page.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainPageHeader extends StatefulWidget {
  final BoardDateTimeController controller;
  final DateTime today;

  const MainPageHeader({super.key, required this.controller, required this.today});

  @override
  State<MainPageHeader> createState() => _MainPageHeaderState();
}

class _MainPageHeaderState extends State<MainPageHeader> {
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  final server = Server();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: deviceWidth,
      height: 50,
      margin: const EdgeInsets.all(19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 11.9, offset: Offset(0, 0))
                ]),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: CustomColors.systemWhite,
                      foregroundColor: CustomColors.systemWhite,
                      surfaceTintColor: CustomColors.systemWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PermissionPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/moon.svg',
                    width: 29,
                    height: 29,
                    semanticsLabel: "Image",
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 11.9, offset: Offset(0, 0))
                ]),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: CustomColors.systemWhite,
                      foregroundColor: CustomColors.systemWhite,
                      surfaceTintColor: CustomColors.systemWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WakeAlarmSettingPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/sun.svg',
                    width: 29,
                    height: 29,
                    semanticsLabel: "Image",
                  ),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 28,
                child: TextButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                        overlayColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return CustomColors.systemGrey5;
                          }
                          return null;
                        })),
                    onPressed: () async {
                      widget.controller.open(DateTimePickerType.date, widget.today);
                    },
                    icon: SvgPicture.asset('assets/calendar.svg', width: 19, height: 19),
                    label: Text(
                      DateFormat("MM월 dd일 E요일", "ko_KR").format(widget.today),
                      style: const TextStyle(
                          fontSize: 16,
                          color: CustomColors.systemBlack,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
