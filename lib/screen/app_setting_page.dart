import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/screen/env_setting_page.dart';
import 'package:drberry_app/screen/personal_information_page.dart';
import 'package:drberry_app/screen/service_usage_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  final server = Server();

  @override
  void initState() {
    super.initState();
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
          "설정",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: CustomColors.secondaryBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: deviceWidth - 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.systemWhite,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EnvSettingPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: deviceWidth - 32,
                          height: 69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/settingfill.svg'),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '환경설정',
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 16,
                                      color: CustomColors.secondaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth - 64,
                      height: 1,
                      color: const Color(0xFFE5E5EA),
                    ),
                    Material(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalInfomationPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: deviceWidth - 32,
                          height: 69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/profill.svg'),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '개인정보 약관',
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 16,
                                      color: CustomColors.secondaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth - 64,
                      height: 1,
                      color: const Color(0xFFE5E5EA),
                    ),
                    Material(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ServiceUsagePage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: deviceWidth - 32,
                          height: 69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/textfill.svg'),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '서비스 약관',
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 16,
                                      color: CustomColors.secondaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth - 64,
                      height: 1,
                      color: const Color(0xFFE5E5EA),
                    ),
                    Material(
                      color: CustomColors.systemWhite,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: deviceWidth - 32,
                          height: 69,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset('assets/company.svg'),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '회사 정보',
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 16,
                                      color: CustomColors.secondaryBlack,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, top: 9),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '앱 버전 1.0',
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
        ),
      ),
    );
  }
}
