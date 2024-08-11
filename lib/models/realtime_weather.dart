class WeatherRealTime {
  Data? data;
  Location? location;

  WeatherRealTime({this.data, this.location});

  WeatherRealTime.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Data {
  String? time;
  Values? values;

  Data({this.time, this.values});

  Data.fromJson(Map<String, dynamic> json) {
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

class Values {
  double? cloudBase;
  double? cloudCeiling;
  double? cloudCover;
  double? dewPoint;
  double? freezingRainIntensity;
  double? humidity;
  double? precipitationProbability;
  double? pressureSurfaceLevel;
  double? rainIntensity;
  double? sleetIntensity;
  double? snowIntensity;
  double? temperature;
  double? temperatureApparent;
  double? uvHealthConcern;
  double? uvIndex;
  double? visibility;
  double? weatherCode;
  double? windDirection;
  double? windGust;
  double? windSpeed;

  Values(
      {this.cloudBase,
      this.cloudCeiling,
      this.cloudCover,
      this.dewPoint,
      this.freezingRainIntensity,
      this.humidity,
      this.precipitationProbability,
      this.pressureSurfaceLevel,
      this.rainIntensity,
      this.sleetIntensity,
      this.snowIntensity,
      this.temperature,
      this.temperatureApparent,
      this.uvHealthConcern,
      this.uvIndex,
      this.visibility,
      this.weatherCode,
      this.windDirection,
      this.windGust,
      this.windSpeed});

  Values.fromJson(Map<String, dynamic> json) {
    cloudBase = (json['cloudBase'] ?? 0).toDouble();
    cloudCeiling = (json['cloudCeiling'] ?? 0).toDouble();
    cloudCover = (json['cloudCover'] ?? 0).toDouble();
    dewPoint = (json['dewPoint'] ?? 0).toDouble();
    freezingRainIntensity = (json['freezingRainIntensity'] ?? 0).toDouble();
    humidity = (json['humidity'] ?? 0).toDouble();
    precipitationProbability = (json['precipitationProbability'] ?? 0).toDouble();
    pressureSurfaceLevel = (json['pressureSurfaceLevel'] ?? 0).toDouble();
    rainIntensity = (json['rainIntensity'] ?? 0).toDouble();
    sleetIntensity = (json['sleetIntensity'] ?? 0).toDouble();
    snowIntensity = (json['snowIntensity'] ?? 0).toDouble();
    temperature = (json['temperature'] ?? 0).toDouble();
    temperatureApparent = (json['temperatureApparent'] ?? 0).toDouble();
    uvHealthConcern = (json['uvHealthConcern'] ?? 0).toDouble();
    uvIndex = (json['uvIndex'] ?? 0).toDouble();
    visibility = (json['visibility'] ?? 0).toDouble();
    weatherCode = (json['weatherCode'] ?? 0).toDouble();
    windDirection = (json['windDirection'] ?? 0).toDouble();
    windGust = (json['windGust'] ?? 0).toDouble();
    windSpeed = (json['windSpeed'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cloudBase'] = cloudBase;
    data['cloudCeiling'] = cloudCeiling;
    data['cloudCover'] = cloudCover;
    data['dewPoint'] = dewPoint;
    data['freezingRainIntensity'] = freezingRainIntensity;
    data['humidity'] = humidity;
    data['precipitationProbability'] = precipitationProbability;
    data['pressureSurfaceLevel'] = pressureSurfaceLevel;
    data['rainIntensity'] = rainIntensity;
    data['sleetIntensity'] = sleetIntensity;
    data['snowIntensity'] = snowIntensity;
    data['temperature'] = temperature;
    data['temperatureApparent'] = temperatureApparent;
    data['uvHealthConcern'] = uvHealthConcern;
    data['uvIndex'] = uvIndex;
    data['visibility'] = visibility;
    data['weatherCode'] = weatherCode;
    data['windDirection'] = windDirection;
    data['windGust'] = windGust;
    data['windSpeed'] = windSpeed;
    return data;
  }
}


class Location {
  double? lat;
  double? lon;
  String? name;
  String? type;

  Location({this.lat, this.lon, this.name, this.type});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}
