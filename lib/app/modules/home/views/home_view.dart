import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/i18n/i18n.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_controller.dart';
import 'package:timelines/timelines.dart';

import './components/components.dart';

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
              buildIncompletedTrackings(),
              buildcompletedTrackings(),
              buildAgenciesPage(),
              buildSetupPage(),
            ],
          );
        },
      ),
    );
  }

  Widget buildSetupPage() {
    return Obx(
      () => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                title: Text("Tema escuro"),
                subtitle: Text("Utilize o tema escuro no aplicativo"),
                value: controller.themeModeOut == 0,
                onChanged: (_) => controller.changeThemeMode(0),
              ),
              SwitchListTile(
                title: Text("Tema claro"),
                subtitle: Text("Utilize o tema escuro no aplicativo"),
                value: controller.themeModeOut == 1,
                onChanged: (_) => controller.changeThemeMode(1),
              ),
              SwitchListTile(
                title: Text("Tema do sistema"),
                subtitle: Text("Utilize o mesmo tema que o sistema"),
                value: controller.themeModeOut == 2,
                onChanged: (_) => controller.changeThemeMode(2),
              ),
              SwitchListTile(
                title: Text("Ativar todas as notificatificações"),
                subtitle: Text("Receba notificações em todos os eventos"),
                value: controller.notificationSetupOut == 0,
                onChanged: (_) => controller.changeNotificationMode(0),
              ),
              SwitchListTile(
                title: Text("Ativar notificações parcialmente"),
                subtitle:
                    Text("Receber notificações apenas nos ultimos eventos"),
                value: controller.notificationSetupOut == 1,
                onChanged: (_) => controller.changeNotificationMode(1),
              ),
              SwitchListTile(
                title: Text("Desativar notificações"),
                subtitle: Text("Não receber notificações"),
                value: controller.notificationSetupOut == 2,
                onChanged: (_) => controller.changeNotificationMode(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAgenciesPage() {
    return Obx(
      () => Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              controller.currentLatitudeOut,
              controller.currentLongitudeOut,
            ),
            zoom: 14.4746,
          ),
        ),
      ),
    );
  }

  Widget buildIncompletedTrackings() {
    return Obx(
      () => ListView(
        children: controller.packages.map(
          (package) {
            return OpenContainer(
              closedBuilder: (BuildContext context, void Function() action) {
                return buildClosedContainer(package);
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                return buildOpenedContainer(package, context);
              },
            );
          },
        ).toList(),
      ),
    );
  }

  Widget buildcompletedTrackings() {
    return Container();
  }

  Widget buildOpenedContainer(Map package, BuildContext context) {
    List<dynamic> _trackings = package['trackings'];
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Text(package['name']),
          Text(package['code']),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
                connectorTheme:
                    TimelineTheme.of(context).connectorTheme.copyWith(
                          thickness: 2.0,
                          indent: 3.0,
                        ),
                indicatorTheme:
                    TimelineTheme.of(context).indicatorTheme.copyWith(
                          size: 20.0,
                          position: 0,
                        ),
              ),
              builder: TimelineTileBuilder(
                indicatorBuilder: (_, index) =>
                    Indicator.outlined(borderWidth: 1.0),
                startConnectorBuilder: (_, index) => Connector.solidLine(),
                endConnectorBuilder: (_, index) => Connector.solidLine(),
                contentsBuilder: (_, index) {
                  int _countItens = 4;
                  if (_trackings[index]['destiny'] == '') _countItens = 3;
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(_trackings[index]['description']),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FixedTimeline.tileBuilder(
                          theme: TimelineTheme.of(context).copyWith(
                            nodePosition: 0,
                            connectorTheme: TimelineTheme.of(context)
                                .connectorTheme
                                .copyWith(
                                  thickness: 1.0,
                                ),
                            indicatorTheme: TimelineTheme.of(context)
                                .indicatorTheme
                                .copyWith(
                                  size: 6.0,
                                  position: 0.4,
                                ),
                          ),
                          builder: TimelineTileBuilder(
                            contentsAlign: ContentsAlign.basic,
                            indicatorBuilder: (_, indexChild) =>
                                Indicator.outlined(borderWidth: 1.0),
                            startConnectorBuilder: (_, indexChild) =>
                                Connector.solidLine(),
                            endConnectorBuilder: (_, indexChild) =>
                                Connector.solidLine(),
                            contentsBuilder: (_, indexChild) {
                              String value() {
                                switch (indexChild) {
                                  case 0:
                                    return 'Data: ${_trackings[index]['dataTime'].split(' ')[0]}';
                                  case 1:
                                    return 'Hora: ${_trackings[index]['dataTime'].split(' ')[1]}';
                                  case 2:
                                    return 'Cidade origem: ${_trackings[index]['city']}';
                                  case 3:
                                    if (_trackings[index]['destiny'] == '') {
                                      return '';
                                    }
                                    return 'Cidade destino: ${_trackings[index]['destiny']}';
                                }
                                return '';
                              }

                              return Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [Text(value())],
                                ),
                              );
                            },
                            itemExtentBuilder: (_, index) => 20,
                            itemCount: _countItens,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemExtentBuilder: (_, index) => 120,
                itemCount: _trackings.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
