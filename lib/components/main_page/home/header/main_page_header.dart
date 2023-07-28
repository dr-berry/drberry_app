import 'package:alarm/alarm.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/screen/permission_again_request.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import 'package:shared_preferences/shared_preferences.dart';

class MainPageHeader extends StatefulWidget {
  final BoardDateTimeController controller;
  final DateTime today;
  final void Function(DateTime time) setToday;

  const MainPageHeader({
    super.key,
    required this.controller,
    required this.today,
    required this.setToday,
  });

  @override
  State<MainPageHeader> createState() => _MainPageHeaderState();
}

class _MainPageHeaderState extends State<MainPageHeader> {
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  final server = Server();

  @override
  void initState() {
    super.initState();
  }

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
                  onPressed: () async {
                    Alarm.getAlarms().forEach((element) async {
                      await Alarm.stop(element.id);
                      print(element.id);
                      if (await Alarm.isRinging(element.id)) {
                        await Alarm.stop(element.id);
                      }
                    });
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
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 11.9,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      backgroundColor: CustomColors.systemWhite,
                      foregroundColor: CustomColors.systemWhite,
                      surfaceTintColor: CustomColors.systemWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                  onPressed: () async {
                    print(await Permission.notification.status);
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    // pref.clear();
                    if (await Permission.notification.isGranted) {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WakeAlarmSettingPage(),
                        ),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermissionAgainRequestPage(
                            permission: RequiredPermission(
                              bluetoothPermision: false,
                              notificationPermission: true,
                              cameraPermission: false,
                            ),
                          ),
                        ),
                      );
                    }
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
                      void setToday(DateTime val) {
                        widget.setToday(val);
                      }

                      void setMainToday(DateTime val) {
                        context.read<MainPageProvider>().setToday(val);
                      }

                      picker.DatePicker.showDatePicker(
                        context,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2100, 12, 31),
                        locale: picker.LocaleType.ko,
                        theme: const picker.DatePickerTheme(
                          doneStyle: TextStyle(
                            fontFamily: "Pretendard",
                            color: CustomColors.lightGreen2,
                          ),
                          cancelStyle: TextStyle(
                            fontFamily: "Pretendard",
                            color: CustomColors.red,
                          ),
                          itemStyle: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 15,
                          ),
                        ),
                        currentTime: context.read<MainPageProvider>().savedToday,
                        onCancel: () {},
                        onConfirm: (val) async {
                          setToday(val);
                          setMainToday(val);
                          await server.getMainPage(DateFormat("yyyy-MM-dd").format(val), -1).then((res) {
                            // print(res.data);
                            try {
                              MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson(res.data);

                              context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
                            } catch (e) {
                              MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson({
                                "userBiometricData": null,
                                "components": [],
                                "isMultipleData": false,
                              });

                              context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
                              print(e);
                            }
                          }).catchError((err) {
                            MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson({
                              "userBiometricData": null,
                              "components": [],
                              "isMultipleData": false,
                            });

                            context.read<HomePageProvider>().setMainPageData(mainPageBiometricData);
                            print(err);
                          });
                        },
                      );
                    },
                    icon: SvgPicture.asset('assets/calendar.svg', width: 19, height: 19),
                    label: Text(
                      DateFormat("MM월 dd일 E요일", "ko_KR").format(context.read<MainPageProvider>().savedToday),
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
