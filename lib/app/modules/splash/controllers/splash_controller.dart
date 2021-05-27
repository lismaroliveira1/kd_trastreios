import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

class SplashController extends GetxController {
  final Cache cache;
  SplashController({
    required this.cache,
  });

  var _jumtToPage = Rx<String>('');
  Stream<String?> get jumpToPageStream => _jumtToPage.stream;

  @override
  void onInit() async {
    await verifyLocationService();
    await cache.verifyCache();
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
}
