import 'dart:convert';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/wifi_list/dialog/wifi_password_dialog.dart';
import 'package:drberry_app/proto/wifi_scan.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WifiListItem extends StatefulWidget {
  const WifiListItem({
    super.key,
    required this.wifis,
    required this.index,
    required this.linkWifi,
  });

  final List<WiFiScanResult> wifis;
  final int index;
  final Function(WiFiScanResult wifi, String password) linkWifi;

  @override
  State<WifiListItem> createState() => _WifiListItemState();
}

class _WifiListItemState extends State<WifiListItem> {
  @override
  Widget build(BuildContext context) {
    final wifiName = utf8.decode(widget.wifis[widget.index].ssid);
    print(widget.wifis[widget.index].ssid);
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF9F9F9),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return WifiPasswordDialog(
                  wifis: widget.wifis,
                  index: widget.index,
                  linkWifi: widget.linkWifi,
                );
              },
            );
          },
          child: Container(
            width: deviceWidth - 26,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: CustomColors.secondaryBlack,
                  size: 28,
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: Text(
                    wifiName,
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: CustomColors.systemBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
