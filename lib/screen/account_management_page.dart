import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/account_setting/dialog/change_gender_dialog.dart';
import 'package:drberry_app/components/account_setting/dialog/change_name_dialog.dart';
import 'package:drberry_app/data/data.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';

class AccountManagePage extends StatefulWidget {
  const AccountManagePage({super.key});

  @override
  State<AccountManagePage> createState() => _AccountManagePageState();
}

class _AccountManagePageState extends State<AccountManagePage> {
  final controller = BoardDateTimeController();
  final server = Server();

  String _serverName = "";
  String _serverBirth = "";
  String _serverGender = "";

  Future<AccountSettingData>? _account;

  Future<AccountSettingData> getAccountInfo() {
    final account = server.getAccountInfo().then((res) {
      print(res.data);
      return AccountSettingData.fromJson(res.data);
    });

    return account;
  }

  @override
  void initState() {
    super.initState();
    _account = getAccountInfo();
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
            "계정관리",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: CustomColors.secondaryBlack,
            ),
          ),
        ),
        body: SafeArea(
          child: BoardDateTimeBuilder(
            controller: controller,
            pickerType: DateTimePickerType.time,
            options: const BoardDateTimeOptions(
              backgroundColor: CustomColors.systemGrey6,
              activeColor: CustomColors.lightGreen2,
            ),
            builder: (context) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: FutureBuilder(
                      future: _account,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const SafeArea(
                              child: Column(
                            children: [
                              SizedBox(height: 100),
                              Center(
                                child: CircularProgressIndicator(color: CustomColors.lightGreen2),
                              ),
                            ],
                          ));
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SafeArea(
                              child: Column(
                            children: [
                              SizedBox(height: 100),
                              Center(
                                child: CircularProgressIndicator(color: CustomColors.lightGreen2),
                              ),
                            ],
                          ));
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 22),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "이름",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Pretendard",
                                        color: Color(0xFF8E8E93),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  showBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    // isScrollControlled: true,
                                    // useSafeArea: true,
                                    builder: (context) {
                                      return ChangeNameDialog(
                                        name: _serverName == "" ? snapshot.data!.name : _serverName,
                                        serverName: _serverName,
                                        setServerName: (name) {
                                          setState(() {
                                            _serverName = name;
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: deviceWidth - 32,
                                  height: 60,
                                  padding: const EdgeInsets.only(left: 16, right: 25),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: CustomColors.systemWhite,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xFFE5E5EA),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_serverName == "" ? snapshot.data!.name : _serverName,
                                          style: const TextStyle(
                                            fontFamily: "Pretendard",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.secondaryBlack,
                                          )),
                                      const Text("편집",
                                          style: TextStyle(
                                            fontFamily: "Pretendard",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF8E8E93),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.only(left: 22),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "생년월일",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Pretendard",
                                        color: Color(0xFF8E8E93),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  final format = DateFormat("yyyy.MM.dd");

                                  controller.open(DateTimePickerType.date,
                                      format.parseStrict(_serverBirth == "" ? snapshot.data!.birthday : _serverBirth));
                                },
                                child: Container(
                                  width: deviceWidth - 32,
                                  height: 60,
                                  padding: const EdgeInsets.only(left: 16, right: 25),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: CustomColors.systemWhite,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1, color: const Color(0xFFE5E5EA))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_serverBirth == "" ? snapshot.data!.birthday : _serverBirth,
                                          style: const TextStyle(
                                            fontFamily: "Pretendard",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.secondaryBlack,
                                          )),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.only(left: 22),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "성별",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Pretendard",
                                        color: Color(0xFF8E8E93),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ChangeGenderDialog(
                                        gender: _serverGender == "" ? snapshot.data!.gender : _serverGender,
                                        setServerGender: (gender) {
                                          setState(() {
                                            _serverGender = gender;
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: deviceWidth - 32,
                                  height: 60,
                                  padding: const EdgeInsets.only(left: 16, right: 25),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: CustomColors.systemWhite,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 1, color: const Color(0xFFE5E5EA))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          _serverGender == ""
                                              ? snapshot.data!.gender == "MALE"
                                                  ? "남성"
                                                  : "여성"
                                              : _serverGender == "MALE"
                                                  ? "남성"
                                                  : "여성",
                                          style: const TextStyle(
                                            fontFamily: "Pretendard",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                            color: CustomColors.secondaryBlack,
                                          )),
                                      const Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.only(left: 22),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "가입",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Pretendard",
                                        color: Color(0xFF8E8E93),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: deviceWidth - 32,
                                height: 60,
                                padding: const EdgeInsets.only(left: 16, right: 25),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE5E5EA),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 1, color: const Color(0xFFE5E5EA))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data!.signUpAt,
                                        style: const TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: CustomColors.secondaryBlack,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 91,
                    left: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          child: InkWell(
                              onTap: () async {
                                await server.deleteAccount().then((res) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SplashPage(type: "")),
                                    (route) => true,
                                  );
                                }).catchError((err) {
                                  showPlatformDialog(
                                    context: context,
                                    builder: (context) => BasicDialogAlert(
                                      title: const Text(
                                        "계정삭제 실패",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Pretendard",
                                            fontWeight: FontWeight.w600,
                                            color: CustomColors.systemBlack),
                                      ),
                                      content: Text(
                                        "계정삭제에 실패했습니다. Error: [$err]",
                                        style: const TextStyle(
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
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: Color(0xFFFF4319),
                                ))),
                                child: const Text(
                                  "계정삭제",
                                  style: TextStyle(
                                    color: Color(0xFFFF4319),
                                    fontSize: 16,
                                    fontFamily: "Pretendard",
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 22,
                    right: 22,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: CustomColors.lightGreen,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                          backgroundColor: CustomColors.lightGreen2,
                          padding: const EdgeInsets.symmetric(vertical: 19)),
                      onPressed: () async {
                        await server.updateUser(_serverName, _serverBirth, _serverGender).then((res) {
                          showPlatformDialog(
                            context: context,
                            builder: (context) => BasicDialogAlert(
                              title: const Text(
                                "정보 변경 완료",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.systemBlack),
                              ),
                              content: const Text(
                                "계정 정보 변경이 완료되었습니다.",
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
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        }).catchError((err) {
                          showPlatformDialog(
                            context: context,
                            builder: (context) => BasicDialogAlert(
                              title: const Text(
                                "정보 변경 실패",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.systemBlack),
                              ),
                              content: const Text(
                                "계정 정보 변경이 실패 했습니다. 다시 시도해 주세요.",
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                ),
                              ),
                              actions: [
                                BasicDialogAction(
                                  title: const Text(
                                    "돌아가기",
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      color: Color(0xFFFF4319),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          );
                        });
                      },
                      child: const Text(
                        "저장",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Pretendard",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            onChange: (DateTime date) {
              setState(() {
                _serverBirth = DateFormat("yyyy.MM.dd").format(date);
              });
            },
          ),
        ));
  }
}
