import 'dart:convert';

import './data.dart';

class PackageData {
  String code;
  String name;
  List<TrackingData> trackings;

  PackageData({
    required this.code,
    required this.name,
    required this.trackings,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'trackings': trackings.map((x) => x.toMap()).toList(),
    };
  }

  factory PackageData.fromMap(Map<String, dynamic> map) {
    return PackageData(
      code: map['code'],
      name: map['name'],
      trackings: List<TrackingData>.from(
        map['trackings']?.map(
          (x) => TrackingData.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageData.fromJson(String source) =>
      PackageData.fromMap(json.decode(source));
}
