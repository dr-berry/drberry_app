import 'dart:async';

import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/custom/custom_shape/triangle.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touchable/touchable.dart';

import 'categority_chart.dart';

class CategorityWidget extends StatefulWidget {
  final Size size;
  final double deviceWidth;

  const CategorityWidget({
    super.key,
    required this.size,
    required this.deviceWidth,
  });

  @override
  State<CategorityWidget> createState() => CategorityWidgetState();
}

class CategorityWidgetState extends State<CategorityWidget> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? overlayEntry;

  CategorityWidgetState();

  Timer? timer;

  Size? getSize() {
    if (_key.currentContext != null) {
      final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return null;
  }

  OverlayEntry createOverlayEntry(Offset offset, NosingGraph data, Offset triangleOffset) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy,
        left: offset.dx,
        child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                    width: 120,
                    height: 54,
                    decoration: BoxDecoration(
                        color: CustomColors.systemWhite,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: CustomColors.lightGreen2, width: 2)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.date,
                          style: const TextStyle(fontFamily: 'SF-Pro', fontWeight: FontWeight.w400, fontSize: 11),
                        ),
                        Text(
                          '평균 ${data.avgSnoring.floor()}dB',
                          style: const TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              color: CustomColors.middleGreen,
                              fontSize: 15),
                        )
                      ],
                    )),
                Transform.translate(
                  offset: triangleOffset,
                  child: CustomPaint(painter: Triangle(), size: const Size(20, 15)),
                )
              ],
            )),
      ),
    );
  }

  void removeAllEntries() {
    overlayEntry?.remove();
    overlayEntry = null;
    timer?.cancel();
    timer = null;
  }

  void _showDetailInfo(BuildContext context, LongPressStartDetails details, NosingGraph data, double barWidth,
      Offset localPosition, Offset triangleOffset) {
    removeAllEntries();
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(localPosition);
    overlayEntry = createOverlayEntry(offset, data, triangleOffset);
    Overlay.of(context).insert(overlayEntry!);
    timer = Timer(const Duration(seconds: 3), () => removeAllEntries());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = widget.size;
    final double deviceWidth = widget.deviceWidth;

    return Container(
        key: _key,
        padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
        child: RepaintBoundary(
          child: CanvasTouchDetector(
            gesturesToOverride: const [GestureType.onLongPressStart],
            builder: (context) => CustomPaint(
                painter: CategorityChart(
                    context: context,
                    getSize: getSize,
                    datas: context.read<HomePageProvider>().mainPageBiometricData != null &&
                            context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.read<HomePageProvider>().mainPageBiometricData!.nosingGraph!
                        : [],
                    labels: context.read<HomePageProvider>().mainPageBiometricData != null &&
                            context.read<HomePageProvider>().mainPageBiometricData!.userBiometricData != null
                        ? context.read<HomePageProvider>().mainPageBiometricData!.nosingGraphX!
                        : NosingGraphX(maxTime: "0", minTime: "0"),
                    showDetailInfo: _showDetailInfo,
                    deviceWidth: deviceWidth,
                    removeOverlay: removeAllEntries),
                size: size),
          ),
        ));
  }
}
