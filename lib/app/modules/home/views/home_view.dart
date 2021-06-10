import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../helpers/helpers.dart';
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
    final AdSize adSize = AdSize(width: 50, height: 300);
    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3676527383119521/4428357065',
      size: adSize,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.textBarOut)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.switch_camera,
          ),
          onPressed: () async {
            await controller.getPackageByBarCode(
              buildNewTrackingDialog(
                getTrackings: () => controller.getPackageByCode(),
                nameFieldErrorStream: controller.nameFieldErrorStream,
                uiErrorStream: controller.isValidFieldOut,
                validateName: (value) => controller.validateName(value),
                codeFieldErrorStream: controller.codeFieldErrorStream,
                validateCode: (value) => controller.validateCode(value),
                isBarCode: true,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              controller.showDialogBox(
                buildNewTrackingDialog(
                  getTrackings: () => controller.getPackageByCode(),
                  nameFieldErrorStream: controller.nameFieldErrorStream,
                  uiErrorStream: controller.isValidFieldOut,
                  validateName: (value) => controller.validateName(value),
                  codeFieldErrorStream: controller.codeFieldErrorStream,
                  validateCode: (value) => controller.validateCode(value),
                  isBarCode: false,
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
      body: Stack(
        children: [
          Builder(
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
                      changeThemeMode: (mode) =>
                          controller.changeThemeMode(mode),
                      notificatioMode: controller.notificationSetupOut,
                      themeMode: controller.themeModeOut,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              alignment: Alignment.center,
              child: adWidget,
            ),
          ),
        ],
      ),
    );
  }
}
