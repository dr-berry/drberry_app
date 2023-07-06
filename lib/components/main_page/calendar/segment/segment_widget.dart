import 'package:drberry_app/components/main_page/calendar/segment/segment_button.dart';
import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SegmentWidget extends StatefulWidget {
  const SegmentWidget({super.key});

  @override
  State<SegmentWidget> createState() => _SegmentWidgetState();
}

class _SegmentWidgetState extends State<SegmentWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _leftAnimation;
  Animation<double>? _rightAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _leftAnimation =
        Tween(begin: 0.0, end: 98.5).animate(_animationController!);

    _rightAnimation =
        Tween(begin: 98.5, end: 0.0).animate(_animationController!);

    _animationController?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Positioned(
            left: _leftAnimation?.value ?? 0,
            right: _rightAnimation?.value ?? 98.5,
            child: GestureDetector(
              onTap: () {
                final provider = context.read<CalendarPageProvider>();
                if (_animationController?.status == AnimationStatus.completed) {
                  _animationController?.reverse();
                  provider.setIndex(0);
                } else if (_animationController?.status ==
                    AnimationStatus.dismissed) {
                  _animationController?.forward();
                  provider.setIndex(1);
                }
              },
              child: child,
            ),
          );
        },
        child: const CustomSegmentButton());
  }
}
