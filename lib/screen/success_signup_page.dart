import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:flutter/material.dart';

class SuccessSignupPage extends StatefulWidget {
  const SuccessSignupPage({super.key});

  @override
  State<SuccessSignupPage> createState() => _SuccessSignupPageState();
}

class _SuccessSignupPageState extends State<SuccessSignupPage> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color(0xFFf9f9f9),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(backgroundColor: const Color(0xFFf9f9f9)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox.expand(
                child: Container(
                  color: const Color(0xFFf9f9f9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: deviceHeight * 0.26),
                      Image.asset("assets/WelcomeIcon.png",
                          width: 135, height: 135),
                      const Text("반갑습니다!",
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.systemBlack)),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text("더 나은 수면을 위해\n도움을 드릴게요.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8E8E93))),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 17,
                  left: 22,
                  right: 22,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: CustomColors.lightGreen,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        backgroundColor: CustomColors.lightGreen2,
                        padding: const EdgeInsets.symmetric(vertical: 19)),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainPage(),
                          ),
                          (route) => false);
                    },
                    child: const Text("홈으로",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Pretendard",
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ))
            ],
          ),
        ));
  }
}
