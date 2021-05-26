import 'dart:convert';

import './data.dart';

class PackageData {
  String code;
  String name;
  List<TrackingData> trackings;
  DateTime createAt;
  DateTime updatedAt;
  PackageData({
    required this.code,
    required this.name,
    required this.trackings,
    required this.createAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'trackings': trackings.map((x) => x.toMap()).toList(),
      'createAt': createAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
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
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PackageData.fromJson(String source) =>
      PackageData.fromMap(json.decode(source));
}
