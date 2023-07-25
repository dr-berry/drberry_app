import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/splash/write_code_sheet.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/screen/ble_n_wifi_link_page.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../server/server.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final qrKey = GlobalKey();
  final server = Server();
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.instance.getAPNSToken().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.lightGreen2,
          padding: const EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 2),
        ),
        onPressed: () {
          print("test");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const WriteCodeSheet();
            },
          );
        },
        child: const Text(
          '직접입력',
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: CustomColors.systemWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.black,
                  borderLength: 18,
                  borderWidth: 6,
                  cutOutBottomOffset: deviceHeight * 0.15,
                  cutOutSize: deviceWidth * 0.6),
              onQRViewCreated: (p0) {
                controller = p0;

                controller?.scannedDataStream.listen((event) async {
                  setState(() {
                    barcode = event;
                  });
                });
              },
            ),
            Positioned(top: deviceHeight * 0.6, left: 0, right: 0, child: buildResult()),
          ],
        ),
      ),
    );
  }

  Widget buildResult() {
    if (barcode != null) {
      controller?.pauseCamera();

      print(barcode!.code!);

      try {
        final deviceName = jsonDecode(barcode!.code!)['name'];
        print(deviceName);
        if (deviceName == null) {
          showPlatformDialog(
            context: context,
            builder: (context) => BasicDialogAlert(
              title: const Text(
                '잘못된 QR코드 입니다.',
                style: TextStyle(fontFamily: "Pretendard"),
              ),
              content: const Text(
                '구매하신 디바이스의 제공된 QR코드를 인식시켜 주세요.',
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
                    controller?.resumeCamera();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        } else {
          Future.delayed(Duration.zero, () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BleNWifiLinkPage(
                  code: deviceName,
                ),
              ),
              (route) => true,
            );
          });
        }
      } catch (e) {
        print(e);

        // showPlatformDialog(
        //   context: context,
        //   builder: (context) => BasicDialogAlert(
        //     title: const Text(
        //       '잘못된 QR코드 입니다.',
        //       style: TextStyle(fontFamily: "Pretendard"),
        //     ),
        //     content: const Text(
        //       '구매하신 디바이스의 제공된 QR코드를 인식시켜 주세요.',
        //       style: TextStyle(fontFamily: "Pretnedard"),
        //     ),
        //     actions: [
        //       BasicDialogAction(
        //         title: const Text(
        //           '확인',
        //           style: TextStyle(
        //             fontFamily: "Pretendard",
        //             color: CustomColors.blue,
        //           ),
        //         ),
        //         onPressed: () {
        //           controller?.resumeCamera();
        //           Navigator.pop(context);
        //         },
        //       )
        //     ],
        //   ),
        // );
      }
    }

    return Center(
        child: Column(
      children: [
        GestureDetector(
          onTap: () async {
            // String code = "SDMM_EFEFEF";
            // // Navigator.pushAndRemoveUntil(
            // //     context,
            // //     MaterialPageRoute(builder: (context) => const SignUpPage(deviceCode: "asdfasdfuashdfjksduf")),
            // //     (route) => false);
            // final deviceToken = await FirebaseMessaging.instance.getToken();
            // print(deviceToken);
            // await server.login(code, deviceToken ?? "deviceTokenTest").then((res) async {
            //   print(res.data);
            //   if (res.statusCode == 201) {
            //     final tokenResponse = TokenResponse.fromJson(res.data);
            //     print(
            //         "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
            //     await storage.write(key: "accessToken", value: tokenResponse.accessToken);
            //     await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
            //     await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());

            //     // ignore: use_build_context_synchronously
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
            //   }
            // }).catchError((err) => print(err));

            // stopBackgroundAudio();

            // await playBackgroundAudio();
          },
          child: SvgPicture.asset("assets/QR.svg"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: const Text(
            "패드의 부착된",
            style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
          ),
        ),
        const Text(
          "QR코드를 인식해 주세요.",
          style: TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
        )
      ],
    ));
  }
}
