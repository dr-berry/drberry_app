import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:drberry_app/provider/global_provider.dart';
import 'package:drberry_app/screen/music_sheet.dart';
import 'package:drberry_app/screen/sleep_alarm_page.dart';
import 'package:drberry_app/screen/splash_page.dart';
import 'package:drberry_app/screen/weke_alarm_page.dart';
import 'package:drberry_app/screen/wkae_alarm_setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
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

List<Map<String, String>> wakeMusicList = [
  {
    "imageAssets": "assets/fire.png",
    "musicAssets": "assets/crackling fireplace.mp3",
    "blur": "LEFX0DE20M^j03XS\$*ni0g\$%~BIV",
    "title": "Crackling Fireplace",
  },
  {
    "imageAssets": "assets/rain.png",
    "musicAssets": "assets/gentle rain.mp3",
    "title": "Gentle Rain",
  },
  {
    "imageAssets": "assets/melody.png",
    "musicAssets": "assets/meditation melody.mp3",
    "title": "Meditation Melody",
  },
  {
    "imageAssets": "assets/pink.png",
    "musicAssets": "assets/pink noise.mp3",
    "title": "Pink Noise",
  },
  {
    "imageAssets": "assets/ocean.png",
    "musicAssets": "assets/ocean waves.mp3",
    "title": "Ocean Waves",
  },
  {
    "imageAssets": "assets/thunder.png",
    "musicAssets": "assets/thunder rain.mp3",
    "title": "Thunder Rain",
  },
  {
    "imageAssets": "assets/white.jpg",
    "musicAssets": "assets/white noise.mp3",
    "title": "White Noise",
  },
  {
    "imageAssets": "assets/digital.jpg",
    "musicAssets": "assets/alarm-clock-going-off.mp3",
    "title": "Digital",
  },
  {
    "imageAssets": "assets/beep.png",
    "musicAssets": "assets/beep.mp3",
    "title": "Beep",
  },
  {
    "imageAssets": "assets/car.jpg",
    "musicAssets": "assets/car.mp3",
    "title": "Car Siren",
  },
  {
    "imageAssets": "assets/chiptone.jpg",
    "musicAssets": "assets/chiptune.mp3",
    "title": "Chiptune",
  },
  {
    "imageAssets": "assets/cyber.jpg",
    "musicAssets": "assets/cyber-alarm.mp3",
    "title": "Cyber",
  },
  {
    "imageAssets": "assets/old_clock.jpg",
    "musicAssets": "assets/old_alarm.mp3",
    "title": "Old",
  },
  {
    "imageAssets": "assets/rising sun.jpg",
    "musicAssets": "assets/oversimplefied.mp3",
    "title": "Rising Sun",
  },
  {
    "imageAssets": "assets/siren.jpg",
    "musicAssets": "assets/psycho-siren.mp3",
    "title": "Siren",
  },
  {
    "imageAssets": "assets/ringtone.jpg",
    "musicAssets": "assets/ringtone.mp3",
    "title": "Ringtone",
  },
];

List<Map<String, String>> musicList = [
  {
    "imageAssets": "assets/fire.png",
    "musicAssets": "assets/crackling fireplace.mp3",
    "blur": "LEFX0DE20M^j03XS\$*ni0g\$%~BIV",
    "title": "Crackling Fireplace",
  },
  {
    "imageAssets": "assets/rain.png",
    "musicAssets": "assets/gentle rain.mp3",
    "title": "Gentle Rain",
  },
  {
    "imageAssets": "assets/melody.png",
    "musicAssets": "assets/meditation melody.mp3",
    "title": "Meditation Melody",
  },
  {
    "imageAssets": "assets/pink.png",
    "musicAssets": "assets/pink noise.mp3",
    "title": "Pink Noise",
  },
  {
    "imageAssets": "assets/ocean.png",
    "musicAssets": "assets/ocean waves.mp3",
    "title": "Ocean Waves",
  },
  {
    "imageAssets": "assets/thunder.png",
    "musicAssets": "assets/thunder rain.mp3",
    "title": "Thunder Rain",
  },
  {
    "imageAssets": "assets/white.jpg",
    "musicAssets": "assets/white noise.mp3",
    "title": "White Noise",
  },
];
FlutterSoundPlayer soundPlayer = FlutterSoundPlayer(
  logLevel: Level.nothing,
);

clearSecureStorageOnReinstall() async {
  String key = 'hasRunBefore';
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final runBefore = prefs.getBool(key);

  print(prefs.getBool(key));
  if (runBefore != null) {
    print(!runBefore);
  }

  if (runBefore == null || !runBefore) {
    print("삭제!");
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));
    final all = storage.readAll();
    print(all);

    await storage.deleteAll();
    prefs.setBool(key, true);
  } else {
    print("삭제 안함!");
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling front message: ${message.messageId}');
  VolumeController().setVolume(1);
  var now = DateTime.now().add(const Duration(seconds: 5));

  print(now);
  print(message.data);

  if (message.data['body'] != null) {
    final decodeBody = jsonDecode(message.data['body'].toString());
    print(decodeBody);

    if (decodeBody['type'] == 'STOP') {
      await Alarm.stop(int.parse(decodeBody['alarmId'].toString()));

      for (var snooze in decodeBody['snoozes']) {
        await Alarm.stop(int.parse(decodeBody['alarmId'].toString()) + int.parse(snooze.toString()));
      }
    } else {
      if (decodeBody['type'] == 'WAKE') {
        final music = musicList.firstWhere((element) => element['title'] == decodeBody['musicTitle']);

        final alarmSettings = AlarmSettings(
          id: int.parse(decodeBody['alarmId'].toString()),
          dateTime: now,
          assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
          loopAudio: true,
          fadeDuration: 5,
          vibrate: false,
          notificationTitle: 'This time to wake',
          notificationBody: '지금 일어날 시간이에요! 기상 알림을 재생합니다!',
          enableNotificationOnKill: true,
          stopOnNotificationOpen: false,
        );

        await Alarm.set(alarmSettings: alarmSettings);
        for (var i = 0; i < decodeBody['snoozes'].length; i++) {
          final alarmSettings = AlarmSettings(
            id: int.parse(decodeBody['alarmId'].toString()) + int.parse(decodeBody['snoozes'][i].toString()),
            dateTime: now.add(Duration(minutes: decodeBody['snoozes'][i] + 1 + i)),
            assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
            loopAudio: true,
            fadeDuration: 5,
            vibrate: false,
            notificationTitle: 'This time to wake',
            notificationBody: '지금 일어날 시간이에요! 기상 알림을 재생합니다!',
            enableNotificationOnKill: true,
            stopOnNotificationOpen: false,
          );
          await Alarm.set(alarmSettings: alarmSettings);
        }
      } else {
        final music = musicList.firstWhere((element) => element['title'] == decodeBody['musicTitle']);

        final alarmSettings = AlarmSettings(
          id: int.parse(decodeBody['alarmId'].toString()),
          dateTime: now,
          assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
          loopAudio: true,
          fadeDuration: 5,
          vibrate: false,
          notificationTitle: 'This time to sleep',
          notificationBody: '지금 잘시간이에요! 수면음원을 재생합니다!',
          enableNotificationOnKill: true,
          stopOnNotificationOpen: false,
        );

        await Alarm.set(alarmSettings: alarmSettings);
      }
    }
  } else {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool("isPadOff", true);
  }
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
  await clearSecureStorageOnReinstall();
  await Alarm.init(showDebugLogs: true);
  await Alarm.setNotificationOnAppKillContent("앱을 끄면 수면 음원 재생이 안되요!", "수면/기상 음원을 듣고싶다면 앱을 켜주세요!");
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // await audioPlayer.openAudioSession();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  FirebaseAuth.instance.idTokenChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

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
  final notificationStatus = await Permission.notification.status;

  int id = -1;
  var isRinging = false;
  String type = 'WAKE';

  Alarm.getAlarms().forEach((element) async {
    if (await Alarm.isRinging(element.id)) {
      isRinging = true;
      id = element.id;
    }
  });

  if (isRinging) {
    final alarmDatas = prefs.getString("alarmDatas");
    if (alarmDatas != null) {
      final decoded = jsonDecode(alarmDatas);
      for (dynamic alarmData in decoded) {
        final data = AlarmData.fromJson(alarmData);
        if (data.alarmSettings.id == id) {
          type = data.alarmData['alarm'];
        }
      }
    }
  }

  print(isRinging);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => MainPageProvider()),
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => CalendarPageProvider()),
      ChangeNotifierProvider(create: (_) => GlobalPageProvider())
    ],
    child: MyApp(
      initialRoute: isRinging
          ? type == 'WAKE'
              ? "/wake_alarm_page"
              : "/sleep_alarm_page"
          : accessToken != null && refreshToken != null && expiredAt != null
              ? "/home"
              : cameraStatus.isGranted && bluetoothStatus.isGranted && notificationStatus.isGranted
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

    final str = pref.getString('alarmDatas');
    if (str != null) {
      final datas = jsonDecode(str);
      List<AlarmData> alarms = [];
      for (var data in datas) {
        alarms.add(AlarmData.fromJson(data));
      }
      if (alarms.where((element) => element.alarmSettings.id == alarmSettings.id).isNotEmpty) {
        if (navigatorKey.currentState != null) {
          await navigatorKey.currentState!.pushNamed("/wake_alarm_page", arguments: alarmSettings);
        }
      }
    }

    final str2 = pref.getString('sleepDatas');
    if (str2 != null) {
      final datas = jsonDecode(str2);
      List<AlarmData> alarms = [];
      for (var data in datas) {
        alarms.add(AlarmData.fromJson(data));
      }
      if (alarms.where((element) => element.alarmSettings.id == alarmSettings.id).isNotEmpty) {
        if (navigatorKey.currentState != null) {
          await navigatorKey.currentState!.pushNamed("/sleep_alarm_page", arguments: alarmSettings);
        }
      }
    }
    // VolumeController().setVolume(1);
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
      await Firebase.initializeApp();
      await setupFlutterNotifications();
      print('Handling front message: ${message.messageId}');
      VolumeController().setVolume(1);
      var now = DateTime.now().add(const Duration(seconds: 5));

      print(now);
      print(message.data);

      if (message.data['body'] == null) {
        final pref = await SharedPreferences.getInstance();
        await pref.setBool("isPadOff", true);
        return;
      }

      final decodeBody = jsonDecode(message.data['body'].toString());
      print(decodeBody);

      if (decodeBody['type'] == 'STOP') {
        await Alarm.stop(int.parse(decodeBody['alarmId'].toString()));

        for (var snooze in decodeBody['snoozes']) {
          await Alarm.stop(int.parse(decodeBody['alarmId'].toString()) + int.parse(snooze.toString()));
        }
      } else {
        if (decodeBody['type'] == 'WAKE') {
          final music = musicList.firstWhere((element) => element['title'] == decodeBody['musicTitle']);

          final alarmSettings = AlarmSettings(
            id: int.parse(decodeBody['alarmId'].toString()),
            dateTime: now,
            assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
            loopAudio: true,
            fadeDuration: 5,
            vibrate: false,
            notificationTitle: 'This time to wake',
            notificationBody: '지금 일어날 시간이에요! 기상 알림을 재생합니다!',
            enableNotificationOnKill: true,
            stopOnNotificationOpen: false,
          );

          await Alarm.set(alarmSettings: alarmSettings);
          for (var i = 0; i < decodeBody['snoozes'].length; i++) {
            final alarmSettings = AlarmSettings(
              id: int.parse(decodeBody['alarmId'].toString()) + int.parse(decodeBody['snoozes'][i].toString()),
              dateTime: now.add(Duration(minutes: decodeBody['snoozes'][i] + 1 + i)),
              assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
              loopAudio: true,
              fadeDuration: 5,
              vibrate: false,
              notificationTitle: 'This time to wake',
              notificationBody: '지금 일어날 시간이에요! 기상 알림을 재생합니다!',
              enableNotificationOnKill: true,
              stopOnNotificationOpen: false,
            );
            await Alarm.set(alarmSettings: alarmSettings);
          }
          if (decodeBody['type'] == 'SLEEP') {
            await navigatorKey.currentState!.pushNamed("/sleep_alarm_page", arguments: alarmSettings);
          } else {
            await navigatorKey.currentState!.pushNamed("/wake_alarm_page", arguments: alarmSettings);
          }
        } else {
          final music = musicList.firstWhere((element) => element['title'] == decodeBody['musicTitle']);

          final alarmSettings = AlarmSettings(
            id: int.parse(decodeBody['alarmId'].toString()),
            dateTime: now,
            assetAudioPath: music['musicAssets'] ?? 'assets/alarm-clock-going-off.mp3',
            loopAudio: true,
            fadeDuration: 5,
            vibrate: false,
            notificationTitle: 'This time to sleep',
            notificationBody: '지금 잘시간이에요! 수면음원을 재생합니다!',
            enableNotificationOnKill: true,
            stopOnNotificationOpen: false,
          );

          await Alarm.set(alarmSettings: alarmSettings);
          if (decodeBody['type'] == 'SLEEP') {
            await navigatorKey.currentState!.pushNamed("/sleep_alarm_page", arguments: alarmSettings);
          } else {
            await navigatorKey.currentState!.pushNamed("/wake_alarm_page", arguments: alarmSettings);
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'DrBerryApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: widget.initialRoute,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [
        Locale("ko", "KR"),
        Locale("eu", "ES"),
      ],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const SplashPage(type: null));
          case '/home':
            return MaterialPageRoute(builder: (context) => const MainPage());
          case '/permission':
            return MaterialPageRoute(builder: (context) => const PermissionPage());
          case "/wake_alarm_page":
            return MaterialPageRoute(
              builder: (context) => WakeAlarmPage(
                alarmSettings: settings.arguments! as AlarmSettings,
              ),
            );
          case "/sleep_alarm_page":
            return MaterialPageRoute(
              builder: (context) => SleepAlarmPage(
                alarmSettings: settings.arguments! as AlarmSettings,
              ),
            );
        }
        return MaterialPageRoute(
          builder: (context) => const SplashPage(
            type: null,
          ),
        );
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
