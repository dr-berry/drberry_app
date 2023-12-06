import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/screen/ble_n_wifi_link_page.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WriteCodeSheet extends StatefulWidget {
  final String? type;

  const WriteCodeSheet({super.key, required this.type});

  @override
  State<WriteCodeSheet> createState() => _WriteCodeSheetState();
}

class _WriteCodeSheetState extends State<WriteCodeSheet> {
  final _controller = TextEditingController();
  String _code = "";
  double keyboard = 0.0;

  Server server = Server();
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom + deviceHeight * 0.4,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 40),
        decoration: const BoxDecoration(
          color: CustomColors.systemWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  '코드 직접입력',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 16,
                    color: CustomColors.systemBlack,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                      width: deviceWidth - 32,
                      margin: const EdgeInsets.only(top: 4),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (value) {
                            setState(() {
                              if (value) {
                                keyboard = MediaQuery.of(context).viewInsets.bottom;
                              } else {
                                keyboard = 0.0;
                              }
                            });
                          },
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              setState(() {
                                _code = value;
                              });
                            },
                            cursorColor: Colors.black,
                            cursorHeight: 17,
                            style: const TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Color(0xFFF2F2F7)),
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              hintText: "디바이스 고유 코드를 입력해주세요.",
                              filled: true,
                              fillColor: Color(0xFFF2F2F7),
                              contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 22),
                              hintStyle: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: CustomColors.systemGrey2,
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            Material(
              color: CustomColors.lightGreen2,
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () async {
                  if (_code == "") {
                    showPlatformDialog(
                      context: context,
                      builder: (context) => BasicDialogAlert(
                        title: const Text(
                          "로그인 실패",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.systemBlack),
                        ),
                        content: const Text(
                          "빈코드는 입력할 수 없습니다. 기기 코드를 정확하게 입력해주세요.",
                          style: TextStyle(
                            fontFamily: "Pretendard",
                          ),
                        ),
                        actions: [
                          BasicDialogAction(
                            title: const Text(
                              "완료",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                color: CustomColors.lightGreen2,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                    return;
                  }

                  if (!_code.startsWith("SDMM_")) {
                    showPlatformDialog(
                      context: context,
                      builder: (context) => BasicDialogAlert(
                        title: const Text(
                          "로그인 실패",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.systemBlack),
                        ),
                        content: const Text(
                          "기기 코드를 정확하게 입력해주세요.",
                          style: TextStyle(
                            fontFamily: "Pretendard",
                          ),
                        ),
                        actions: [
                          BasicDialogAction(
                            title: const Text(
                              "완료",
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                color: CustomColors.lightGreen2,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                    return;
                  }

                  if (widget.type == 'reconnect') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BleNWifiLinkPage(
                          code: _code,
                        ),
                      ),
                    );
                    return;
                  }
                  print(_code);
                  await server.checkSignUp(_code).then((value) async {
                    print(value.data);
                    print(bool.parse(value.data));
                    if (bool.parse(value.data)) {
                      final token = await FirebaseMessaging.instance.getToken();
                      print("deviceToken : $token");
                      await server.login(_code, token ?? "none_device_token").then((res) async {
                        if (res.statusCode == 201) {
                          final tokenResponse = TokenResponse.fromJson(res.data);
                          print(
                              "a : ${tokenResponse.accessToken}, r : ${tokenResponse.refreshToken}, e : ${tokenResponse.expiredAt}");
                          await storage.write(key: "accessToken", value: tokenResponse.accessToken);
                          await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
                          await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());

                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainPage()),
                            (route) => false,
                          );
                        }
                      }).catchError((err) => print(err));
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BleNWifiLinkPage(
                            code: _code,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  }).catchError((err) {
                    print(err);
                  });
                  // Navigator.pop(context);
                },
                child: Container(
                  width: deviceWidth - 32,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Center(
                    child: Text(
                      "입력",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w500,
                        color: CustomColors.systemWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
