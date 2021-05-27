import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/components.dart';

Widget buildHomePage(List<Map> children) {
  return Container(
    child: ListView(
      children: children.map(
        (package) {
          return OpenContainer(
            closedColor: Theme.of(Get.context!).backgroundColor,
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
