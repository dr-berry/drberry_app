import 'package:dio/dio.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Server {
  Dio dio = Dio(BaseOptions(
      baseUrl: "http://localhost:3000",
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000)));
  Dio noneDio = Dio(BaseOptions(
      baseUrl: "http://localhost:3000",
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000)));

  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));

  Future<String?> getAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  Server() {
    print("생성자 호출");
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print(options.toString());
        final expiredAt = await storage.read(key: "expiredAt");
        final refreshToken = await storage.read(key: "expiredAt");
        if (expiredAt != null && refreshToken != null) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(expiredAt));

          if (dateTime.compareTo(DateTime.now()) == 1) {
            await this.refreshToken(refreshToken, "deviceTokenTest").then((res) async {
              if (res.statusCode == 201) {
                await storage.delete(key: "accessToken");
                await storage.delete(key: "refreshToken");
                await storage.delete(key: "expiredAt");

                final tokenResponse = TokenResponse.fromJson(res.data);
                await storage.write(key: "accessToken", value: tokenResponse.accessToken);
                await storage.write(key: "refreshToken", value: tokenResponse.refreshToken);
                await storage.write(key: "expiredAt", value: tokenResponse.expiredAt.toString());
              }
            }).catchError((err) => print(err));
          }
        }
      },
    ));
  }

  Future<Response> checkSignUp(String deviceCode) async {
    return await noneDio.get("/auth/check_signup", options: Options(headers: {"X-Device-Code": deviceCode}));
  }

  Future<Response> login(String deviceCode, String deviceToken) async {
    return await noneDio.post("/auth/signin",
        options: Options(headers: {"X-Device-Code": deviceCode, "X-Device-Token": deviceToken}));
  }

  Future<Response> signUp(String name, String deviceCode, String gender, int tall, int weight, String birth,
      String deviceToken, bool isAppPush, bool isAlarmPush) async {
    return await noneDio.post(
      "/auth/signup",
      data: {
        "name": name,
        "gender": gender,
        "tall": tall,
        "weight": weight,
        "birth": birth,
        "deviceCode": deviceCode,
        "isAppPush": isAppPush,
        "isAlarmPush": isAlarmPush
      },
      options: Options(headers: {"X-Device-Token": deviceCode}),
    );
  }

  Future<Response> refreshToken(String refreshToken, String deviceToken) async {
    return await noneDio.put("/auth/refreshtoken",
        options: Options(headers: {"X-Refresh-Token": refreshToken, "X-Device-Token": deviceToken}));
  }

  Future<Response> getMainPage(String today) async {
    String accessToken = "Bearer ${await getAccessToken()}";

    print(accessToken);

    return await noneDio.get("/biometric/main",
        options: Options(headers: {"Authorization": accessToken}), queryParameters: {"today": today});
  }

  Future<Response> getCalendar(int month) async {
    String accessToken = "Bearer ${await getAccessToken()}";

    return await noneDio.get("/biometric/calendar",
        options: Options(
          headers: {"Authorization": accessToken},
        ),
        queryParameters: {"month": month});
  }
}
