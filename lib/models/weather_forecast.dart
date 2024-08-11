import 'package:weather_app/models/realtime_weather.dart';

class WeatherForecast {
  Timelines? timelines;
  Location? location;

  WeatherForecast({this.timelines, this.location});

  WeatherForecast.fromJson(Map<String, dynamic> json) {
    timelines = json['timelines'] != null
        ? Timelines.fromJson(json['timelines'])
        : null;
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timelines != null) {
      data['timelines'] = timelines!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Timelines {
  List<HourlyData>? hourly;

  Timelines({this.hourly});

  Timelines.fromJson(Map<String, dynamic> json) {
    if (json['hourly'] != null) {
      hourly = <HourlyData>[];
      json['hourly'].forEach((v) {
        hourly!.add(HourlyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (hourly != null) {
      data['hourly'] = hourly!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HourlyData {
  String? time;
  Values? values;

  HourlyData({this.time, this.values});

  HourlyData.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    values =
        json['values'] != null ? Values.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    if (values != null) {
      data['values'] = values!.toJson();
    }
    return data;
  }
}



