import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PageController());
    Get.put(Client());
    Get.put(Cache());
  }
}
