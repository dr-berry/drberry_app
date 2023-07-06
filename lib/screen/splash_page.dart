import 'package:dio/dio.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
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
                  cutOutSize: deviceWidth * 0.7),
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
                top: deviceHeight * 0.5,
                left: 0,
                right: 0,
                child: buildResult()),
          ],
        )));
  }

  Widget buildResult() {
    if (barcode != null) {
      controller?.pauseCamera();

      Future.microtask(() {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SignUpPage(
        //               deviceCode: barcode!.code.toString(),
        //             )),
        //     (route) => false);

        server.checkSignUp(barcode!.code.toString()).then((value) async {
          print(value.data);
          if (bool.parse(value.data)) {
            await server
                .login(barcode!.code.toString(), "deviceTokenTest")
                .then((res) async {
              print(res.data);
              if (res.statusCode == 201) {
                final tokenResponse = TokenResponse.fromJson(res.data);
                print(
                    "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
                await storage.write(
                    key: "accessToken", value: tokenResponse.accessToken);
                await storage.write(
                    key: "refreshToken", value: tokenResponse.refreshToken);
                await storage.write(
                    key: "expiredAt",
                    value: tokenResponse.expiredAt.toString());

                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));
              }
            }).catchError((err) => print(err));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpPage(
                          deviceCode: barcode!.code.toString(),
                        )),
                (route) => false);
          }
        }).catchError((err) {
          print(err);
        });
        controller?.resumeCamera();
      });
    }

    return Center(
        child: Column(
      children: [
        GestureDetector(
          onTap: () async {
            String code = "12394123912412";
            await server.login(code, "deviceTokenTest").then((res) async {
              print(res.data);
              if (res.statusCode == 201) {
                final tokenResponse = TokenResponse.fromJson(res.data);
                print(
                    "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
                await storage.write(
                    key: "accessToken", value: tokenResponse.accessToken);
                await storage.write(
                    key: "refreshToken", value: tokenResponse.refreshToken);
                await storage.write(
                    key: "expiredAt",
                    value: tokenResponse.expiredAt.toString());

                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainPage()));
              }
            }).catchError((err) => print(err));
          },
          child: SvgPicture.asset("assets/QR.svg"),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          child: const Text(
            "패드의 부착된",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        const Text(
          "QR코드를 인식해 주세요.",
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white),
        )
      ],
    ));
  }
}
