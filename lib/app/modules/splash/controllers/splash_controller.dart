import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';
import 'package:location/location.dart';

class SplashController extends GetxController {
  final Cache cache;
  final Location location;
  SplashController({required this.cache, required this.location});

  var _locationServiceEnable = false;
  var _permissionLocationStatus = PermissionStatus.denied;
  var _locationData = LocationData.fromMap({}).obs;

  var _jumtToPage = Rx<String>('');
  Stream<String?> get jumpToPageStream => _jumtToPage.stream;

  @override
  void onInit() async {
    await verifyLocationService();
    await cache.verifyCache();
    Future.delayed(Duration(seconds: 2), () => jumpToPage('/home'));
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
    _locationServiceEnable = await location.serviceEnabled();
    if (!_locationServiceEnable) {
      _locationServiceEnable = await location.requestService();
      if (!_locationServiceEnable) {
        return;
      }
    }

    _permissionLocationStatus = await location.hasPermission();
    if (_permissionLocationStatus == PermissionStatus.denied) {
      _permissionLocationStatus = await location.requestPermission();
      if (_permissionLocationStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationData.value = await location.getLocation();
  }
}
