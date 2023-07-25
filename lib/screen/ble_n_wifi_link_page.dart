import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleNWifiLinkPage extends StatefulWidget {
  final String code;

  const BleNWifiLinkPage({super.key, required this.code});

  @override
  State<BleNWifiLinkPage> createState() => _BleNWifiLinkPageState();
}

class _BleNWifiLinkPageState extends State<BleNWifiLinkPage> {
  final server = Server();
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));
  FlutterBluePlus ble = FlutterBluePlus.instance;
  BluetoothDevice? espDevice;
  List<BluetoothService> services = [];

  bool isBleLinking = true;
  bool isBleError = false;
  bool isWifiLinking = true;
  bool isWifiError = false;
  List<int> arr = [];

  Future<void> startProvisioning() async {
    // Scanning for ESP32 device
    await ble.startScan(timeout: const Duration(seconds: 4));

    // You should replace 'ESP32' with your device name
    ble.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.name == widget.code) {
          espDevice = result.device;
          // print(result.device.name);
        }
      }
    });

    if (espDevice == null) {
      setState(() {
        isBleError = true;
      });
      print('ESP32 device not found');
      return;
    }

    // Connect to the device
    await espDevice?.connect().then(
      (value) {
        setState(() {
          isBleLinking = false;
        });
        espDevice?.pair();
      },
    );

    // Discover services
    services.addAll((await espDevice?.discoverServices())!);

    // Assuming service and characteristic UUIDs
    // You need to replace them with the actual UUIDs
    var sendSecurityLevelUUID = "021AFF51-0382-4AEA-BFF4-6B3F1C5ADFB4";
    var wifiListCharUUID = "021AFF50-0382-4AEA-BFF4-6B3F1C5ADFB4";
    var wifiPasswordCharUUID = "0000yyyy-0000-1000-8000-00805f9b34fb";

    BluetoothCharacteristic? securityCharacteristic;
    BluetoothCharacteristic? wifiListCharacteristic;

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString().toUpperCase() == wifiListCharUUID) {
          wifiListCharacteristic = characteristic;
        }

        if (characteristic.uuid.toString().toUpperCase() == sendSecurityLevelUUID) {
          securityCharacteristic = characteristic;
        }
      }
    }

    if (securityCharacteristic != null) {
      await securityCharacteristic.write(<int>[0]);
    }
    // var value = await wifiListCharacteristic?.read();
    // print(utf8.decode(value!));

    await espDevice?.disconnect();
  }

  @override
  void initState() {
    super.initState();
    startProvisioning();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                text: isBleLinking
                                    ? "Bluetooth에 연결중 입니다."
                                    : isWifiLinking
                                        ? "Wifi를 찾고 있어요"
                                        : "Wifi를 연결해 주세요",
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
                    SizedBox(height: 212.h),
                    (!isBleError && !isWifiError)
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: () {
                              startProvisioning();
                              setState(() {
                                isBleError = false;
                                isWifiError = false;
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded),
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
                          // Future.microtask(() {
                          //   server.checkSignUp(widget.code).then((value) async {
                          //     if (bool.parse(value.data)) {
                          //       await server.login(widget.code, "deviceTokenTest").then((res) async {
                          //         if (res.statusCode == 201) {
                          //           final tokenResponse = TokenResponse.fromJson(res.data);
                          //           print(
                          //               "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
                          //           await storage.write(key: "accessToken", value: tokenResponse.accessToken);
                          //           await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
                          //           await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());

                          //           // ignore: use_build_context_synchronously
                          //           Navigator.pushAndRemoveUntil(context,
                          //               MaterialPageRoute(builder: (context) => const MainPage()), (route) => false);
                          //         }
                          //       }).catchError((err) => print(err));
                          //     } else {
                          //       Navigator.pushAndRemoveUntil(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => SignUpPage(
                          //                     deviceCode: widget.code,
                          //                   )),
                          //           (route) => false);
                          //     }
                          //   }).catchError((err) {
                          //     print(err);
                          //   });
                          // });
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Text(
                            '확인',
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
