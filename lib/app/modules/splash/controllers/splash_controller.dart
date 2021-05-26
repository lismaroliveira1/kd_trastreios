import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

class SplashController extends GetxController {
  final Cache cache;
  SplashController(this.cache);
  var _jumtToPage = Rx<String>('');
  Stream<String?> get jumpToPageStream => _jumtToPage.stream;

  @override
  void onInit() async {
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
}
