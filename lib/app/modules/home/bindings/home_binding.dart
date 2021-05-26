import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(HomeUseCases(client: Get.find(), cache: Get.find())),
    );
  }
}
