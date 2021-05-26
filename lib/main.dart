import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/application_binding.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      initialBinding: ApplicationBinding(),
      getPages: AppPages.routes,
    ),
  );
}
