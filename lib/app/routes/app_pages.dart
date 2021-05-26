import 'package:get/get.dart';

import 'package:kd_rastreios_cp/app/modules/home/bindings/home_binding.dart';
import 'package:kd_rastreios_cp/app/modules/home/views/home_view.dart';
import 'package:kd_rastreios_cp/app/modules/splash/bindings/splash_binding.dart';
import 'package:kd_rastreios_cp/app/modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(Get.find(), Get.find()),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(Get.find()),
      binding: SplashBinding(),
    ),
  ];
}
