import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/history_graph/graph_container.dart';
import 'package:drberry_app/custom/custom_chart/arc_chart.dart';
import 'package:drberry_app/custom/custom_chart/history_wave_chart.dart';
import 'package:flutter/material.dart';

class HistoryGraphPage extends StatefulWidget {
  final ValueNotifier<int> graphController;

  const HistoryGraphPage({super.key, required this.graphController});

  @override
  State<HistoryGraphPage> createState() => _HistoryGraphPageState();
}

class _HistoryGraphPageState extends State<HistoryGraphPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ValueListenableBuilder(
        valueListenable: widget.graphController,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 115),
              Container(
                padding: const EdgeInsets.only(top: 26, bottom: 28),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {
                      widget.graphController.value = 0;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: value == 0 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: const Text(
                        "주",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.secondaryBlack),
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                  GestureDetector(
                    onTap: () {
                      widget.graphController.value = 1;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: value == 1 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: const Text(
                        "월",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.secondaryBlack),
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                  GestureDetector(
                    onTap: () {
                      widget.graphController.value = 2;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: value == 2 ? const Color(0xFFE5E5EA) : const Color(0xFFF9F9F9)),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: const Text(
                        "년",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "WorkSans",
                            fontWeight: FontWeight.w400,
                            color: CustomColors.secondaryBlack),
                      ),
                    ),
                  )
                ]),
              ),
              ValueListenableBuilder(
                valueListenable: widget.graphController,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      return const GraphContainer();
                    case 1:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case 2:
                      return const GraphContainer();
                    default:
                      return const SizedBox.expand(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
