import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        homeUseCases: HomeUseCases(client: Get.find(), cache: Get.find()),
        googleMapController: Get.find(),
        location: Get.find(),
      ),
    );
  }
}
