import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget buildAgenciesPage({required latitude, required longitude}) {
  return Container(
    color: Theme.of(Get.context!).backgroundColor,
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          latitude,
          longitude,
        ),
        zoom: 14.4746,
      ),
    ),
  );
}
