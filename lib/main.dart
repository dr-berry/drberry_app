import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/screen/weke_alarm_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:drberry_app/provider/calendar_page_provider.dart';
import 'package:drberry_app/provider/home_page_provider.dart';
import 'package:drberry_app/provider/main_page_provider.dart';
import 'package:drberry_app/provider/sign_up_provider.dart';
import 'package:drberry_app/screen/main_page_widget.dart';
import 'package:drberry_app/screen/permission_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message: ${message.messageId}');
  VolumeController().setVolume(1);
  var now = DateTime.now();
  final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: now,
      assetAudioPath: 'assets/alarm-clock-going-off.mp3',
      loopAudio: true,
      fadeDuration: 5,
      vibrate: true,
      notificationTitle: 'This time to sleep',
      notificationBody: '지금 잘시간이에요! 수면음원을 재생합니다!',
      enableNotificationOnKill: true,
      stopOnNotificationOpen: false);

  await Alarm.set(alarmSettings: alarmSettings);

  // final file = await getAssetFile('assets/ocean waves.mp3');
  // final track = Track(trackPath: file.path);

  // await audioPlayer.startPlayerFromTrack(track);

  // double volume = 0.0;
  // Timer.periodic(const Duration(milliseconds: 500), (timer) {
  //   volume += 0.1;
  //   audioPlayer.setVolume(volume);

  //   if (volume >= 0.3) {
  //     timer.cancel();
  //   }
  // });

  // Future.delayed(const Duration(minutes: 1), () {
  //   stopBackgroundAudio();
  // });
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
bool isFlutterLocalNotificationsInitialized = false;
AndroidNotificationChannel? channel;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
  );

  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/launcher_icon');

  var initializationSettingsIos = const DarwinInitializationSettings();

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIos,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      payload: jsonEncode(message.data), //필수
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/launcher_icon',
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  await Alarm.setNotificationOnAppKillContent("앱을 끄면 수면 음원 재생이 안되요! ㅠㅠ", "수면/기상 음원을 듣고싶다면 앱을 켜주세요!");
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // await audioPlayer.openAudioSession();

  const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));
  if (!prefs.containsKey("installed")) {
    await storage.deleteAll();
    prefs.setBool("installed", true);
  }
  print("firebase settings");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, sound: true);

  await initializeDateFormatting('ko_KR', null);

  final accessToken = await storage.read(key: "accessToken");
  final refreshToken = await storage.read(key: "refreshToken");
  final expiredAt = await storage.read(key: "expiredAt");

  final cameraStatus = await Permission.camera.status;
  final bluetoothStatus = await Permission.bluetooth.status;

  var isRinging = false;

  Alarm.getAlarms().forEach((element) async {
    isRinging = await Alarm.isRinging(element.id);
  });

  print(isRinging);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => MainPageProvider()),
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => CalendarPageProvider())
    ],
    child: MyApp(
      initialRoute: isRinging
          ? "/wake_alarm_page"
          : accessToken != null && refreshToken != null && expiredAt != null
              ? "/home"
              : cameraStatus.isGranted && bluetoothStatus.isGranted
                  ? "/login"
                  : "/permission",
    ),
  ));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late List<AlarmSettings> alarms;

  static StreamSubscription? streamSubscription;
  var logger = Logger(printer: PrettyPrinter());

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    print('알람이 울렸다!');
    final pref = await SharedPreferences.getInstance();
    // VolumeController().setVolume(1);
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState!.pushNamed("/wake_alarm_page", arguments: alarmSettings);
    }
    loadAlarms();
  }

  @override
  void initState() {
    super.initState();
    print("init state");
    WidgetsBinding.instance.addObserver(this);
    loadAlarms();
    print('알람설정중');
    streamSubscription ??= Alarm.ringStream.stream.listen((alarmSettings) => navigateToRingScreen(alarmSettings));
    FirebaseMessaging.onMessage.listen((message) async {
      var now = DateTime.now();
      final alarmSettings = AlarmSettings(
          id: 42,
          dateTime: now,
          assetAudioPath: 'assets/alarm-clock-going-off.mp3',
          loopAudio: true,
          fadeDuration: 5,
          vibrate: true,
          notificationTitle: 'This time to sleep',
          notificationBody: '지금 잘시간이에요! 수면음원을 재생합니다!',
          enableNotificationOnKill: true,
          stopOnNotificationOpen: false);

      await Alarm.set(alarmSettings: alarmSettings);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: widget.initialRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const SplashPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const MainPage());
          case '/permission':
            return MaterialPageRoute(builder: (context) => const PermissionPage());
          case "/wake_alarm_page":
            return MaterialPageRoute(
                builder: (context) => WakeAlarmPage(alarmSettings: settings.arguments! as AlarmSettings));
        }
        return MaterialPageRoute(builder: (context) => const SplashPage());
      },
      // routes: {
      //   "/login": (context) => const SplashPage(),
      //   "/home": (context) => const MainPage(),
      //   "/permission": (context) => const PermissionPage(),
      //   "/wake_alarm_page":
      // },
    );
  }
}
