import 'dart:async';
import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../helpers/helpers.dart';
import '../../../modules/home/home.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  HomeController({
    required this.homeUseCases,
    required this.flutterLocalNotificationsPlugin,
  });

  var _indexBottomBar = Rx<int>(10);
  var _trackingName = ''.obs;
  var _trackingCode = ''.obs;
  var _codeFieldError = Rx<UIError>(UIError.noError);
  var _nameFieldError = Rx<UIError>(UIError.noError);
  var _isValidFields = Rx<UIError>(UIError.invalidFields);
  var _packages = <Map<dynamic, dynamic>>[].obs;
  var _packagesCompleteds = <Map<dynamic, dynamic>>[].obs;
  var _packagesNotCompleteds = <Map<dynamic, dynamic>>[].obs;
  var _themeMode = 1.obs;
  var _notificationSetup = 0.obs;
  var _currentLatitude = 1.0.obs;
  var _currentLongitude = 1.0.obs;
  var _textBar = 'Rastreios ativos'.obs;

  var _mainError = Rx<UIError>(UIError.noError);
  var _isLoading = Rx<bool>(false);

  int get indexBottomBarOut => _indexBottomBar.value;
  String get textBarOut => _textBar.value;
  Stream<int?> get indexBottomBarStream => _indexBottomBar.stream;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  Stream<UIError?> get isValidFieldOut => _isValidFields.stream;
  Stream<bool?> get isLoadingOut => _isLoading.stream;
  List<Map<dynamic, dynamic>> get packages => _packages.toList();
  List<Map<dynamic, dynamic>> get packagesCompleted =>
      _packagesCompleteds.toList();
  List<Map<dynamic, dynamic>> get packagesNotCompleted =>
      _packagesNotCompleteds.toList();
  int get themeModeOut => _themeMode.value;
  int get notificationSetupOut => _notificationSetup.value;
  double get currentLatitudeOut => _currentLatitude.value;
  double get currentLongitudeOut => _currentLongitude.value;

  @override
  void onInit() async {
    final _cache = await homeUseCases.cache.readData('cash');
    List<dynamic> packagesCache = _cache[0]['packages'];
    _packages.clear();
    _packagesCompleteds.clear();
    _packagesNotCompleteds.clear();
    packagesCache.forEach((element) {
      _packages.add(element);
    });
    _themeMode.value = _cache[0]['setup']['themeMode'];
    _notificationSetup.value = _cache[0]['setup']['notificationMode'];
    final location = await Geolocator.getCurrentPosition();
    (location.latitude);
    _currentLatitude.value = location.latitude;
    _currentLongitude.value = location.longitude;
    updateHomeLists();
    initPlatformState();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void changeIndexBottomBar(int index) {
    _indexBottomBar.value = index;
    switch (index) {
      case 0:
        _textBar.value = 'Rastreios ativos';
        break;
      case 1:
        _textBar.value = "Rastreios completos";
        break;
      case 2:
        _textBar.value = " Configurações";
        break;
    }
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

  void updateHomeLists() {
    _packages.forEach((element) {
      List trackings = element['trackings'];
      if (trackings.first['description'] == 'Objeto entregue ao destinatário') {
        _packagesCompleteds.add(element);
        print(element);
      } else {
        _packagesNotCompleteds.add(element);
      }
    });
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
    Navigator.pop(Get.context!);
    _isLoading.value = true;
    var error = UIError.noError;
    _packages.forEach((package) {
      if (package['code'] == _trackingCode.value) {
        error = UIError.alreadyExists;
      }
    });
    if (error == UIError.alreadyExists) {
      Future.delayed(
          Duration(
            seconds: 2,
          ), () {
        _isLoading.value = false;
        _mainError.value = error;
      });
    } else {
      try {
        final trackings = await homeUseCases.getPackages(
          code: _trackingCode.value,
          name: _trackingName.value,
        );
        _packages.clear();
        trackings.forEach((element) {
          _packages.add(element.toMap());
        });
        updateHomeLists();
        _isLoading.value = false;
      } on HttpError catch (error) {
        _isLoading.value = false;
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
          default:
            _mainError.value = UIError.noResponse;
            break;
        }
      }
    }
    _mainError.value = UIError.noError;
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
      ('[BackgroundFetch] configure success: $status');

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
      ("[BackgroundFetch] configure ERROR: $e");
    }
  }

  void _onBackgroundFetch(String taskId) async {
    ("[BackgroundFetch] Event received: $taskId");

    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetchTimeout(String taskId) {
    ("[BackgroundFetch] TIMEOUT: $taskId");
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

  Future<void> deleteItem(Map package) async {
    _packages.remove(package);
    final data = await homeUseCases.cache.readData('cash');
    data[0]['packages'] = _packages;
    await homeUseCases.cache.writeData(jsonEncode(data), path: 'cash');
  }

  Future<void> shareItem(Map package) async {
    List tracings = package['trackings'];
    (tracings.last['description']);
    await FlutterShare.share(
      title: package['name'] + " - " + package['code'],
      text: tracings.last['description'],
      linkUrl: package['name'] + " - " + package['code'],
      chooserTitle: 'KD Rastreios',
    );
  }
}
