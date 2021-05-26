import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  HomeController(this.homeUseCases);

  var _indexBottomBar = 0.obs;

  int get indexBottomBarOut => _indexBottomBar.value;

  @override
  void onInit() {
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

  void validateCode(String value) {}
}
