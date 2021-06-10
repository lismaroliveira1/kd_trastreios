import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../storage/cache.dart';

class SplashController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Cache cache;
  SplashController({
    required this.cache,
    required this.flutterLocalNotificationsPlugin,
  });

  var _jumtToPage = Rx<String>('');
  Stream<String?> get jumpToPageStream => _jumtToPage.stream;

  @override
  void onInit() async {
    await verifyLocationService();
    await cache.verifyCache();
    await normalizePages();
    jumpToPage('/home');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void jumpToPage(String page) {
    _jumtToPage.value = page;
  }

  Future<void> verifyLocationService() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<void> initialyzeNotificationControl() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) => selectNotification(payload!));
  }

  Future selectNotification(String payload) async {
    print('notification payload: $payload');
  }

  Future<void> normalizePages() async {
    final _cache = await cache.readData('cash');
    _cache[0]['setup']['page'] = 0;
    print(_cache);
    cache.writeData(jsonEncode(_cache), path: 'cash');
  }
}
