import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';
import 'package:location/location.dart';

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Completer<GoogleMapController>());
    Get.put(Location());
    Get.put(PageController());
    Get.put(Client());
    Get.put(Cache());
  }
}
