import 'package:dio/dio.dart';
import 'package:drberry_app/data/Data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Server {
  Dio dio = Dio(BaseOptions(
      // baseUrl: "http://localhost:3000",
      // baseUrl: "http://192.168.0.5:3000",
      baseUrl: "http://api.greenberry.site:3000",
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000)));
  Dio noneDio = Dio(BaseOptions(
      // baseUrl: "http://localhost:3000",
      // baseUrl: "http://192.168.0.5:3000",
      baseUrl: "http://api.greenberry.site:3000",
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
    return await noneDio.post(
      "/auth/signin",
      options: Options(
        headers: {
          "X-Device-Code": deviceCode,
          "X-Device-Token": deviceToken,
        },
      ),
    );
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

  Future<Response> getMainPage(String today, int ubdSeq) async {
    String accessToken = "Bearer ${await getAccessToken()}";

    print(accessToken);

    return await noneDio.get(
      "/biometric/main",
      options: Options(headers: {"Authorization": accessToken}),
      queryParameters: {
        "today": today,
        "ubdSeq": ubdSeq,
      },
    );
  }

  Future<Response> getCalendar(int month) async {
    String accessToken = "Bearer ${await getAccessToken()}";

    return await noneDio.get("/biometric/calendar",
        options: Options(
          headers: {"Authorization": accessToken},
        ),
        queryParameters: {"month": month});
  }

  Future<Response> getUseDeviceData() async {
    String accessToken = "Bearer ${await getAccessToken()}";
    print(accessToken);

    return await noneDio.get(
      "/biometric/use_time",
      options: Options(
        headers: {
          "Authorization": accessToken,
        },
      ),
    );
  }

  Future<Response> getProfileTabData() async {
    return await noneDio.get("/user/profile_tab",
        options: Options(headers: {"Authorization": "Bearer ${await getAccessToken()}"}));
  }

  Future<Response> getAccountInfo() async {
    return await noneDio.get(
      "/user/account",
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> updateUser(String? name, String? birthday, String? gender) async {
    return await noneDio.put("/user/account",
        data: {"name": name, "birthday": birthday, 'gender': gender},
        options: Options(headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        }));
  }

  Future<Response> getSettings() async {
    return await noneDio.get("/user/env/settings",
        options: Options(headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        }));
  }

  Future<Response> updateSettings(String type, bool setting) async {
    return await noneDio.put(
      '/user/env/settings',
      data: {
        'setting': setting,
        'type': type,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> exportSleepData(
    dynamic downloadPath,
    String startDate,
    String endDate,
  ) async {
    return await noneDio.download(
      '/user/export/excel',
      downloadPath,
      options: Options(headers: {"Authorization": "Bearer ${await getAccessToken()}"}),
      data: {
        'rangeDate': [
          startDate,
          endDate,
        ]
      },
    );
  }

  Future<Response> getUserSleepList(String today) async {
    return await noneDio.get('/biometric/main/multi',
        options: Options(
          headers: {
            "Authorization": "Bearer ${await getAccessToken()}",
          },
        ),
        queryParameters: {
          "today": today,
        });
  }

  Future<Response> getHistories(String today) async {
    return await noneDio.get(
      '/biometric/history',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
      queryParameters: {
        "today": today,
      },
    );
  }

  Future<Response> signOut() async {
    return await noneDio.delete(
      '/auth/signout',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> checkConnectWifi() async {
    return await noneDio.get(
      '/auth/check_connect_wifi',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> deviceState() async {
    return await noneDio.get(
      '/device/state',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> setConnectDeviceWifi(String deviceCode) async {
    return await noneDio.post(
      '/auth/set_connect_wifi',
      options: Options(
        headers: {
          "X-Device-Code": deviceCode,
        },
      ),
    );
  }

  Future<Response> getAlarms(String type) async {
    return await noneDio.get(
      '/alarm/$type',
      options: Options(
        headers: {
          "Authorization": "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> setAlarm(String alarmType, String startDate, String endDate, String musicTitle, List<int> snooze,
      List<int> weekdays) async {
    return await noneDio.post(
      '/alarm',
      data: {
        "alarmType": alarmType,
        "startDate": startDate,
        "endDate": endDate,
        "musicTitle": musicTitle,
        "snooze": snooze,
        "weekday": weekdays,
      },
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> updateAlarm(
      int alarmId, String startDate, String endDate, String musicTitle, List<int> snooze, List<int> weekdays) async {
    return await noneDio.put(
      '/alarm/$alarmId',
      data: {
        "startDate": startDate,
        "endDate": endDate,
        "musicTitle": musicTitle,
        "snooze": snooze,
        "weekday": weekdays,
      },
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> deleteAlarm(int alarmId) async {
    return await noneDio.delete(
      '/alarm/$alarmId',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> startSleep() async {
    return await noneDio.post(
      '/device/start_sleep',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> endSleep() async {
    return await noneDio.put(
      '/device/end_sleep',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> getSleepState() async {
    return await noneDio.get(
      '/device/sleep/state',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> deleteAccount() async {
    return await noneDio.delete(
      '/user/delete/account',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }

  Future<Response> getSleepAlarm(int alarmId) async {
    return await noneDio.get(
      '/alarm/$alarmId',
      options: Options(
        headers: {
          'Authorization': "Bearer ${await getAccessToken()}",
        },
      ),
    );
  }
}
