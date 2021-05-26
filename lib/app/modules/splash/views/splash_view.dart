import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  final SplashController controller;
  SplashView(this.controller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        controller.jumpToPageStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page!);
          }
        });
        return Center(
          child: Text(
            'SplashView is working',
            style: TextStyle(fontSize: 20),
          ),
        );
      }),
    );
  }
}
