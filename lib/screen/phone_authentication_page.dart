import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/sign_up_page.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PhoneAuthenticatoinPage extends StatefulWidget {
  final String code;

  const PhoneAuthenticatoinPage({
    super.key,
    required this.code,
  });

  @override
  State<PhoneAuthenticatoinPage> createState() => _PhoneAuthenticatoinPageState();
}

class _PhoneAuthenticatoinPageState extends State<PhoneAuthenticatoinPage> {
  Server server = Server();
  bool _success = false;
  bool _codeSent = false;
  String _verificationId = "";
  bool _isLoading = false;
  bool _isTimeout = false;

  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();

  final controller = TextEditingController();
  final codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  checkSignUp() async {
    server.checkSignUpWithPhone(widget.code, "+82${controller.text.substring(1)}").then((value) async {
      print(value.data);
      if (bool.parse(value.data)) {
        final token = await FirebaseMessaging.instance.getToken();
        await server.login(widget.code, token ?? "none_device_token").then((res) async {
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
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
              (route) => false,
            );
          }
        }).catchError(
          (err) => print(err),
        );
      } else {
        server.setConnectDeviceWifi(widget.code).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(
                deviceCode: widget.code,
                phoneNumber: "+82${controller.text.substring(1)}",
              ),
            ),
            (route) => false,
          );
        }).catchError((err) {
          print(err);
          showPlatformDialog(
            context: context,
            builder: (context) => BasicDialogAlert(
              title: const Text(
                '일시적 서버 오류',
                style: TextStyle(fontFamily: "Pretendard"),
              ),
              content: const Text(
                '서버 문제로 디바이스 가입이 실패했습니다. 다시 시도해주세요.',
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
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFf9f9f9),
          appBar: AppBar(
            backgroundColor: const Color(0xFFf9f9f9),
            leading: IconButton(
              icon: const Icon(
                CupertinoIcons.back,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashPage(
                      type: "",
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 42),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "휴대폰 본인인증",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Pretendard",
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        focusNode: _phoneFocus,
                        controller: controller,
                        onChanged: (value) async {
                          print(value);
                          if (controller.text.length == 11) {
                            setState(() {
                              _isLoading = true;
                            });
                            final phoneNumber = "+82${controller.text.substring(1)}";

                            final auth = FirebaseAuth.instance;

                            await auth.verifyPhoneNumber(
                              timeout: const Duration(minutes: 3),
                              phoneNumber: phoneNumber,
                              verificationCompleted: (PhoneAuthCredential credential) async {
                                await auth.signInWithCredential(credential).then((_) {});
                              },
                              verificationFailed: (FirebaseAuthException error) {
                                print("==========ERROR==========");
                                print(error);
                                print(error.code);
                                print(error.message);
                                print("==========ERROR==========");
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              codeSent: (verificationId, forceResendingToken) async {
                                setState(() {
                                  _isLoading = false;
                                });
                                print(verificationId);
                                print(forceResendingToken);
                                String smsCode = codeController.text;
                                setState(() {
                                  _codeSent = true;
                                  _verificationId = verificationId;
                                });
                              },
                              codeAutoRetrievalTimeout: (verificationId) {
                                setState(() {
                                  _isTimeout = true;
                                });
                                showPlatformDialog(
                                  context: context,
                                  builder: (context) => BasicDialogAlert(
                                    title: const Text(
                                      '인증시간 만료',
                                      style: TextStyle(fontFamily: "Pretendard"),
                                    ),
                                    content: const Text(
                                      '인증코드를 재전송하고 인증해주세요.',
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
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                                print("timeout");
                              },
                            );
                          } else {
                            // setState(() {
                            //   _codeSent = false;
                            // });
                          }
                        },
                        onTapOutside: (value) {
                          _phoneFocus.unfocus();
                        },
                        enabled: !_codeSent,
                        cursorColor: Colors.black,
                        cursorHeight: 17,
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          prefixText: "+82",
                          counterText: "",
                          prefixStyle: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: CustomColors.lightGreen2,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          hintText: "예) 01012341234",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          hintStyle: TextStyle(
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color(0xFFAEAEB2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_codeSent)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _codeFocus,
                                controller: codeController,
                                onChanged: (value) {
                                  if (value.length == 6) {
                                    setState(() {
                                      _success = true;
                                    });
                                  }
                                },
                                onTapOutside: (value) {
                                  _codeFocus.unfocus();
                                },
                                cursorColor: Colors.black,
                                cursorHeight: 17,
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Color(0xFFe5e5ea)),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  hintText: "인증번호 입력",
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  hintStyle: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    color: Color(0xFFAEAEB2),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Material(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  final auth = FirebaseAuth.instance;
                                  setState(() {
                                    _isLoading = true;
                                    _isTimeout = false;
                                    // controller.text = "";
                                    codeController.text = "";
                                  });
                                  _codeFocus.unfocus();

                                  final phoneNumber = "+82${controller.text.substring(1)}";

                                  await auth.verifyPhoneNumber(
                                    timeout: const Duration(minutes: 3),
                                    phoneNumber: phoneNumber,
                                    verificationCompleted: (PhoneAuthCredential credential) async {
                                      await auth.signInWithCredential(credential).then((_) {});
                                    },
                                    verificationFailed: (FirebaseAuthException error) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      print("==========ERROR==========");
                                      print(error);
                                      print("==========ERROR==========");
                                    },
                                    codeSent: (verificationId, forceResendingToken) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      print(verificationId);
                                      print(forceResendingToken);
                                      String smsCode = codeController.text;
                                      setState(() {
                                        _codeSent = true;
                                        _verificationId = verificationId;
                                      });
                                    },
                                    codeAutoRetrievalTimeout: (verificationId) {
                                      setState(() {
                                        _isTimeout = false;
                                      });
                                      showPlatformDialog(
                                        context: context,
                                        builder: (context) => BasicDialogAlert(
                                          title: const Text(
                                            '인증시간 만료',
                                            style: TextStyle(fontFamily: "Pretendard"),
                                          ),
                                          content: const Text(
                                            '인증코드를 재전송하고 인증해주세요.',
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
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                      print("timeout");
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  height: 38,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFF8E8E93),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "인증코드 재전송",
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8E8E93),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _success
                        ? SizedBox(
                            width: deviceWidth - 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: CustomColors.lightGreen,
                                  elevation: 0,
                                  shape:
                                      const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                  backgroundColor: CustomColors.lightGreen2,
                                  padding: const EdgeInsets.symmetric(vertical: 19)),
                              onPressed: () async {
                                if (_isTimeout) {
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: const Text(
                                        '인증시간 만료',
                                        style: TextStyle(fontFamily: "Pretendard"),
                                      ),
                                      content: const Text(
                                        '인증코드를 재전송하고 인증해주세요.',
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
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                                final auth = FirebaseAuth.instance;

                                final credential = PhoneAuthProvider.credential(
                                  verificationId: _verificationId,
                                  smsCode: codeController.text,
                                );

                                final userCredential = await auth.signInWithCredential(credential).catchError((err) {
                                  print(err);
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: const Text(
                                        '인증 에러',
                                        style: TextStyle(fontFamily: "Pretendard"),
                                      ),
                                      content: Text(
                                        '인증에 실패했습니다. $err',
                                        style: const TextStyle(fontFamily: "Pretnedard"),
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
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                  return err;
                                });
                                print(userCredential.user?.phoneNumber);
                                checkSignUp();
                              },
                              child: const Text(
                                "다음",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Pretendard",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: deviceWidth - 44,
                            child: Container(
                              width: deviceWidth - 44,
                              padding: const EdgeInsets.symmetric(vertical: 19),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFe5e5ea), borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: const Text(
                                "다음",
                                style: TextStyle(
                                  fontFamily: "Prentendard",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Color(0xFFaeaeb2),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withAlpha(80),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: CustomColors.lightGreen2,
                    strokeWidth: 2,
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
