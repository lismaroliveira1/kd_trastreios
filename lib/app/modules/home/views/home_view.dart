import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/helpers/helpers.dart';

import '../controllers/controllers.dart';
import './components/components.dart';
import './pages/pages.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  final PageController pageController;

  HomeView({
    required this.controller,
    required this.pageController,
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
        title: Obx(() => Text(controller.textBarOut)),
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
            if (view != 10) {
              pageController.jumpToPage(view!);
            }
          });
          controller.mainErrorStream.listen((uiError) {
            if (uiError != UIError.noError) {
              controller.showFlushBar(
                title: 'Erro',
                message: uiError!.description,
              );
            }
          });
          controller.isLoadingOut.listen((event) {
            if (event!) {
              EasyLoading.show(status: 'Buscando dados...');
            } else {
              EasyLoading.dismiss();
            }
          });
          return PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Obx(() => buildHomePage(
                    children: controller.packagesNotCompleted,
                    deletePackage: (code) => controller.deleteItem(code),
                    sharePackage: (code) => controller.shareItem(code),
                  )),
              Obx(() => buildcompletedTrackingsPage(
                    children: controller.packagesCompleted,
                    deletePackage: (code) => controller.deleteItem(code),
                    sharePackage: (code) => controller.shareItem(code),
                  )),
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
