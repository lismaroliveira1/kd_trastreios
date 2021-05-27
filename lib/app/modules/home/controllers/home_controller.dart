import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  final Completer<GoogleMapController> googleMapController;
  final Location location;

  HomeController({
    required this.homeUseCases,
    required this.googleMapController,
    required this.location,
  });

  var _indexBottomBar = RxInt(0);
  var _trackingName = ''.obs;
  var _trackingCode = ''.obs;
  var _codeFieldError = Rx<UIError>(UIError.noError);
  var _nameFieldError = Rx<UIError>(UIError.noError);
  var _isValidFields = Rx<UIError>(UIError.invalidFields);
  var _packages = <Map<dynamic, dynamic>>[].obs;
  var _locationData = LocationData.fromMap({}).obs;
  var _themeMode = 1.obs;
  var _notificationSetup = 0.obs;

  int get indexBottomBarOut => _indexBottomBar.value;
  Stream<int?> get indexBottomBarStream => _indexBottomBar.stream;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;
  Stream<UIError?> get isValidFieldOut => _isValidFields.stream;
  List<Map<dynamic, dynamic>> get packages => _packages.toList();
  LocationData get locationData => _locationData.value;
  int get themeModeOut => _themeMode.value;
  int get notificationSetupOut => _notificationSetup.value;

  @override
  void onInit() async {
    _locationData.value = await location.getLocation();

    final _cache = await homeUseCases.cache.readData('cash');
    List<dynamic> packagesCache = _cache[0]['packages'];
    _packages.clear();
    packagesCache.forEach((element) {
      _packages.add(element);
    });
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
}
