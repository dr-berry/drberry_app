import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/Data.dart';

class SelectModalBottomSheet extends StatefulWidget {
  final String selectDate;

  const SelectModalBottomSheet({
    super.key,
    required this.selectDate,
  });

  @override
  State<SelectModalBottomSheet> createState() => _SelectModalBottomSheetState();
}

class _SelectModalBottomSheetState extends State<SelectModalBottomSheet> {
  Server server = Server();

  Future<List<UserSleepDatas>> getSleepDatas() async {
    return server.getUserSleepList(widget.selectDate).then((res) {
      print(res);
      return UserSleepDatas.fromJsonList(res.data);
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 35),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          color: CustomColors.systemWhite,
        ),
        height: deviceHeight * 0.45,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 19, right: 19),
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent;
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  const Text(
                    '데이터 선택',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 17,
                      color: CustomColors.secondaryBlack,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return CustomColors.systemGrey5;
                          }
                          return null;
                        },
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 17,
                        color: CustomColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: FutureBuilder(
                  future: getSleepDatas(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: snapshot.data!
                            .map<Widget>(
                              (e) => Column(
                                children: [
                                  Material(
                                    color: CustomColors.systemWhite,
                                    child: InkWell(
                                      onTap: () async {
                                        // print("================");
                                        // print(e.ubdSeq);
                                        // print("================");
                                        await server.getMainPage(widget.selectDate, e.ubdSeq).then((res) {
                                          try {
                                            MainPageBiometricData mainPageBiometricData =
                                                MainPageBiometricData.fromJson(res.data);

                                            context
                                                .read<HomePageProvider>()
                                                .setMultiPageData(mainPageBiometricData, context);
                                          } catch (event) {
                                            MainPageBiometricData mainPageBiometricData =
                                                MainPageBiometricData.fromJson({
                                              "userBiometricData": null,
                                              "components": [],
                                              "isMultipleData": false,
                                            });

                                            context
                                                .read<HomePageProvider>()
                                                .setMultiPageData(mainPageBiometricData, context);
                                          }
                                        }).catchError((err) {
                                          MainPageBiometricData mainPageBiometricData = MainPageBiometricData.fromJson({
                                            "userBiometricData": null,
                                            "components": [],
                                            "isMultipleData": false,
                                          });

                                          context
                                              .read<HomePageProvider>()
                                              .setMultiPageData(mainPageBiometricData, context);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 58),
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              e.date,
                                              style: const TextStyle(
                                                fontFamily: "Pretendard",
                                                fontSize: 17,
                                                color: CustomColors.systemBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              e.dateRange,
                                              style: const TextStyle(
                                                fontFamily: "Pretendard",
                                                fontSize: 17,
                                                color: CustomColors.systemBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
                                    height: 1,
                                    color: const Color(0xFFE5E5EA),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
