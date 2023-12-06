import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/proto/wifi_scan.pb.dart';
import 'package:flutter/material.dart';

class WifiPasswordDialog extends StatefulWidget {
  const WifiPasswordDialog({
    super.key,
    required this.wifis,
    required this.index,
    required this.linkWifi,
  });

  final List<WiFiScanResult> wifis;
  final int index;
  final Function(WiFiScanResult wifi, String password) linkWifi;

  @override
  State<WifiPasswordDialog> createState() => _WifiPasswordDialogState();
}

class _WifiPasswordDialogState extends State<WifiPasswordDialog> {
  String password = '';

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        password = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final wifiName = utf8.decode(widget.wifis[widget.index].ssid);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: deviceWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "와이파이 연결",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Pretendard",
              ),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Text(
                  "SSID",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Pretendard",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Container(
              height: 50,
              width: deviceWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: const Color(0xFFF4F4F4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    wifiName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Text(
                  "PASSWORD",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Pretendard",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            TextField(
              cursorColor: Colors.grey,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: "Pretendard",
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF4F4F4),
                hintText: "와이파이의 비밀번호를 입력해주세요",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                  color: CustomColors.systemGrey2,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Material(
              color: password.isEmpty ? Colors.grey : CustomColors.lightGreen2,
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                highlightColor: password.isEmpty ? Colors.grey : null,
                splashColor: password.isEmpty ? Colors.grey : null,
                borderRadius: BorderRadius.circular(13),
                onTap: () async {
                  if (password.isNotEmpty) {
                    print("ssid: ${widget.wifis[widget.index].ssid} password : $password");
                    await widget.linkWifi(widget.wifis[widget.index], password).then((res) {
                      Navigator.pop(context);
                    }).catchError((err) {
                      print(err);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Container(
                  height: 50,
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
          ],
        ),
      ),
    );
  }
}
