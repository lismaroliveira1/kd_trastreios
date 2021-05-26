import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/i18n/i18n.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  HomeView(this.controller);
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
        () => BottomNavyBar(
          selectedIndex: controller.indexBottomBarOut,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text(R.translations.inTransit),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text(R.translations.completed),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.location_city),
              title: Text(
                R.translations.nearbyAgencies,
              ),
              activeColor: Colors.pink,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text(R.translations.setup),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: (int value) => controller.changeIndexBottomBar(value),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Container(
              child: Obx(
            () => ListView(
              children: controller.packages.map(
                (package) {
                  return OpenContainer(
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return buildClosedContainer(package);
                    },
                    openBuilder: (BuildContext context,
                        void Function({Object? returnValue}) action) {
                      return buildOpenedContainer(package);
                    },
                  );
                },
              ).toList(),
            ),
          ));
        },
      ),
    );
  }

  Widget buildOpenedContainer(Map package) => SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(package['name']),
              Text(package['code']),
            ],
          ),
        ),
      );

  Widget buildClosedContainer(Map package) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              Text(package['name']),
              Text(package['code']),
              Text(package['trackings'].first['dataTime']),
              Text(package['trackings'].first['city']),
              Text(package['trackings'].first['destiny']),
              Text(package['trackings'].first['description'])
            ],
          ),
        ),
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
