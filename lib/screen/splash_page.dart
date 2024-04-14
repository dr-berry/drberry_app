import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/splash/write_code_sheet.dart';
import 'package:drberry_app/screen/ble_n_wifi_link_page.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/phone_authentication_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../server/server.dart';

class SplashPage extends StatefulWidget {
  final String? type;

  const SplashPage({
    super.key,
    required this.type,
  });

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

  void checkSignUp(String deviceName) async {
    if (widget.type == "reconnect") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BleNWifiLinkPage(
            code: deviceName,
            type: widget.type,
          ),
        ),
      );
      return;
    }
    print("device Name :: $deviceName");
    await server.checkSignUp(deviceName).then((value) async {
      print(value.data);
      print(bool.parse(value.data));
      if (bool.parse(value.data) && widget.type != 'reconnect') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneAuthenticatoinPage(code: deviceName),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BleNWifiLinkPage(
              code: deviceName,
              type: widget.type,
            ),
          ),
          (route) => false,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

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
    if (barcode != null) {
      controller?.pauseCamera();

      print(barcode!.code!);

      try {
        final deviceName = jsonDecode(barcode!.code!)['name'];
        print(deviceName);
        if (deviceName == null) {
          Future.delayed(Duration.zero, () {
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
          });
        } else {
          checkSignUp(deviceName);
        }
      } catch (e) {
        Future.delayed(Duration.zero, () {
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
        });
      }
    }

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
              return WriteCodeSheet(type: widget.type);
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
            Positioned(
              top: deviceHeight * 0.6,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {},
                      child: SvgPicture.asset("assets/QR.svg"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: const Text(
                        "패드의 부착된",
                        style: TextStyle(
                            fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                      ),
                    ),
                    const Text(
                      "QR코드를 인식해 주세요.",
                      style: TextStyle(
                          fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            if (widget.type == 'reconnect')
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.xmark,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (route) => false,
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
