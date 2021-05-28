import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/controllers.dart';
import './components/components.dart';
import './pages/pages.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  final PageController pageController;
  final Completer<GoogleMapController> googleMapController;
  HomeView({
    required this.controller,
    required this.pageController,
    required this.googleMapController,
  });
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.packages.length.toString())),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModal(
                context: context,
                configuration: FadeScaleTransitionConfiguration(
                  transitionDuration: Duration(milliseconds: 600),
                  reverseTransitionDuration: Duration(milliseconds: 250),
                ),
                builder: (context) => buildNewTrackingDialog(
                  getTrackings: () => controller.getPackage(),
                  hideKeyboard: _hideKeyboard,
                  nameFieldErrorStream: controller.nameFieldErrorStream,
                  uiErrorStream: controller.isValidFieldOut,
                  validateName: (value) => controller.validateName(value),
                  codeFieldErrorStream: controller.codeFieldErrorStream,
                  validateCode: (value) => controller.validateCode(value),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => buildBottomNavyBar(
          index: controller.indexBottomBarOut,
          onItemSelected: (value) => controller.changeIndexBottomBar(value),
        ),
      ),
      body: Builder(
        builder: (context) {
          controller.indexBottomBarStream.listen((view) {
            pageController.jumpToPage(view!);
          });
          return PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Obx(() => buildHomePage(controller.packages)),
              buildcompletedTrackingsPage(),
              Obx(
                () => buildAgenciesPage(
                  latitude: controller.currentLatitudeOut,
                  longitude: controller.currentLongitudeOut,
                ),
              ),
              Obx(
                () => buildSetupPage(
                  changeNotificationMode: (mode) =>
                      controller.changeNotificationMode(mode),
                  changeThemeMode: (mode) => controller.changeThemeMode(mode),
                  notificatioMode: controller.notificationSetupOut,
                  themeMode: controller.themeModeOut,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
