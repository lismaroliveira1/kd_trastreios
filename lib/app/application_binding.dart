import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';
import 'package:kd_rastreios_cp/app/themes/make_app_light_theme.dart';
import 'package:location/location.dart';

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Completer<GoogleMapController>());
    Get.put(Location());
    Get.put(AdaptiveTheme(
      builder: (ThemeData light, ThemeData dark) {
        return Container();
      },
      initial: AdaptiveThemeMode.system,
      light: makeAppLightTheme(),
      dark: makeAppLightTheme(),
    ));
    Get.put(PageController());
    Get.put(Client());
    Get.put(Cache());
  }
}
