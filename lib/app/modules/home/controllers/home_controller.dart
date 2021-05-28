import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../helpers/helpers.dart';
import '../../../modules/home/home.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  final Completer<GoogleMapController> googleMapController;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  HomeController({
    required this.homeUseCases,
    required this.googleMapController,
    required this.flutterLocalNotificationsPlugin,
  });

  var _indexBottomBar = Rx<int>(0);
  var _trackingName = ''.obs;
  var _trackingCode = ''.obs;
  var _codeFieldError = Rx<UIError>(UIError.noError);
  var _nameFieldError = Rx<UIError>(UIError.noError);
  var _isValidFields = Rx<UIError>(UIError.invalidFields);
  var _packages = <Map<dynamic, dynamic>>[].obs;
  var _themeMode = 1.obs;
  var _notificationSetup = 0.obs;
  var _currentLatitude = 1.0.obs;
  var _currentLongitude = 1.0.obs;
  var _mainError = Rx<UIError>(UIError.noError);

  int get indexBottomBarOut => _indexBottomBar.value;
  Stream<int?> get indexBottomBarStream => _indexBottomBar.stream;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  Stream<UIError?> get isValidFieldOut => _isValidFields.stream;
  List<Map<dynamic, dynamic>> get packages => _packages.toList();
  int get themeModeOut => _themeMode.value;
  int get notificationSetupOut => _notificationSetup.value;
  double get currentLatitudeOut => _currentLatitude.value;
  double get currentLongitudeOut => _currentLongitude.value;

  @override
  void onInit() async {
    final _cache = await homeUseCases.cache.readData('cash');

    List<dynamic> packagesCache = _cache[0]['packages'];
    print(_cache[0]['setup']['themeMode']);
    _themeMode.value = _cache[0]['setup']['themeMode'];
    _notificationSetup.value = _cache[0]['setup']['notificationMode'];
    _packages.clear();
    packagesCache.forEach((element) {
      _packages.add(element);
    });

    final location = await Geolocator.getCurrentPosition();
    _currentLatitude.value = location.latitude;
    _currentLongitude.value = location.longitude;
    initPlatformState();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void changeIndexBottomBar(int index) {
    _indexBottomBar.value = index;
  }

  @override
  void onClose() {}

  void validateCode(String value) {
    _trackingCode.value = value;
    if (value.length == 0) _isValidFields.value = UIError.invalidFields;
    value.length == 13
        ? _codeFieldError.value = UIError.noError
        : _codeFieldError.value = UIError.invalidCode;
    validateButton();
  }

  void validateName(String value) {
    _trackingName.value = value;
    if (value.length == 0) _isValidFields.value = UIError.invalidFields;
    value.length < 2
        ? _nameFieldError.value = UIError.invalidName
        : _nameFieldError.value = UIError.noError;
    validateButton();
  }

  void validateButton() {
    _nameFieldError.value == UIError.noError &&
            _trackingName.value != '' &&
            _trackingCode.value != '' &&
            _codeFieldError.value == UIError.noError
        ? _isValidFields.value = UIError.noError
        : _isValidFields.value = UIError.invalidFields;
  }

  Future<void> getPackage() async {
    try {
      final trackings = await homeUseCases.getPackages(
        code: _trackingCode.value,
        name: _trackingName.value,
      );
      _packages.clear();
      trackings.forEach((element) {
        _packages.add(element.toMap());
      });
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.badRequest:
          _mainError.value = UIError.badRequest;
          break;
        case HttpError.forbidden:
          _mainError.value = UIError.forbidden;
          break;
        case HttpError.notFound:
          _mainError.value = UIError.notFound;
          break;
        case HttpError.unauthorized:
          _mainError.value = UIError.unauthorized;
          break;
        case HttpError.unexpected:
          _mainError.value = UIError.unexpected;
          break;
        case HttpError.serverError:
          _mainError.value = UIError.serverError;
          break;
        case HttpError.noResponse:
          _mainError.value = UIError.noResponse;
          break;
      }
    }
    _mainError.value = UIError.noError;
  }

  void onMapComplete(GoogleMapController controller) {
    try {
      googleMapController.complete(controller);
    } catch (err) {
      print(err);
    }
  }

  void changeThemeMode(int mode) async {
    _indexBottomBar.value = 3;
    switch (mode) {
      case 0:
        AdaptiveTheme.of(Get.context!).setDark();
        break;
      case 1:
        AdaptiveTheme.of(Get.context!).setLight();
        break;
      case 2:
        AdaptiveTheme.of(Get.context!).setSystem();
        break;
    }
    await homeUseCases.setThemeMode(mode);
    _themeMode.value = mode;
  }

  void changeNotificationMode(int mode) async {
    _indexBottomBar.value = 3;
    await homeUseCases.setNotificationMode(mode);
    _notificationSetup.value = mode;
  }

  Future<void> initPlatformState() async {
    try {
      var status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout,
      );
      print('[BackgroundFetch] configure success: $status');

      BackgroundFetch.scheduleTask(
        TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 100,
          periodic: true,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true,
        ),
      );
    } catch (e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }
  }

  void _onBackgroundFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");

    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  void sendNofication() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showFlushBar({
    required String title,
    required String message,
  }) async {
    await Flushbar(
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      flushbarPosition: FlushbarPosition.BOTTOM,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      title: title,
      message: message,
      duration: Duration(seconds: 3),
    ).show(Get.context!);
  }
}
