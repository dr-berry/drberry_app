import 'package:drberry_app/color/color.dart';
import 'package:flutter/material.dart';

class PersonalInfomationPage extends StatelessWidget {
  const PersonalInfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: const Color(0xFFF9F9F9),
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
          "개인정보 약관",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: CustomColors.secondaryBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFF9F9F9),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  ' 회사는 본 서비스 제공을 위해 반드시 필요한 최소한의 개인정보를 수집하며 다음의 목적으로 보유하고 활용합니다. 이 외 서비스 이용과정에서 별도 동의를 통해 추가정보 수집이 있을 수 있습니다.',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "[개인정보 수집 항목]\n1. 이름, 2. 생년월일, 3. 성별, 4. 키, 5. 몸무게",
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "[수집 목적]\n"
                  "  1. 서비스 개선 등\n"
                  "  - 기존 서비스의 개선 및 신규 서비스 개발\n"
                  "  - 서비스 이용에 대한 분석 및 통계\n"
                  "  2. 서비스 제공\n"
                  "  - 맞춤형 콘텐츠 및 추천 기능의 제공\n"
                  "  - 계정 연동 서비스 제공\n"
                  "  - 프로모션을 위한 푸쉬 메시지 전송 등",
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  '[개인정보의 보유 및 이용 기간]\n'
                  '  원칙적으로, 회사는 서비스 탈퇴 등 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는경우, 회사는 아래와 같이 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  '[개인정보의 파기 절차 및 방법]\n'
                  '  개인정보 파기절차 및 방법은 다음과 같습니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  '  1. 파기절차\n'
                  '  이용자의 개인정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간참조) 일정 기간 저장된 후 파기됩니다. 별도 DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  '  2. 파기방법\n'
                  '  전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '* 동의 거부에 따른 불이익의 내용 안내\n'
                  '서비스 제공을 위해서 반드시 필요한 최소한의 개인정보이므로 동의를 해 주셔야 서비스를 이용하실 수 있습니다.',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 15,
                    color: CustomColors.systemBlack,
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
