import 'package:get/get.dart';

import '../controllers/controllers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        homeUseCases: HomeUseCases(client: Get.find(), cache: Get.find()),
        flutterLocalNotificationsPlugin: Get.find(),
      ),
    );
  }
}
