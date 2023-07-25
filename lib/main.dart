import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drberry_app/screen/splash_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // await setupFlutterNotifications();
  print('Handling a background message: ${message.messageId}');
  print("${message.notification?.title}");

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

Future<File> getAssetFile(String assetPath) async {
  // Load the asset as a byte array.
  ByteData byteData = await rootBundle.load(assetPath);

  // Get a temporary directory to store the file.
  Directory tempDir = await getTemporaryDirectory();

  // Generate a file path in the temporary directory.
  String filePath = '${tempDir.path}/temp_asset.mp3';

  // Write the byte data to the file.
  await File(filePath).writeAsBytes(byteData.buffer.asUint8List());

  // Return a File object for the file.
  return File(filePath);
}

Future<void> playBackgroundAudio() async {
  // print("실행은 함 ㅇㅇ");
  print('실행함 ㅇㅅㅇ');
  final file = await getAssetFile('assets/ocean waves.mp3');

  await audioPlayer.startPlayer(fromURI: file.path);

  double volume = 0.0;
  Timer.periodic(const Duration(milliseconds: 500), (timer) {
    volume += 0.1;
    audioPlayer.setVolume(volume);

    if (volume >= 0.3) {
      timer.cancel();
    }
  });

  Future.delayed(const Duration(minutes: 1), () {
    stopBackgroundAudio();
  });
}

void stopBackgroundAudio() async {
  await audioPlayer.stopPlayer();
  // await audioPlayer.closeAudioSession();
}

final audioPlayer = FlutterSoundPlayer(logLevel: Level.nothing);
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => MainPageProvider()),
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => CalendarPageProvider())
    ],
    child: MyApp(
      initialRoute: accessToken != null && refreshToken != null && expiredAt != null
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

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print("init state");
    FirebaseMessaging.onMessage.listen((message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      await playBackgroundAudio();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: widget.initialRoute,
      routes: {
        "/login": (context) => const SplashPage(),
        "/home": (context) => const MainPage(),
        "/permission": (context) => const PermissionPage(),
      },
    );
  }
}
