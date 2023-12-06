import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/server/server.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class ExportBiometricPage extends StatefulWidget {
  final String start;
  final String end;

  const ExportBiometricPage({super.key, required this.start, required this.end});

  @override
  State<ExportBiometricPage> createState() => _ExportBiometricPageState();
}

class _ExportBiometricPageState extends State<ExportBiometricPage> {
  Server server = Server();

  Future<String>? exportPath;

  Future<String> export() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = '${dir.path}/${DateFormat('yyyy-MM-dd:HH:mm:ss').format(DateTime.now())}_유저_수면데이터.xlsx';

    print(dir.path);
    print(path);
    print(widget.start);
    print(widget.end);

    await server.exportSleepData(path, widget.start, widget.end);

    return path;
  }

  @override
  void initState() {
    super.initState();
    exportPath = export();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xFFF9F9F9),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: deviceHeight * 0.25,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/export_page.png',
                    width: deviceWidth / 3,
                    height: deviceWidth / 3,
                  ),
                  const Text(
                    '전체 보고서를\n내려받고 있습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Pretendard",
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              left: 22,
              right: 22,
              child: FutureBuilder(
                future: exportPath,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Material(
                      color: CustomColors.hexaColor('#39C270', 0, opacity: 6),
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        alignment: Alignment.center,
                        height: 60,
                        child: LoadingAnimationWidget.waveDots(
                          color: CustomColors.systemWhite,
                          size: 40,
                        ),
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Material(
                      color: CustomColors.hexaColor('#39C270', 0, opacity: 6),
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        alignment: Alignment.center,
                        height: 60,
                        child: LoadingAnimationWidget.waveDots(
                          color: CustomColors.systemWhite,
                          size: 40,
                        ),
                      ),
                    );
                  } else {
                    return Material(
                      color: CustomColors.lightGreen2,
                      borderRadius: BorderRadius.circular(13),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () {
                          Share.shareFiles([snapshot.data!]).then((res) {
                            Navigator.pop(context);
                          }).catchError((err) {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          child: const Text(
                            '공유하기',
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 17,
                              color: CustomColors.systemWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
