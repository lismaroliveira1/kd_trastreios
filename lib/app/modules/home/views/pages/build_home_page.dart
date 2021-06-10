import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../components/components.dart';

Widget buildHomePage({
  required List<Map> children,
  required Function(Map package) deletePackage,
  required Function(Map package) sharePackage,
}) {
  return ListView(
    children: children.map(
      (package) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Slidable(
            child: OpenContainer(
              closedColor: Theme.of(Get.context!).backgroundColor,
              closedBuilder: (BuildContext context, void Function() action) {
                return buildClosedContainer(package);
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                return buildOpenedContainer(package, context);
              },
            ),
            actionPane: SlidableBehindActionPane(),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Compartilhar',
                color: Colors.indigo,
                icon: Icons.share,
                onTap: () => sharePackage(package),
              ),
            ],
            secondaryActions: [
              IconSlideAction(
                caption: 'Deletar',
                color: Colors.green,
                icon: Icons.remove_circle,
                onTap: () => deletePackage(package),
              ),
            ],
          ),
        );
      },
    ).toList(),
  );
}
