import 'dart:async';
import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/wifi_list/wifi_list_item.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/proto/constants.pb.dart';
import 'package:drberry_app/proto/sec0.pb.dart';
import 'package:drberry_app/proto/wifi_config.pb.dart';
import 'package:drberry_app/proto/wifi_constants.pb.dart';
import 'package:drberry_app/proto/wifi_scan.pb.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/phone_authentication_page.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
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
  final FlutterBluePlus ble = FlutterBluePlus();
  BluetoothDevice? espDevice;
  List<BluetoothService> services = [];
  List<WiFiScanResult> wifis = [];

  bool isTurnOn = true;
  bool isBleLinking = true;
  bool isBleError = false;
  bool isWifiLinking = true;
  bool isWifiError = false;
  bool isFoundDevice = false;
  bool isStartProvisioning = false;
  bool isFinishWifiLink = false;
  List<int> arr = [];
  BluetoothCharacteristic? wifiScanCharacteristic;
  BluetoothCharacteristic? wifiConfigCharacteristic;

  Future<void> scanWiFi(int maxLength) async {
    int maxIndex = (maxLength / 4).floor();
    print(maxIndex);

    List<WiFiScanResult> respList = [];

    for (var i = 0; i < maxIndex; i++) {
      try {
        if (wifiScanCharacteristic != null) {
          print(i * 4);
          final respScanResultData = WiFiScanPayload()
            ..msg = WiFiScanMsgType.TypeCmdScanResult
            ..cmdScanResult = (CmdScanResult()
              ..startIndex = i * 4
              ..count = 4);

          final binaryRespScanResult = respScanResultData.writeToBuffer();
          await wifiScanCharacteristic?.write(binaryRespScanResult, timeout: 10000);

          final event = await wifiScanCharacteristic?.read();
          if (event != null && event.isNotEmpty) {
            final payload = WiFiScanPayload.fromBuffer(event);
            // print("scan : $payload");

            final respScanResult = payload.respScanResult;

            final resp = respScanResult;
            if (resp.entries.isNotEmpty) {
              // print(resp.entries);
              // print("finished wifi list");
              for (var a in resp.entries) {
                print(
                  "${utf8.decode(a.ssid)} - ${a.channel} - ${a.rssi} - ${a.bssid} - ${a.auth}",
                );

                final index = respList.indexWhere((element) => utf8.decode(a.ssid) == utf8.decode(element.ssid));
                if (index == -1) {
                  respList.add(a);
                }
              }
            }
          }
        }
      } catch (e) {
        setState(() {
          isBleError = false;
          isWifiError = true;
        });
        print("------err------");
        print(e);
        print("------err------");
        espDevice?.disconnect();
      }
    }

    setState(() {
      wifis = respList;
      isWifiLinking = false;
    });
  }

  Future<void> searchWifi() async {
    if (!isTurnOn) {
      Future.delayed(Duration.zero, () {
        setState(() {
          isBleLinking = true;
          isWifiLinking = true;
          isBleError = true;
          isWifiError = false;
          services.clear();
          wifis.clear();
        });

        showPlatformDialog(
          context: context,
          builder: (context) => BasicDialogAlert(
            title: const Text(
              '블루투스가 꺼졌습니다.',
              style: TextStyle(fontFamily: "Pretendard"),
            ),
            content: const Text(
              '블루투스를 켜주세요!',
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
      });
    }

    setState(() {
      isWifiLinking = true;
      wifis.clear();
    });

    var wifiListCharUUID = "021AFF50-0382-4AEA-BFF4-6B3F1C5ADFB4";

    // BluetoothCharacteristic? wifiScanCharacteristic;

    if (wifiScanCharacteristic == null) {
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toUpperCase() == wifiListCharUUID) {
            setState(() {
              wifiScanCharacteristic = characteristic;
            });
          }
          print(characteristic.uuid);
        }
      }
    }

    //scanWifiList
    // final wifiStatusPaylaod = WiFiScanPayload()
    //   ..msg = WiFiScanMsgType.TypeCmdScanStatus
    //   ..cmdScanStatus = (CmdScanStatus());

    // final binaryStatus = wifiStatusPaylaod.writeToBuffer();
    // await wifiScanCharacteristic!.write(binaryStatus, timeout: 10000);

    final wifiScanPayload = WiFiScanPayload()
      ..msg = WiFiScanMsgType.TypeCmdScanStart
      ..status = Status.Success
      ..cmdScanStart = (CmdScanStart()
        ..blocking = true
        ..passive = false
        ..groupChannels = 0
        ..periodMs = 120);
    List<int> data = wifiScanPayload.writeToBuffer();
    await wifiScanCharacteristic!.write(data, timeout: 10000);
  }

  Future<void> startProvisioning() async {
    if (!isTurnOn) {
      Future.delayed(Duration.zero, () {
        setState(() {
          isBleLinking = true;
          isWifiLinking = true;
          isBleError = true;
          isWifiError = false;
          services.clear();
          wifis.clear();
          services.clear();
        });

        showPlatformDialog(
          context: context,
          builder: (context) => BasicDialogAlert(
            title: const Text(
              '블루투스가 꺼졌습니다.',
              style: TextStyle(fontFamily: "Pretendard"),
            ),
            content: const Text(
              '블루투스를 켜주세요!',
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
      });
    }

    setState(() {
      isWifiError = false;
      isBleError = false;
      isWifiLinking = true;
      isBleLinking = true;
    });

    // Scanning for ESP32 device

    final devices = FlutterBluePlus.connectedDevices;

    print(devices);
    for (var element in devices) {
      print(element.name);
      if (element.name == widget.code) {
        espDevice = element;
      }
    }

    if (espDevice == null) {
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 4),
      );

      FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
        for (ScanResult result in results) {
          if (result.device.name.contains("SDMM_")) print(result.device.name);
          if (result.device.name == widget.code) {
            print("${widget.code}, ${result.device.name}");
            espDevice = result.device;
            // print(result.device.name);
          }
        }
      });
    }

    Future.delayed(const Duration(seconds: 4), () async {
      print("===========================");
      print(espDevice?.name);
      print("===========================");

      if (espDevice == null) {
        setState(() {
          isBleLinking = true;
          isWifiLinking = true;
          isBleError = true;
          isWifiError = false;
          services.clear();
          wifis.clear();
        });
        print('ESP32 device not found');
        return;
      }

      espDevice?.connectionState.listen((event) {
        print(event.name);
      });

      // Connect to the device
      await FlutterBluePlus.stopScan();
      await espDevice?.connect().then((res) {
        print("test");
        setState(() {
          isBleLinking = false;
        });
      }).catchError((err) {
        print(err);
      });
      try {
        // Discover services
        services.addAll((await espDevice?.discoverServices())!);

        // Assuming service and characteristic UUIDs
        // You need to replace them with the actual UUIDs
        var sendSecurityLevelUUID = "021AFF51-0382-4AEA-BFF4-6B3F1C5ADFB4";
        var wifiListCharUUID = "021AFF50-0382-4AEA-BFF4-6B3F1C5ADFB4";
        var wifiPasswordCharUUID = "021AFF52-0382-4AEA-BFF4-6B3F1C5ADFB4";
        // var serviceUUID = "021A9004-0382-4AEA-BFF4-6B3F1C5ADFB4";

        BluetoothCharacteristic? securityCharacteristic;
        // BluetoothCharacteristic? wifiScanCharacteristic;
        BluetoothCharacteristic? serviceCharacteristic;

        for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toUpperCase() == wifiListCharUUID) {
              print("wifi scan char");
              print(characteristic.uuid.toString().toUpperCase());
              wifiScanCharacteristic = characteristic;
            }

            if (characteristic.uuid.toString().toUpperCase() == sendSecurityLevelUUID) {
              print("security char");
              print(characteristic.uuid.toString().toUpperCase());
              securityCharacteristic = characteristic;
            }

            if (characteristic.uuid.toString().toUpperCase() == wifiPasswordCharUUID) {
              print("wifi password char");
              print(characteristic.uuid.toString().toUpperCase());
              wifiConfigCharacteristic = characteristic;
            }
          }
        }

        //sec0 세팅
        S0SessionCmd s0sessionCmd = S0SessionCmd();
        Sec0Payload sec0payload = Sec0Payload()
          ..msg = Sec0MsgType.S0_Session_Command
          ..sc = s0sessionCmd;

        print("security settings");

        List<int> binarySec = sec0payload.writeToBuffer();
        await securityCharacteristic?.write(binarySec, timeout: 10000);

        if (espDevice?.connectionState == BluetoothConnectionState.disconnected) {
          setState(() {
            isBleError = true;
            isWifiError = true;
          });
        }

        print("scan wifi setting");
        //scanWifiList
        final wifiScanData = WiFiScanPayload()
          ..msg = WiFiScanMsgType.TypeCmdScanStart
          ..cmdScanStart = (CmdScanStart()
            ..blocking = true
            ..groupChannels = 0
            ..passive = true
            ..periodMs = 120);
        final binaryWifiScanData = wifiScanData.writeToBuffer();
        await wifiScanCharacteristic?.write(binaryWifiScanData, timeout: 10000);

        final resp = await wifiScanCharacteristic?.read(timeout: 10000);
        if (resp != null && resp.isNotEmpty) {
          final payload = WiFiScanPayload.fromBuffer(resp);

          print(payload.respScanStart);
        }

        print("get wifi status");
        final cmdScanStatusData = WiFiScanPayload()
          ..msg = WiFiScanMsgType.TypeCmdScanStatus
          ..cmdScanStatus = (CmdScanStatus());

        final binaryScanStatusData = cmdScanStatusData.writeToBuffer();
        await wifiScanCharacteristic?.write(binaryScanStatusData, timeout: 10000);

        final event = await wifiScanCharacteristic?.read();

        int maxLength = 0;

        if (event != null && event.isNotEmpty) {
          final payload = WiFiScanPayload.fromBuffer(event);

          print(payload.respScanStatus.resultCount);
          maxLength = payload.respScanStatus.resultCount;

          if (payload.respScanStatus.scanFinished) {
            setState(() {
              isWifiLinking = true;
            });
          }

          print("resp-scan-result : maxLength: $maxLength, scanFinished: ${payload.respScanStatus.scanFinished}");
        }

        await scanWiFi(maxLength);
      } catch (e) {
        setState(() {
          isBleError = true;
          isWifiError = true;
        });
      }
    });
  }

  linkWifi(WiFiScanResult wifi, String password) async {
    if (wifiConfigCharacteristic != null) {
      print("wifi set config");
      final wifiConfiSetData = WiFiConfigPayload()
        ..msg = WiFiConfigMsgType.TypeCmdSetConfig
        ..cmdSetConfig = (CmdSetConfig()
          ..ssid = wifi.ssid
          ..passphrase = utf8.encode(password));

      final binaryWifiSetCongif = wifiConfiSetData.writeToBuffer();
      await wifiConfigCharacteristic?.write(binaryWifiSetCongif, timeout: 10000);

      final event = await wifiConfigCharacteristic?.read();
      if (event != null && event.isNotEmpty) {
        final wifiConfigResp = WiFiConfigPayload.fromBuffer(event);

        print(wifiConfigResp.respSetConfig);
      }

      print("apply wifi config");
      final wifiApplyData = WiFiConfigPayload()
        ..msg = WiFiConfigMsgType.TypeCmdApplyConfig
        ..cmdApplyConfig = (CmdApplyConfig());

      final binaryWifiApply = wifiApplyData.writeToBuffer();
      await wifiConfigCharacteristic?.write(binaryWifiApply, timeout: 10000);

      final respWifiConfig = await wifiConfigCharacteristic?.read();
      if (respWifiConfig != null && respWifiConfig.isNotEmpty) {
        final wifiApplyPaylaod = WiFiConfigPayload.fromBuffer(respWifiConfig);

        print(wifiApplyPaylaod.respApplyConfig.status);

        if (wifiApplyPaylaod.respApplyConfig.status == Status.Success) {
          setState(() {
            isFinishWifiLink = true;
            isWifiLinking = false;
          });
        }
      }

      final wifiGetStatus = WiFiConfigPayload()
        ..msg = WiFiConfigMsgType.TypeCmdGetStatus
        ..cmdGetStatus = (CmdGetStatus());

      final binaryWifiGetStatus = wifiGetStatus.writeToBuffer();
      await wifiConfigCharacteristic?.write(binaryWifiGetStatus, timeout: 10000);

      final respGetStatus = await wifiConfigCharacteristic?.read();
      if (respGetStatus != null && respGetStatus.isNotEmpty) {
        final respGetStatusPayload = WiFiConfigPayload.fromBuffer(respGetStatus);

        print("wifi get status { connected: ${respGetStatusPayload.respGetStatus.connected} }");
      }
    }
    espDevice?.disconnect();
  }

  @override
  void initState() {
    super.initState();

    FlutterBluePlus.adapterState.listen(
      (event) {
        setState(() {
          isTurnOn = event == BluetoothAdapterState.on;
        });
        if (event == BluetoothAdapterState.off) {
          setState(() {
            isBleLinking = true;
            isWifiLinking = true;
            isBleError = true;
            isWifiError = false;
            services.clear();
            wifis.clear();
          });
          showPlatformDialog(
            context: context,
            builder: (context) => BasicDialogAlert(
              title: const Text(
                '블루투스가 꺼졌습니다.',
                style: TextStyle(fontFamily: "Pretendard"),
              ),
              content: const Text(
                '블루투스를 켜주세요!',
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColors.systemWhite,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: CustomColors.systemWhite,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 78),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: isStartProvisioning
                                    ? (isBleError || isWifiError)
                                        ? isBleError
                                            ? '블루투스 연결에 실패했습니다.'
                                            : '와이파이 연결에 실패했습니다.'
                                        : isBleLinking
                                            ? "Bluetooth에 연결중 입니다."
                                            : isWifiLinking
                                                ? "Wifi를 찾고 있어요"
                                                : isFinishWifiLink
                                                    ? "WiFi가 연결되었습니다."
                                                    : "Wifi를 연결해 주세요"
                                    : "[${widget.code}]디바이스에\n연결하시겠습니까?",
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 22,
                                  color: CustomColors.systemBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            espDevice = null;
                            isStartProvisioning = true;
                            isBleLinking = true;
                            isWifiLinking = true;
                            isBleError = true;
                            isWifiError = false;
                            services.clear();
                            wifis.clear();
                            services.clear();
                          });
                          startProvisioning();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 44),
                isStartProvisioning
                    ? wifis.isEmpty
                        ? (!isBleError && !isWifiError)
                            ? Column(
                                children: [
                                  SizedBox(height: deviceHeight / 4.5),
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: CustomColors.lightGreen2,
                                      strokeWidth: 2,
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(height: deviceHeight / 4.5),
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          espDevice = null;
                                          isStartProvisioning = true;
                                          isBleLinking = true;
                                          isWifiLinking = true;
                                          isBleError = true;
                                          isWifiError = false;
                                          services.clear();
                                          wifis.clear();
                                          services.clear();
                                        });
                                        startProvisioning();
                                      },
                                      icon: const Icon(Icons.refresh_rounded),
                                    ),
                                  ),
                                  const Text(
                                    '디바이스의 버튼을 3초이상 클릭해보세요.',
                                    style: TextStyle(
                                        fontFamily: "Pretendard",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: CustomColors.systemGrey2),
                                  )
                                ],
                              )
                        : !isFinishWifiLink
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                height: deviceHeight - 254 - 60,
                                child: ListView.builder(
                                  itemCount: wifis.length,
                                  itemBuilder: (context, index) {
                                    return WifiListItem(
                                      wifis: wifis,
                                      index: index,
                                      linkWifi: linkWifi,
                                    );
                                  },
                                ),
                              )
                            : Container()
                    : Container(),
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
                      if (isStartProvisioning) {
                        if (isFinishWifiLink) {
                          // server.checkSignUp(widget.code).then((value) async {
                          //   if (bool.parse(value.data)) {
                          //     final token = await FirebaseMessaging.instance.getToken();
                          //     await server.login(widget.code, token ?? "none_device_token").then((res) async {
                          //       if (res.statusCode == 201) {
                          //         final tokenResponse = TokenResponse.fromJson(res.data);
                          //         print(
                          //             "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
                          //         await storage.write(key: "accessToken", value: tokenResponse.accessToken);
                          //         await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
                          //         await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());

                          //         // ignore: use_build_context_synchronously
                          //         Navigator.pushAndRemoveUntil(
                          //           context,
                          //           MaterialPageRoute(builder: (context) => const MainPage()),
                          //           (route) => false,
                          //         );
                          //       }
                          //     }).catchError(
                          //       (err) => print(err),
                          //     );
                          //   } else {
                          //     server.setConnectDeviceWifi(widget.code).then((value) {
                          //       Navigator.pushAndRemoveUntil(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => SignUpPage(
                          //                   deviceCode: widget.code,
                          //                 )),
                          //         (route) => false,
                          //       );
                          //     }).catchError((err) {
                          //       print(err);
                          //       showPlatformDialog(
                          //         context: context,
                          //         builder: (context) => BasicDialogAlert(
                          //           title: const Text(
                          //             '일시적 서버 오류',
                          //             style: TextStyle(fontFamily: "Pretendard"),
                          //           ),
                          //           content: const Text(
                          //             '서버 문제로 디바이스 가입이 실패했습니다. 다시 시도해주세요.',
                          //             style: TextStyle(fontFamily: "Pretnedard"),
                          //           ),
                          //           actions: [
                          //             BasicDialogAction(
                          //               title: const Text(
                          //                 '확인',
                          //                 style: TextStyle(
                          //                   fontFamily: "Pretendard",
                          //                   color: CustomColors.blue,
                          //                 ),
                          //               ),
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //             )
                          //           ],
                          //         ),
                          //       );
                          //     });
                          //   }
                          // }).catchError((err) {
                          //   print(err);
                          // });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneAuthenticatoinPage(code: widget.code),
                            ),
                          );
                        } else {
                          showPlatformDialog(
                            context: context,
                            builder: (context) => BasicDialogAlert(
                              title: const Text(
                                '와이파이를 연결해주세요.',
                                style: TextStyle(fontFamily: "Pretendard"),
                              ),
                              content: const Text(
                                '디바이스에 와이파이가 연결되어있지 않습니다. 와이파이를 선택후 연결해주세요.',
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
                        setState(() {
                          isStartProvisioning = true;
                          isBleLinking = true;
                          isWifiLinking = true;
                          isBleError = true;
                          isWifiError = false;
                          services.clear();
                          wifis.clear();
                          services.clear();
                        });
                        startProvisioning();
                      }
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
        ),
      ),
    );
  }
}
