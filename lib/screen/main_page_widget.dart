import 'package:drberry_app/color/color.dart';
import 'package:drberry_app/components/main_page/calendar/calendar_page.dart';
import 'package:drberry_app/components/main_page/home/home_page.dart';
import 'package:drberry_app/components/main_page/profile/profile_page.dart';
import 'package:drberry_app/components/main_page/sleep_pad/sleep_pad_page.dart';
import 'package:drberry_app/main.dart';
import 'package:drberry_app/provider/global_provider.dart';
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/screen/music_bar.dart';
import 'package:drberry_app/screen/music_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final controller = PageController(initialPage: 0);
  Color background = const Color(0xFFF9F9F9);
  final BoxController _controller = BoxController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<GlobalPageProvider>().background,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/home.png")), label: "홈"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/history.png")), label: "히스토리"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/pad.png")), label: "수면패드"),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/profile.png")), label: "프로필")
          ],
          selectedLabelStyle:
              const TextStyle(fontFamily: 'Pretendard', fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black),
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color(0xFFAEAEB2),
          unselectedLabelStyle: const TextStyle(
              fontFamily: 'Pretendard', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xFFAEAEB2)),
          iconSize: 28,
          onTap: (value) {
            print(value);
            context.read<MainPageProvider>().setIndex(value);
            controller.jumpToPage(value);
          },
          currentIndex: context.watch<MainPageProvider>().pageIndx,
          backgroundColor: const Color(0xFFFFFFFF),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: context.watch<GlobalPageProvider>().background,
        ),
      ),
      body: MusicBar(
        controller: _controller,
        oldBackground: background,
        child: SafeArea(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            onPageChanged: (value) {
              print("value $value");
              switch (value) {
                case 0:
                  context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                  setState(() {
                    background = const Color(0xFFF9F9F9);
                  });
                  break;
                case 1:
                  context.read<GlobalPageProvider>().setBackground(const Color(0xFFFFFFFF));
                  setState(() {
                    background = const Color(0xffffffff);
                  });
                  break;
                case 2:
                  context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                  setState(() {
                    background = const Color(0xFFF9F9F9);
                  });
                  break;
                default:
                  context.read<GlobalPageProvider>().setBackground(const Color(0xFFF9F9F9));
                  setState(() {
                    background = const Color(0xFFF9F9F9);
                  });
              }
              context.read<MainPageProvider>().setIndex(value);
            },
            children: [
              const HomePage(),
              CalendarPage(
                deviceWidth: MediaQuery.of(context).size.width,
              ),
              const SleepPadPage(),
              const ProfilePage()
            ],
          ),
        ),
      ),
    );
  }
}
