import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ko_KR', null);
  const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  final accessToken = await storage.read(key: "accessToken");
  final refreshToken = await storage.read(key: "refreshToken");
  final expiredAt = await storage.read(key: "expiredAt");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => MainPageProvider()),
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => CalendarPageProvider())
    ],
    child: MyApp(
      initialRoute:
          accessToken != null && refreshToken != null && expiredAt != null
              ? "/home"
              : "/login",
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        "/login": (context) => const SplashPage(),
        "/home": (context) => const MainPage()
      },
    );
  }
}
