class MontlyPrayerTimingsModel {
  int? code;
  String? status;
  List<DataModel>? data;

  MontlyPrayerTimingsModel({this.code, this.status, this.data});

  MontlyPrayerTimingsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    if (json['data'] != null) {
      data = <DataModel>[];
      json['data'].forEach((v) {
        data!.add(DataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataModel {
  TimingsModel? timings;
  DateModel? date;
  MetaModel? meta;

  DataModel({this.timings, this.date, this.meta});

  DataModel.fromJson(Map<String, dynamic> json) {
    timings = json['timings'] != null ? TimingsModel.fromJson(json['timings']) : null;
    date = json['date'] != null ? DateModel.fromJson(json['date']) : null;
    meta = json['meta'] != null ? MetaModel.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timings != null) {
      data['timings'] = timings!.toJson();
    }
    if (date != null) {
      data['date'] = date!.toJson();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class TimingsModel {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;

  TimingsModel({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  TimingsModel.fromJson(Map<String, dynamic> json) {
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    sunset = json['Sunset'];
    maghrib = json['Maghrib'];
    isha = json['Isha'];
    imsak = json['Imsak'];
    midnight = json['Midnight'];
    firstthird = json['Firstthird'];
    lastthird = json['Lastthird'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Fajr'] = fajr;
    data['Sunrise'] = sunrise;
    data['Dhuhr'] = dhuhr;
    data['Asr'] = asr;
    data['Sunset'] = sunset;
    data['Maghrib'] = maghrib;
    data['Isha'] = isha;
    data['Imsak'] = imsak;
    data['Midnight'] = midnight;
    data['Firstthird'] = firstthird;
    data['Lastthird'] = lastthird;
    return data;
  }
}

class DateModel {
  String? readable;
  String? timestamp;
  GregorianModel? gregorian;
  HijriModel? hijri;

  DateModel({this.readable, this.timestamp, this.gregorian, this.hijri});

  DateModel.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    gregorian = json['gregorian'] != null ? GregorianModel.fromJson(json['gregorian']) : null;
    hijri = json['hijri'] != null ? HijriModel.fromJson(json['hijri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['readable'] = readable;
    data['timestamp'] = timestamp;
    if (gregorian != null) {
      data['gregorian'] = gregorian!.toJson();
    }
    if (hijri != null) {
      data['hijri'] = hijri!.toJson();
    }
    return data;
  }
}

class GregorianModel {
  String? date;
  String? format;
  String? day;
  WeekdayModel? weekday;
  MonthModel? month;
  String? year;
  DesignationModel? designation;
  bool? lunarSighting;

  GregorianModel(
      {this.date,
      this.format,
      this.day,
      this.weekday,
      this.month,
      this.year,
      this.designation,
      this.lunarSighting,});

  GregorianModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = json['weekday'] != null ? WeekdayModel.fromJson(json['weekday']) : null;
    month = json['month'] != null ? MonthModel.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null ? DesignationModel.fromJson(json['designation']) : null;
    lunarSighting = json['lunarSighting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['format'] = format;
    data['day'] = day;
    if (weekday != null) {
      data['weekday'] = weekday!.toJson();
    }
    if (month != null) {
      data['month'] = month!.toJson();
    }
    data['year'] = year;
    if (designation != null) {
      data['designation'] = designation!.toJson();
    }
    data['lunarSighting'] = lunarSighting;
    return data;
  }
}

class DesignationModel {
  String? abbreviated;
  String? expanded;

  DesignationModel({this.abbreviated, this.expanded});

  DesignationModel.fromJson(Map<String, dynamic> json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['abbreviated'] = abbreviated;
    data['expanded'] = expanded;
    return data;
  }
}

class HijriModel {
  String? date;
  String? format;
  String? day;
  String? method;
  String? year;
  WeekdayModel? weekday;
  MonthModel? month;
  DesignationModel? designation;

  HijriModel({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.method,
  });

  HijriModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = json['weekday'] != null ? WeekdayModel.fromJson(json['weekday']) : null;
    month = json['month'] != null ? MonthModel.fromJson(json['month']) : null;
    year = json['year'];
    designation =
        json['designation'] != null ? DesignationModel.fromJson(json['designation']) : null;

    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['format'] = format;
    data['day'] = day;
    if (weekday != null) {
      data['weekday'] = weekday!.toJson();
    }
    if (month != null) {
      data['month'] = month!.toJson();
    }
    data['year'] = year;
    if (designation != null) {
      data['designation'] = designation!.toJson();
    }
    data['method'] = method;
    return data;
  }
}

class WeekdayModel {
  String? en;
  String? ar;

  WeekdayModel({this.en, this.ar});

  WeekdayModel.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ar'] = ar;
    return data;
  }
}

class MonthModel {
  int? number;
  String? en;
  String? ar;
  int? days;

  MonthModel({this.number, this.en, this.ar, this.days});

  MonthModel.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
    days = json['days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['en'] = en;
    data['ar'] = ar;
    data['days'] = days;
    return data;
  }
}

class MetaModel {
  double? latitude;
  double? longitude;
  String? timezone;
  MethodModel? method;
  String? latitudeAdjustmentMethod;
  String? midnightMode;
  String? school;
  Offset? offset;

  MetaModel({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
  });

  MetaModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    timezone = json['timezone'];
    method = json['method'] != null ? MethodModel.fromJson(json['method']) : null;
    latitudeAdjustmentMethod = json['latitudeAdjustmentMethod'];
    midnightMode = json['midnightMode'];
    school = json['school'];
    offset = json['offset'] != null ? Offset.fromJson(json['offset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['timezone'] = timezone;
    if (method != null) {
      data['method'] = method!.toJson();
    }
    data['latitudeAdjustmentMethod'] = latitudeAdjustmentMethod;
    data['midnightMode'] = midnightMode;
    data['school'] = school;
    if (offset != null) {
      data['offset'] = offset!.toJson();
    }
    return data;
  }
}

class MethodModel {
  int? id;
  String? name;
  ParamsModel? params;
  Location? location;

  MethodModel({this.id, this.name, this.params, this.location});

  MethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    params = json['params'] != null ? ParamsModel.fromJson(json['params']) : null;
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (params != null) {
      data['params'] = params!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class ParamsModel {
  double? fajr;
  double? isha;

  ParamsModel.fromJson(Map<String, dynamic> json) {
    fajr = (json['Fajr'] as num?)?.toDouble();
    isha = (json['Isha'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Fajr'] = fajr;
    data['Isha'] = isha;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Offset {
  int? imsak;
  int? fajr;
  int? sunrise;
  int? dhuhr;
  int? asr;
  int? maghrib;
  int? sunset;
  int? isha;
  int? midnight;

  Offset({
    this.imsak,
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.sunset,
    this.isha,
    this.midnight,
  });

  Offset.fromJson(Map<String, dynamic> json) {
    imsak = json['Imsak'];
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    dhuhr = json['Dhuhr'];
    asr = json['Asr'];
    maghrib = json['Maghrib'];
    sunset = json['Sunset'];
    isha = json['Isha'];
    midnight = json['Midnight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Imsak'] = imsak;
    data['Fajr'] = fajr;
    data['Sunrise'] = sunrise;
    data['Dhuhr'] = dhuhr;
    data['Asr'] = asr;
    data['Maghrib'] = maghrib;
    data['Sunset'] = sunset;
    data['Isha'] = isha;
    data['Midnight'] = midnight;
    return data;
  }
}

class PrayerDay {
  PrayerDay({
    required this.day,
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final String day;
  final String date;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
}
