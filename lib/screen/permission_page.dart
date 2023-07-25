import 'package:audioplayers/audioplayers.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/screen/permission_again_request.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  Future<void> requestPermissions() async {
    final cameraState = await Permission.camera.request();
    final bluetoothState = await Permission.bluetooth.request();
    // final setting = await FirebaseMessaging.instance.requestPermission();
    setupFlutterNotifications();
    if (cameraState.isDenied ||
        bluetoothState.isDenied ||
        bluetoothState.isPermanentlyDenied ||
        cameraState.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PermissionAgainRequestPage(
              permission: RequiredPermission(
                cameraPermission: cameraState.isDenied || cameraState.isPermanentlyDenied,
                bluetoothPermision: cameraState.isDenied || bluetoothState.isPermanentlyDenied,
                notificationPermission: false,
              ),
            ),
          ),
          (route) => false);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.systemWhite,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: CustomColors.systemWhite,
      ),
      body: SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 78.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 16),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "닥터베리에서 제공하는 ",
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 22.sp,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '필수 권한',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 22.sp,
                                  color: CustomColors.lightGreen2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "을\n확인해 주세요.",
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 22.sp,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 53.h),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 54.w,
                            height: 54.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(54.w / 2),
                              color: const Color(0xFFF9F9F9),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.camera_alt),
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '카메라',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 17.sp,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'QR코드로 닥터베리 패드를 간편하게\n등록하실 수 있습니다.',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 13.sp,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 31.h),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 54.w,
                            height: 54.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(54.w / 2),
                              color: const Color(0xFFF9F9F9),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/bell.fill.svg'),
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '알림',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 17.sp,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '수면 및 기상 알람 이용에 필요한\n알림을 받으실 수 있습니다.',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 13.sp,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 31.h),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 54.w,
                            height: 54.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(54.w / 2),
                              color: const Color(0xFFF9F9F9),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/radio.svg'),
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '블루투스 / 와이파이',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 17.sp,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '패드 연동으로 측정된 수면 데이터를\n받으실 수 있습니다.',
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 13.sp,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Material(
                      color: CustomColors.lightGreen2,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () async {
                          await requestPermissions();
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Text(
                            '확인했어요',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              color: CustomColors.systemWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
