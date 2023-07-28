import 'dart:io';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionAgainRequestPage extends StatefulWidget {
  final RequiredPermission permission;

  const PermissionAgainRequestPage({super.key, required this.permission});

  @override
  State<PermissionAgainRequestPage> createState() => _PermissionAgainRequestPageState();
}

class _PermissionAgainRequestPageState extends State<PermissionAgainRequestPage> {
  Future<void> getPermission() async {
    showPlatformDialog(
      context: context,
      builder: (context) {
        return BasicDialogAlert(
          title: const Text(
            '설정 페이지로 이동됩니다.',
            style: TextStyle(fontFamily: "Pretendard"),
          ),
          content: const Text(
            '앱의 권한이 변경되면 앱이 종료될 수 있습니다.\n앱이 종료되면 다시 접속해 주세요',
            style: TextStyle(fontFamily: "Pretnedard"),
          ),
          actions: [
            BasicDialogAction(
              title: const Text(
                '확인',
                style: TextStyle(
                  fontFamily: "Pretendard",
                  color: CustomColors.blue,
                ),
              ),
              onPressed: () async {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                await openAppSettings();
                if (widget.permission.notificationPermission) {
                  final notificationGrant = await Permission.notification.isGranted;
                  print(notificationGrant);

                  if (notificationGrant) {
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // ignore: use_build_context_synchronously
                    showPlatformDialog(
                      context: context,
                      builder: (context) => BasicDialogAlert(
                        title: const Text(
                          '권한 설정 미완료',
                          style: TextStyle(fontFamily: "Pretendard"),
                        ),
                        content: const Text(
                          '앱의 권한설정이 완료되지 않았어요. 다시 시도해주세요',
                          style: TextStyle(fontFamily: "Pretnedard"),
                        ),
                        actions: [
                          BasicDialogAction(
                            title: const Text(
                              '확인',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                color: CustomColors.blue,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  final cameraGrant = await Permission.camera.isGranted;
                  final bleGrant = await Permission.bluetooth.isGranted;

                  if (cameraGrant && bleGrant) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashPage(),
                      ),
                      (route) => false,
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    showPlatformDialog(
                      context: context,
                      builder: (context) => BasicDialogAlert(
                        title: const Text(
                          '권한 설정 미완료',
                          style: TextStyle(fontFamily: "Pretendard"),
                        ),
                        content: const Text(
                          '앱의 권한설정이 완료되지 않았어요. 다시 시도해주세요',
                          style: TextStyle(fontFamily: "Pretnedard"),
                        ),
                        actions: [
                          BasicDialogAction(
                            title: const Text(
                              '확인',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                color: CustomColors.blue,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.systemWhite,
      body: ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 200.h),
                    widget.permission.cameraPermission
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(42, -15),
                                    child: const Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Text(
                                        '!',
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 35,
                                          color: CustomColors.systemBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.camera_alt, size: 45.w),
                                ],
                              ),
                              SizedBox(height: 36.h),
                              Text(
                                '카메라 권한이 없으면 \n디바이스 등록과 로그인을\n 진행할 수 없어요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        : Container(),
                    widget.permission.bluetoothPermision
                        ? Column(
                            children: [
                              widget.permission.cameraPermission ? SizedBox(height: 40.h) : Container(),
                              Stack(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(42, -15),
                                    child: const Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Text(
                                        '!',
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 35,
                                          color: CustomColors.systemBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/radio.svg',
                                    width: 45.w,
                                    height: 45.w,
                                  ),
                                ],
                              ),
                              SizedBox(height: 36.h),
                              Text(
                                '블루투스 권한이 없으면 \n디바이스 등록과 로그인을\n 진행할 수 없어요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        : Container(),
                    widget.permission.notificationPermission
                        ? Column(
                            children: [
                              widget.permission.bluetoothPermision || widget.permission.cameraPermission
                                  ? SizedBox(height: 40.h)
                                  : Container(),
                              Stack(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(42, -15),
                                    child: const Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Text(
                                        '!',
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 35,
                                          color: CustomColors.systemBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/bell.fill.svg',
                                    width: 45.w,
                                    height: 45.w,
                                  ),
                                ],
                              ),
                              SizedBox(height: 36.h),
                              Text(
                                '알림을 허용하지 않으면 알람을\n받으실 수 없어요',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.systemBlack,
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ],
                ),
                Positioned(
                  bottom: widget.permission.notificationPermission ? 72.5 : 0,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Material(
                      color: CustomColors.lightGreen2,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          getPermission();
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Text(
                            '설정 바로가기',
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
                ),
                widget.permission.notificationPermission
                    ? Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: SafeArea(
                          child: Material(
                            color: CustomColors.systemWhite,
                            borderRadius: BorderRadius.circular(13),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(13),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(
                                    color: CustomColors.lightGreen2,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Text(
                                  '나중에',
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontSize: 17,
                                    color: CustomColors.lightGreen2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
