import 'dart:collection';
import 'dart:convert';

class TrackingData {
  String data;
  String dataTime;
  String description;
  String city;
  String destiny;

  TrackingData({
    required this.data,
    required this.dataTime,
    required this.description,
    required this.city,
    required this.destiny,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'dataTime': dataTime,
      'description': description,
      'city': city,
      'destiny': destiny,
    };
  }

  factory TrackingData.fromMap(Map<String, dynamic> map) {
    print(map);
    String destiny = '';
    try {
      destiny = map['destino'];
    } catch (_) {
      destiny = '';
    }
    return TrackingData(
      data: map['data'],
      dataTime: map['dataTime'],
      description: map['description'],
      city: map['city'],
      destiny: destiny,
    );
  }
  factory TrackingData.fromLinkedHashMap(LinkedHashMap<dynamic, dynamic> map) {
    String destiny = '';
    try {
      destiny = map['destino'];
    } catch (_) {
      destiny = '';
    }
    return TrackingData(
      data: map['data'],
      dataTime: map['dataHora'],
      description: map['descricao'],
      city: map['cidade'],
      destiny: destiny,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackingData.fromJson(String source) =>
      TrackingData.fromMap(json.decode(source));
}
