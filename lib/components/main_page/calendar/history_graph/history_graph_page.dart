import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/history_graph/graph_container.dart';
import 'package:drberry_app/components/main_page/calendar/history_graph/weekly_graph_container.dart';
import 'package:flutter/material.dart';

import '../../../../data/Data.dart';

class HistoryGraphPage extends StatefulWidget {
  final ValueNotifier<int> graphController;
  final History history;
  final History weekHistory;
  final History monthHistory;

  const HistoryGraphPage({
    super.key,
    required this.graphController,
    required this.history,
    required this.weekHistory,
    required this.monthHistory,
  });

  @override
  State<HistoryGraphPage> createState() => _HistoryGraphPageState();
}

class _HistoryGraphPageState extends State<HistoryGraphPage> {
  String type = 'Day';

  @override
  void initState() {
    super.initState();
    print("=======HISTORY======");
    for (var i in widget.history.labels) {
      print(i.date);
    }
    print("=======HISTORY======");
    switch (widget.graphController.value) {
      case 0:
        setState(() {
          type = 'Day';
        });
        break;
      case 1:
        setState(() {
          type = 'Month';
        });
        break;
      case 2:
        setState(() {
          type = 'Month';
        });
        break;
    }
  }

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
                      type = 'Day';
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
                          color: CustomColors.secondaryBlack,
                        ),
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
                      type = 'Year';
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
                      print("=============asdfasdfasdfasdf=============");
                      print(widget.history.labels);
                      print("=============asdfasdfasdfasdf=============");
                      return GraphContainer(
                        history: widget.history,
                        type: 'Day',
                      );
                    case 1:
                      return WeeklyGraphContainer(weekHistory: widget.weekHistory);
                    case 2:
                      return GraphContainer(
                        history: widget.monthHistory,
                        type: 'Year',
                      );
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
