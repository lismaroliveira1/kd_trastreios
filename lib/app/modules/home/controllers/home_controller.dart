import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  final Completer<GoogleMapController> googleMapController;

  HomeController({
    required this.homeUseCases,
    required this.googleMapController,
  });

  var _indexBottomBar = RxInt(0);
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

  int get indexBottomBarOut => _indexBottomBar.value;
  Stream<int?> get indexBottomBarStream => _indexBottomBar.stream;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;
  Stream<UIError?> get isValidFieldOut => _isValidFields.stream;
  List<Map<dynamic, dynamic>> get packages => _packages.toList();
  int get themeModeOut => _themeMode.value;
  int get notificationSetupOut => _notificationSetup.value;
  double get currentLatitudeOut => _currentLatitude.value;
  double get currentLongitudeOut => _currentLongitude.value;

  @override
  void onInit() async {
    final _cache = await homeUseCases.cache.readData('cash');
    final location = await Geolocator.getCurrentPosition();
    _currentLatitude.value = location.latitude;
    _currentLongitude.value = location.longitude;

    List<dynamic> packagesCache = _cache[0]['packages'];
    _themeMode.value = _cache[0]['setup']['themeMode'];
    _notificationSetup.value = _cache[0]['setup']['notificationMode'];
    _packages.clear();
    packagesCache.forEach((element) {
      _packages.add(element);
    });

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
    value.length <= 10
        ? _codeFieldError.value = UIError.invalidCode
        : _codeFieldError.value = UIError.noError;
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
    final trackings = await homeUseCases.getPackages(
      code: _trackingCode.value,
      name: _trackingName.value,
    );
    _packages.clear();
    trackings.forEach((element) {
      _packages.add(element.toMap());
    });
  }

  void onMapComplete(GoogleMapController controller) {
    try {
      googleMapController.complete(controller);
    } catch (err) {
      print(err);
    }
  }

  void changeThemeMode(int mode) async {
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
          requiredNetworkType: NetworkType.NONE,
        ),
        _onBackgroundFetch,
        _onBackgroundFetchTimeout,
      );
      print('[BackgroundFetch] configure success: $status');

      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 10000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true));
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
}
