import 'dart:convert';

class TokenResponse {
  String accessToken;
  String refreshToken;
  int expiredAt;

  TokenResponse({required this.accessToken, required this.refreshToken, required this.expiredAt});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
        accessToken: json['accessToken'], refreshToken: json['refreshToken'], expiredAt: json['expireAt']);
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken, 'expiredAt': expiredAt};
  }
}

class MainPageBiometricData {
  UserBiometricData? userBiometricData;
  SimpleSleepData? simpleSleepData;
  List<SleepHistoryGague>? sleepHistoryGague = [];
  List<SevenWeekData>? sevenWeekData = [];
  SleepSuming? sleepSuming;
  SleepScoreRing? sleepScoreRing;
  TodayEvent? todayEvent;
  List<SleepPatternGraphData>? sleepPatternGraphData;
  List<SleepPatternGraphX>? sleepPatternGraphX;
  List<SleepPatternNeedDataNum>? sleepPatternNeedDataNum;
  SleepPatternDetailData? sleepPatternDetailData;
  List<SleepPatternGraphData>? wakeupQualityGraphData;
  WakeupQualityDetailData? wakeupQualityDetailData;
  List<HeartRateGraph>? heartRateGraph;
  List<HeartRateGraphX>? heartRateGraphX;
  HeartRateGraphY? heartRateGraphY;
  HeartRateDetailData? heartRateDetailData;
  List<TossNTurnGraph>? tossNTurnGraph;
  TossNTurnGraphY? tossNTurnGraphY;
  TossNTurnDetailData? tossNTurnDetailData;
  List<NosingGraph>? nosingGraph;
  NosingGraphX? nosingGraphX;
  NosingDetailData? nosingDetailData;
  List<NosingPartPercent>? nosingPartPercent;

  MainPageBiometricData(
      {this.userBiometricData,
      this.simpleSleepData,
      this.sleepHistoryGague,
      this.sevenWeekData,
      this.sleepSuming,
      this.sleepScoreRing,
      this.todayEvent,
      this.sleepPatternGraphData,
      this.sleepPatternGraphX,
      this.sleepPatternNeedDataNum,
      this.sleepPatternDetailData,
      this.wakeupQualityGraphData,
      this.wakeupQualityDetailData,
      this.heartRateGraph,
      this.heartRateGraphX,
      this.heartRateGraphY,
      this.heartRateDetailData,
      this.tossNTurnGraph,
      this.tossNTurnGraphY,
      this.tossNTurnDetailData,
      this.nosingGraph,
      this.nosingGraphX,
      this.nosingDetailData,
      this.nosingPartPercent});

  factory MainPageBiometricData.fromJson(Map<String, dynamic> json) {
    if (json["userBiometricData"] == null) {
      return MainPageBiometricData();
    }
    print("-=-=-=-=-=-=-=-=-=-");
    print(json['components'][6]['wakeupQualityDetailData']);
    print(json['components'][5]['sleepPatternNeedDataNum']);
    print("-=-=-=-=-=-=-=-=-=-");

    return MainPageBiometricData(
        userBiometricData: UserBiometricData.fromJson(
          json["userBiometricData"],
        ),
        simpleSleepData: SimpleSleepData.fromJson(json["components"][0]["simpleSleepData"]),
        sleepHistoryGague: SleepHistoryGague.fromJsonList(json['components'][0]['sleepHistoryGauge']),
        sevenWeekData: SevenWeekData.fromJsonList(json['components'][1]),
        sleepSuming: SleepSuming.fromJson(json['components'][2]),
        sleepScoreRing: SleepScoreRing.fromJson(json['components'][3]),
        todayEvent: TodayEvent.fromJson(json['components'][4]),
        sleepPatternGraphData: SleepPatternGraphData.fromJsonList(json['components'][5]['sleepPatternGraphData']),
        sleepPatternGraphX: SleepPatternGraphX.fromJsonList(json['components'][5]['sleepPatternGraphX']),
        sleepPatternNeedDataNum: SleepPatternNeedDataNum.fromJsonList(json['components'][5]['sleepPatternNeedDataNum']),
        sleepPatternDetailData: SleepPatternDetailData.fromJson(json['components'][5]['sleepPatternDetailData']),
        wakeupQualityGraphData: SleepPatternGraphData.fromJsonList(json['components'][6]['wakeupQualityGraphData']),
        wakeupQualityDetailData: WakeupQualityDetailData.fromJson(
            json['components'][6]['wakeupQualityDetailData'], json['components'][6]['wakeupWhenWakeTime']),
        heartRateGraph: HeartRateGraph.fromJsonList(json['components'][7]['heartRateGraph']),
        heartRateGraphX: HeartRateGraphX.fromJsonList(json['components'][7]['heartRateGraphX']),
        heartRateGraphY: HeartRateGraphY.fromJson(json['components'][7]['heartRateGraphY']),
        heartRateDetailData: HeartRateDetailData.fromJson(json['components'][7]['heartRateDetailData']),
        tossNTurnGraph: TossNTurnGraph.fromJsonList(json['components'][8]['tossNTurnGraph']),
        tossNTurnGraphY: TossNTurnGraphY.fromJson(json['components'][8]['tossNTurnGraphY']),
        tossNTurnDetailData: TossNTurnDetailData.fromJson(json['components'][8]['tossNTurnDetailData']),
        nosingGraph: NosingGraph.fromJsonList(json['components'][9]['nosingGraph']),
        nosingGraphX: NosingGraphX.fromJson(json['components'][9]['nosingGraphX']),
        nosingDetailData: NosingDetailData.fromJson(
            json['components'][9]['nosingDetailData'], json['components'][9]['nosingDetailPercent']),
        nosingPartPercent: NosingPartPercent.fromJsonList(json['components'][9]['nosingPartPercent']));
  }

  @override
  String toString() {
    return "MainPageBiometricData()";
  }
}

class UserBiometricData {
  int ubdSeq;
  int userSeq;
  int ussSeq;
  String measurementAt;

  UserBiometricData({required this.ubdSeq, required this.userSeq, required this.ussSeq, required this.measurementAt});

  factory UserBiometricData.fromJson(Map<String, dynamic> json) {
    return UserBiometricData(
        ubdSeq: json["ubdSeq"], userSeq: json["userSeq"], ussSeq: json["ussSeq"], measurementAt: json["measurementAt"]);
  }

  Map<String, dynamic> toJson() {
    return {"ubdSeq": ubdSeq, "userSeq": userSeq, "ussSeq": ussSeq, "measurementAt": measurementAt};
  }
}

class SimpleSleepData {
  int sleepScore;
  String deepSleepTimeDiff;
  String totalSleepTime;
  String measurementStartTime;
  String measurementEndTime;
  String whenSleepTimeDiff;

  SimpleSleepData(
      {required this.sleepScore,
      required this.deepSleepTimeDiff,
      required this.totalSleepTime,
      required this.measurementStartTime,
      required this.measurementEndTime,
      required this.whenSleepTimeDiff});

  factory SimpleSleepData.fromJson(Map<String, dynamic> json) {
    return SimpleSleepData(
        sleepScore: json["sleepScore"],
        deepSleepTimeDiff: json['deepSleepTimeDiff'],
        totalSleepTime: json["totalSleepTime"],
        measurementEndTime: json['measurementEndTime'],
        measurementStartTime: json['measurementStartTime'],
        whenSleepTimeDiff: json["whenSleepTimeDIff"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "sleepScore": sleepScore,
      "deepSleepTimeDiff": deepSleepTimeDiff,
      "totalSleepTime": totalSleepTime,
      "measurementEndTime": measurementEndTime,
      "measurementStartTime": measurementStartTime,
      "whenSleepTimeDiff": whenSleepTimeDiff
    };
  }
}

class SleepHistoryGague {
  int sleepPattern;
  String measurementAt;

  SleepHistoryGague({required this.sleepPattern, required this.measurementAt});

  factory SleepHistoryGague.fromJson(Map<String, dynamic> json) {
    return SleepHistoryGague(sleepPattern: json['sleepPattern'], measurementAt: json["measurementAt"]);
  }

  static List<SleepHistoryGague> fromJsonList(List<dynamic> jsonList) {
    List<SleepHistoryGague> result = [];

    for (dynamic element in jsonList) {
      result.add(SleepHistoryGague.fromJson(element));
    }

    return result;
  }
}

class SevenWeekData {
  int sleepScore;
  String date;

  SevenWeekData({required this.sleepScore, required this.date});

  factory SevenWeekData.fromJson(Map<String, dynamic> json) {
    return SevenWeekData(sleepScore: json["sleepScore"], date: json["date"]);
  }

  static List<SevenWeekData> fromJsonList(List<dynamic> jsonList) {
    List<SevenWeekData> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(SevenWeekData.fromJson(element));
    }

    return result;
  }
}

class SleepScoreRing {
  int sleepScore;
  int heartScore;
  int nosingScore;
  int tossNTurnScore;
  int wakeupQualityScore;
  int sleepPatternScore;

  SleepScoreRing(
      {required this.sleepScore,
      required this.heartScore,
      required this.nosingScore,
      required this.tossNTurnScore,
      required this.wakeupQualityScore,
      required this.sleepPatternScore});

  factory SleepScoreRing.fromJson(Map<String, dynamic> json) {
    return SleepScoreRing(
        heartScore: json['heartScore'],
        sleepPatternScore: json['sleepPatternScore'],
        sleepScore: json['sleepScore'],
        nosingScore: json['nosingScore'],
        tossNTurnScore: json['tossNTurnScore'],
        wakeupQualityScore: json['wakeupQualityScore']);
  }
}

class SleepSuming {
  int date;
  int? lastScore;
  int thisScore;
  int sumScore;

  SleepSuming({required this.date, this.lastScore, required this.sumScore, required this.thisScore});

  factory SleepSuming.fromJson(Map<String, dynamic> json) {
    return SleepSuming(
        date: json['date'], lastScore: json['lastScore'], thisScore: json['thisScore'], sumScore: json['sumScore']);
  }
}

class TodayEvent {
  int scoreDiff;
  String scoreType;
  int? lastDayScore;
  int? thisDayScore;

  TodayEvent(
      {required this.scoreDiff, required this.scoreType, required this.lastDayScore, required this.thisDayScore});

  factory TodayEvent.fromJson(Map<String, dynamic> json) {
    return TodayEvent(
        scoreDiff: json['scoreDiff'],
        scoreType: json['scoreType'],
        lastDayScore: json['lastWeekScore'],
        thisDayScore: json['thisWeekScore']);
  }
}

class SleepPatternGraphData {
  int sleepPattern;
  String measurementAt;

  SleepPatternGraphData({required this.sleepPattern, required this.measurementAt});

  factory SleepPatternGraphData.fromJson(Map<String, dynamic> json) {
    return SleepPatternGraphData(sleepPattern: json['sleepPattern'], measurementAt: json['measurementAt']);
  }

  static List<SleepPatternGraphData> fromJsonList(List<dynamic> jsonList) {
    List<SleepPatternGraphData> result = [];

    for (Map<String, dynamic> element in jsonList) {
      if (element['measurementAt'] is String) {
        result.add(SleepPatternGraphData.fromJson(element));
      } else {
        result.add(SleepPatternGraphData.fromJson(
            {"sleepPattern": element['sleepPattern'], "measurementAt": "${element['measurementAt']}"}));
      }
    }

    return result;
  }
}

class SleepPatternGraphX {
  String times;

  SleepPatternGraphX({required this.times});

  factory SleepPatternGraphX.fromJson(Map<String, dynamic> json) {
    return SleepPatternGraphX(times: json['times']);
  }

  static List<SleepPatternGraphX> fromJsonList(List<dynamic> jsonList) {
    List<SleepPatternGraphX> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(SleepPatternGraphX.fromJson(element));
    }

    return result;
  }
}

class SleepPatternNeedDataNum {
  int hours;
  int cnt;

  SleepPatternNeedDataNum({required this.hours, required this.cnt});

  factory SleepPatternNeedDataNum.fromJson(Map<String, dynamic> json) {
    return SleepPatternNeedDataNum(hours: json['hours'], cnt: json['cnt']);
  }

  static List<SleepPatternNeedDataNum> fromJsonList(List<dynamic> jsonList) {
    List<SleepPatternNeedDataNum> result = [];

    print("-----");
    print(jsonList);
    print("-----");

    for (Map<String, dynamic> element in jsonList) {
      result.add(SleepPatternNeedDataNum.fromJson(element));
    }

    return result;
  }
}

class SleepPatternDetailData {
  int sleepPatternScore;
  String wakeupPercent;
  String remPercent;
  String lightPercent;
  String deepPercent;

  SleepPatternDetailData(
      {required this.sleepPatternScore,
      required this.wakeupPercent,
      required this.remPercent,
      required this.lightPercent,
      required this.deepPercent});

  factory SleepPatternDetailData.fromJson(Map<String, dynamic> json) {
    return SleepPatternDetailData(
        sleepPatternScore: json['sleepPatternScore'],
        wakeupPercent: json['wakeupPercent'],
        remPercent: json['remPercent'],
        lightPercent: json['lightPercent'],
        deepPercent: json['deepPercent']);
  }
}

class WakeupQualityDetailData {
  String whenWakeTime;
  int wakeupQualityScore;
  String wakeTime;
  String remTime;
  String lightTime;
  String deepTime;

  WakeupQualityDetailData(
      {required this.whenWakeTime,
      required this.wakeupQualityScore,
      required this.wakeTime,
      required this.remTime,
      required this.lightTime,
      required this.deepTime});

  factory WakeupQualityDetailData.fromJson(Map<String, dynamic> json, Map<String, dynamic> whenJson) {
    return WakeupQualityDetailData(
        whenWakeTime: whenJson["whenWakeTime"],
        wakeupQualityScore: json['wakeupQualityScore'],
        wakeTime: json['wakeTime'],
        remTime: json['remTime'],
        lightTime: json['lightTime'],
        deepTime: json['deepTime']);
  }
}

class HeartRateGraph {
  String heartRate;
  String mesurementAt;

  HeartRateGraph({required this.heartRate, required this.mesurementAt});

  factory HeartRateGraph.fromJson(Map<String, dynamic> json) {
    return HeartRateGraph(heartRate: json['heartRate'], mesurementAt: json['mesurementAt']);
  }

  static List<HeartRateGraph> fromJsonList(List<dynamic> jsonList) {
    List<HeartRateGraph> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(HeartRateGraph.fromJson(element));
    }

    return result;
  }
}

class HeartRateGraphX {
  int hour;
  String number;

  HeartRateGraphX({required this.hour, required this.number});

  factory HeartRateGraphX.fromJson(Map<String, dynamic> json) {
    return HeartRateGraphX(hour: json['hour'], number: json['number']);
  }

  static List<HeartRateGraphX> fromJsonList(List<dynamic> jsonList) {
    List<HeartRateGraphX> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(HeartRateGraphX.fromJson(element));
    }

    return result;
  }
}

class HeartRateGraphY {
  String maxHeartRate;
  String minHeartRate;

  HeartRateGraphY({required this.maxHeartRate, required this.minHeartRate});

  factory HeartRateGraphY.fromJson(Map<String, dynamic> json) {
    return HeartRateGraphY(maxHeartRate: json['maxHeartRate'], minHeartRate: json['minHeartRate']);
  }
}

class HeartRateDetailData {
  int heartRateScore;
  String avgHeartRate;
  String heartBeatRange;

  HeartRateDetailData({required this.heartBeatRange, required this.avgHeartRate, required this.heartRateScore});

  factory HeartRateDetailData.fromJson(Map<String, dynamic> json) {
    return HeartRateDetailData(
        heartBeatRange: json['heartBeatRange'],
        avgHeartRate: json['avgHeartRate'],
        heartRateScore: json['heartRateScore']);
  }
}

class TossNTurnGraph {
  String tossNTurn;
  String hour;

  TossNTurnGraph({required this.tossNTurn, required this.hour});

  factory TossNTurnGraph.fromJson(Map<String, dynamic> json) {
    return TossNTurnGraph(tossNTurn: json['tossNTurn'], hour: json['hour']);
  }

  static List<TossNTurnGraph> fromJsonList(List<dynamic> jsonList) {
    List<TossNTurnGraph> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(TossNTurnGraph.fromJson(element));
    }

    return result;
  }
}

class TossNTurnGraphY {
  String minToss;
  String maxToss;

  TossNTurnGraphY({required this.minToss, required this.maxToss});

  factory TossNTurnGraphY.fromJson(Map<String, dynamic> json) {
    return TossNTurnGraphY(minToss: json['minToss'], maxToss: json['maxToss']);
  }
}

class TossNTurnDetailData {
  int tossNTurnPercent;
  String tossNTurnCnt;
  int tossNTurnScore;

  TossNTurnDetailData({required this.tossNTurnCnt, required this.tossNTurnPercent, required this.tossNTurnScore});

  factory TossNTurnDetailData.fromJson(Map<String, dynamic> json) {
    return TossNTurnDetailData(
        tossNTurnCnt: json['tossNTurnCnt'],
        tossNTurnPercent: json['tossNTurnPercent'],
        tossNTurnScore: json['tossNTurnScore']);
  }
}

class NosingGraph {
  String snoringLevel;
  String date;
  int levelCnt;
  double avgSnoring;

  NosingGraph({required this.snoringLevel, required this.avgSnoring, required this.date, required this.levelCnt});

  factory NosingGraph.fromJson(Map<String, dynamic> json) {
    return NosingGraph(
        snoringLevel: json['snoringLevel'],
        avgSnoring: double.parse("${json['avgSnoring']}"),
        date: json['date'],
        levelCnt: json['levelCnt']);
  }

  static List<NosingGraph> fromJsonList(List<dynamic> jsonList) {
    List<NosingGraph> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(NosingGraph.fromJson(element));
    }

    return result;
  }
}

class NosingGraphX {
  String minTime;
  String maxTime;

  NosingGraphX({required this.maxTime, required this.minTime});

  factory NosingGraphX.fromJson(Map<String, dynamic> json) {
    return NosingGraphX(maxTime: json["maxTime"], minTime: json['minTime']);
  }
}

class NosingDetailData {
  int score;
  int avgSnoring;
  int maxSnoring;
  String date;
  String snoringPercent;

  NosingDetailData(
      {required this.avgSnoring,
      required this.date,
      required this.maxSnoring,
      required this.score,
      required this.snoringPercent});

  factory NosingDetailData.fromJson(Map<String, dynamic> json, Map<String, dynamic> dpJson) {
    return NosingDetailData(
        avgSnoring: json['avgSnoring'],
        date: json['date'],
        maxSnoring: json['maxSnoring'],
        score: json['score'],
        snoringPercent: dpJson['snoringPercent']);
  }
}

class NosingPartPercent {
  String snoringLevel;
  String cnt;

  NosingPartPercent({required this.snoringLevel, required this.cnt});

  factory NosingPartPercent.fromJson(Map<String, dynamic> json) {
    return NosingPartPercent(snoringLevel: json['snoringLevel'], cnt: json['cnt']);
  }

  static List<NosingPartPercent> fromJsonList(List<dynamic> jsonList) {
    List<NosingPartPercent> result = [];

    for (Map<String, dynamic> element in jsonList) {
      result.add(NosingPartPercent.fromJson(element));
    }

    return result;
  }
}

class CalendarData {
  int ubdSeq;
  int sleepScore;
  int sleepPatternScore;
  int heartRateScore;
  int tossNTurnScore;
  int wakeScore;
  int nosingScore;
  String date;

  CalendarData(
      {required this.ubdSeq,
      required this.sleepScore,
      required this.heartRateScore,
      required this.tossNTurnScore,
      required this.wakeScore,
      required this.nosingScore,
      required this.sleepPatternScore,
      required this.date});

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
        ubdSeq: json["ubdSeq"],
        sleepScore: json["sleepScore"],
        heartRateScore: json["heartRateScore"],
        tossNTurnScore: json["tossNTurnScore"],
        wakeScore: json["wakeScore"],
        nosingScore: json["nosingScore"],
        sleepPatternScore: json["sleepPatternScore"],
        date: json["date"]);
  }

  static List<CalendarData> fromJsonList(List<dynamic> jsonList) {
    // print("res====");
    // print(jsonList.toString());

    List<CalendarData> result = [];

    for (dynamic json in jsonList) {
      result.add(CalendarData.fromJson(json));
    }

    return result;
  }
}

class UseTime {
  String totalUseTime;
  String totalDays;

  UseTime({required this.totalDays, required this.totalUseTime});

  factory UseTime.fromJson(dynamic json) {
    return UseTime(totalDays: json["totalDays"], totalUseTime: json["totalUseTime"]);
  }
}
