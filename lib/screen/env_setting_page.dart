import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class EnvSettingPage extends StatefulWidget {
  const EnvSettingPage({super.key});

  @override
  State<EnvSettingPage> createState() => _EnvSettingPageState();
}

class _EnvSettingPageState extends State<EnvSettingPage> {
  final server = Server();
  final _appPushController = ValueNotifier<bool>(true);
  final _alarmPushController = ValueNotifier<bool>(true);
  final _dataController = ValueNotifier<bool>(true);
  final _activeController = ValueNotifier<bool>(true);

  Future<EnvSettings>? _envSettings;

  Future<EnvSettings> getSettings() async {
    return server.getSettings().then((res) {
      return EnvSettings.fromJson(res.data);
    });
  }

  @override
  void initState() {
    super.initState();

    _envSettings = getSettings();

    _appPushController.addListener(() async {
      print(_appPushController.value);
      await server.updateSettings("APP_PUSH", _appPushController.value);
    });
    _alarmPushController.addListener(() async {
      await server.updateSettings("ALARM_PUSH", _alarmPushController.value);
    });
    _dataController.addListener(() async {
      await server.updateSettings("DATA", _dataController.value);
    });
    _activeController.addListener(() async {
      await server.updateSettings("ACTIVE", _activeController.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
          "환경설정",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: CustomColors.secondaryBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
            child: FutureBuilder(
          future: _envSettings,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              _appPushController.value = snapshot.data!.isAppPush;
              _alarmPushController.value = snapshot.data!.isAlarmPush;
              _dataController.value = snapshot.data!.isData;
              _activeController.value = snapshot.data!.isActive;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: deviceWidth - 32,
                    height: 69,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.systemWhite,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '앱 푸시 알림',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 16,
                                color: CustomColors.secondaryBlack,
                              ),
                            ),
                          ],
                        ),
                        AdvancedSwitch(
                          controller: _appPushController,
                          activeColor: CustomColors.lightGreen2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: deviceWidth - 32,
                    height: 69,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.systemWhite,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '기상/수면 알람 차단',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 16,
                                color: CustomColors.secondaryBlack,
                              ),
                            ),
                          ],
                        ),
                        AdvancedSwitch(
                          controller: _alarmPushController,
                          activeColor: CustomColors.lightGreen2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: deviceWidth - 32,
                    height: 69,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.systemWhite,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '데이터 수집',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 16,
                                color: CustomColors.secondaryBlack,
                              ),
                            ),
                          ],
                        ),
                        UnconstrainedBox(
                          child: AdvancedSwitch(
                            controller: _dataController,
                            activeColor: CustomColors.lightGreen2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 26, top: 9),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '사용자 수면 데이터를 수집합니다.',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: deviceWidth - 32,
                    height: 69,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: CustomColors.systemWhite,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '자동 활성화',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 16,
                                color: CustomColors.secondaryBlack,
                              ),
                            ),
                          ],
                        ),
                        AdvancedSwitch(
                          controller: _activeController,
                          activeColor: CustomColors.lightGreen2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 26, top: 9),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '기기가 정해진 취침 시간에 맞춰 자동으로 활성화됩니다.',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: 13,
                            color: Color(0xFF8E8E93),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        )),
      ),
    );
  }
}
