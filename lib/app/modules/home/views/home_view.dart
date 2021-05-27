import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/i18n/i18n.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_controller.dart';

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
                builder: (context) => buildNewTrackingDialog(_hideKeyboard),
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
              buildAgenciesPage(
                latitude: controller.currentLatitudeOut,
                longitude: controller.currentLongitudeOut,
              ),
              buildSetupPage(
                changeNotificationMode: (mode) =>
                    controller.changeNotificationMode(mode),
                changeThemeMode: (mode) => controller.changeThemeMode(mode),
                notificatioMode: controller.notificationSetupOut,
                themeMode: controller.themeModeOut,
              ),
            ],
          );
        },
      ),
    );
  }

  Dialog buildNewTrackingDialog(Function hideKeyboard) {
    return Dialog(
      child: InkWell(
        onTap: () => hideKeyboard(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 240,
            width: 300,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Text(R.translations.newTrackingPackage),
                Spacer(),
                buildCodeTextField(),
                buildNameTextField(),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    buildTrackingButton(),
                    TextButton(
                      onPressed: () {},
                      child: Text(R.translations.cancel),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<UIError?> buildTrackingButton() {
    return StreamBuilder<UIError?>(
      stream: controller.isValidFieldOut,
      builder: (context, snapshot) {
        return TextButton(
          onPressed: snapshot.data == UIError.noError
              ? () => controller.getPackage()
              : null,
          child: Text(R.translations.getTracking),
        );
      },
    );
  }

  StreamBuilder<UIError?> buildNameTextField() {
    return StreamBuilder<UIError?>(
        stream: controller.nameFieldErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: (value) => controller.validateName(value),
            decoration: InputDecoration(
              labelText: R.translations.packageName,
              errorText: snapshot.data == UIError.noError
                  ? null
                  : snapshot.data?.description,
            ),
          );
        });
  }

  StreamBuilder<UIError?> buildCodeTextField() {
    return StreamBuilder<UIError?>(
        stream: controller.codeFieldErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: (value) => controller.validateCode(value),
            decoration: InputDecoration(
              labelText: R.translations.tranckindCode,
              errorText: snapshot.data == UIError.noError
                  ? null
                  : snapshot.data?.description,
            ),
          );
        });
  }
}
