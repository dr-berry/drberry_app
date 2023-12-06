import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/signup/fragment/bio_input_fragment.dart';
import 'package:drberry_app/components/signup/fragment/birth_input_fragment.dart';
import 'package:drberry_app/components/signup/fragment/gender_input_fragment.dart';
import 'package:drberry_app/components/signup/fragment/name_input_fragment.dart';
import 'package:drberry_app/custom/custom_chart/animated_progress_bar/linear_progress_bar.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/screen/success_signup_page.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final String deviceCode;

  const SignUpPage({super.key, required this.deviceCode});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final server = Server();
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  int frag = 0;
  String buttonText = "다음";
  double _selectDate = 0.0;

  final controller = PageController(initialPage: 0);

  void datePicker(double selectDate) {
    setState(() {
      _selectDate = selectDate;
    });
  }

  void nextPage() {
    setState(() {
      frag++;
    });
    context.read<SignUpProvider>().setDisabled(false);
    controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void prevPage() {
    setState(() {
      frag--;
    });
    controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xFFf9f9f9),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(backgroundColor: const Color(0xFFf9f9f9)),
        ),
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            datePicker(0.0);
          },
          child: Stack(children: [
            Column(children: [
              Container(
                width: deviceWidth,
                height: 64,
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                color: const Color(0xFFf9f9f9),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Material(
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      highlightColor: CustomColors.systemGrey6,
                      child: Container(
                          width: 50,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: SvgPicture.asset("assets/ArrowToLeft.svg", width: 10, height: 24)),
                      onTap: () {
                        setState(() {
                          buttonText = "다음";
                        });
                        if (frag == 0) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashPage(type: null),
                              ),
                              (route) => false);
                        } else {
                          prevPage();
                        }
                      },
                    ),
                  ),
                ]),
              ),
              Center(
                  child: Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: CustomPaint(
                    painter: LinearProgressBar(
                        backgroundColor: const Color(0xFFF2F2F7),
                        forgroundColor: CustomColors.lightGreen2,
                        progressing: frag),
                    size: Size(deviceWidth - 40, 6)),
              )),
              Expanded(
                child: PageView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const NameInputFragment(),
                    BirthInputFragment(datePicker: datePicker),
                    const GenderInputFragment(),
                    const BioInputFragment()
                  ],
                ),
              )
            ]),
            Positioned(
              bottom: 100,
              child: AnimatedContainer(
                width: deviceWidth,
                height: _selectDate,
                color: Colors.white,
                duration: const Duration(milliseconds: 200),
                child: CupertinoDatePicker(
                  maximumDate: DateTime(2050),
                  minimumDate: DateTime(1900),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) {
                    final provider = context.read<SignUpProvider>();
                    provider.setBirth(
                        "${value.year}.${value.month < 10 ? "0${value.month}" : value.month}.${value.day < 10 ? "0${value.day}" : value.day}");
                    provider.setDisabled(true);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 17,
              left: 22,
              right: 22,
              child: context.watch<SignUpProvider>().disabled
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: CustomColors.lightGreen,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                          backgroundColor: CustomColors.lightGreen2,
                          padding: const EdgeInsets.symmetric(vertical: 19)),
                      onPressed: () async {
                        datePicker(0.0);
                        FocusScope.of(context).unfocus();

                        final provider = context.read<SignUpProvider>();

                        if (frag == 3) {
                          if (provider.name.isNotEmpty &&
                              provider.gender.isNotEmpty &&
                              provider.tall > 0 &&
                              provider.weight > 0 &&
                              provider.birth.isNotEmpty) {
                            final pushAlarm = await Permission.notification.isGranted;
                            await server
                                .signUp(provider.name, widget.deviceCode, provider.gender, provider.tall,
                                    provider.weight, provider.birth, "deviceTokenTest", pushAlarm, pushAlarm)
                                .then((res) async {
                              if (res.statusCode == 201) {
                                final tokenResponse = TokenResponse.fromJson(res.data);
                                await storage.write(key: "accessToken", value: tokenResponse.accessToken);
                                await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
                                await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());

                                final provider = context.read<SignUpProvider>();

                                provider.setBirth("");
                                provider.setDisabled(false);
                                provider.setFrag(0);
                                provider.setGender("");
                                provider.setName("");
                                provider.setTall(0);
                                provider.setWeight(0);

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const SuccessSignupPage()));
                              }
                            }).catchError((err) {
                              print(err.toString());
                            });
                          }
                        }

                        if (frag < 3) {
                          if (frag + 1 == 3) {
                            setState(() {
                              buttonText = "완료";
                            });
                          } else {
                            setState(() {
                              buttonText = "다음";
                            });
                          }
                          nextPage();
                        }
                      },
                      child: Text(buttonText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              fontWeight: FontWeight.w500)),
                    )
                  : SizedBox(
                      width: deviceWidth - 44,
                      child: Container(
                        width: deviceWidth - 44,
                        padding: const EdgeInsets.symmetric(vertical: 19),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xFFe5e5ea), borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                              fontFamily: "Prentendard",
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color(0xFFaeaeb2)),
                        ),
                      )),
            )
          ]),
        )));
  }
}
