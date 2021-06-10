import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/data/package_data.dart';
import 'package:kd_rastreios_cp/app/data/tracking_data.dart';
import 'package:kd_rastreios_cp/app/helpers/http_error.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

class HomeUseCases {
  final Client client;
  final Cache cache;
  HomeUseCases({required this.client, required this.cache});

  Future<List<PackageData>> getPackages(
      {required String code, required String name}) async {
    List<TrackingData> _trackings = [];
    List<PackageData> _packages = [];
    final url =
        'https://api.rastrearpedidos.com.br/api/rastreio/v1?codigo=$code';
    final response = await client.get(Uri.parse(url));
    (response.statusCode);
    (response.body);
    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        for (LinkedHashMap tracking in responseBody) {
          _trackings.add(TrackingData.fromLinkedHashMap(tracking));
        }
        final newPackage = PackageData(
          code: code,
          name: name,
          trackings: _trackings,
          createAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final _cache = await cache.readData('cash');
        List<dynamic> packagesCache = _cache[0]['packages'];
        packagesCache.add(newPackage.toMap());
        _cache[0]['packages'] = packagesCache;
        cache.writeData(jsonEncode(_cache), path: 'cash');
        packagesCache.forEach((element) {
          _packages.add(PackageData.fromMap(element));
        });
      } catch (error) {
        throw HttpError.noResponse;
      }
    } else {
      switch (response.statusCode) {
        case 400:
          throw HttpError.badRequest;
        case 401:
          throw HttpError.unauthorized;
        case 403:
          throw HttpError.unauthorized;
        case 404:
          throw HttpError.notFound;
        case 500:
          throw HttpError.serverError;
        default:
          throw HttpError.serverError;
      }
    }
    return _packages;
  }

  Future<void> setThemeMode(int mode) async {
    final _cache = await cache.readData('cash');
    _cache[0]['setup']['themeMode'] = mode;
    (_cache[0]['setup']);
    cache.writeData(jsonEncode(_cache), path: 'cash');
  }

  Future<void> setNotificationMode(int mode) async {
    final _cache = await cache.readData('cash');
    _cache[0]['setup']['notificationMode'] = mode;
    cache.writeData(jsonEncode(_cache), path: 'cash');
  }
}
