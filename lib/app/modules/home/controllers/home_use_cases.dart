import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/data/tracking_data.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

class HomeUseCases {
  final Client client;
  final Cache cache;
  HomeUseCases({required this.client, required this.cache});

  Future<List<TrackingData>> getPackages(String code) async {
    List<TrackingData> _trackings = [];
    final url =
        'https://api.rastrearpedidos.com.br/api/rastreio/v1?codigo=$code';
    final response = await client.get(Uri.parse(url));
    final responseBody = jsonDecode(response.body);
    for (LinkedHashMap tracking in responseBody) {
      _trackings.add(TrackingData.fromLinkedHashMap(tracking));
    }
    return _trackings;
  }
}
