import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/application_binding.dart';
import 'package:kd_rastreios_cp/app/themes/make_app_dark_theme.dart';
import 'package:kd_rastreios_cp/app/themes/make_app_light_theme.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    AdaptiveTheme(
      light: makeAppLightTheme(),
      dark: makeAppDarkTheme(),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => GetMaterialApp(
        title: "KD Rastreios",
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        initialBinding: ApplicationBinding(),
        getPages: AppPages.routes,
      ),
    ),
  );
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  print('ok');
  BackgroundFetch.finish(taskId);
}
