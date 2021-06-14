import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildClosedContainer(Map package) {
  String destiny = package['trackings'].first['destiny'];
  return ListTile(
    title: Row(
      children: [
        Container(
          width: 60,
          child: Icon(Icons.check),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          package['name'],
                          style: Theme.of(Get.context!).textTheme.headline1,
                        ),
                        Text(
                          package['code'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Origem: ",
                          style: Theme.of(Get.context!).textTheme.headline2,
                        ),
                        Text(package['trackings'].first['city'])
                      ],
                    ),
                  ),
                ],
              ),
              destiny.isNotEmpty
                  ? Text(package['trackings'].first['destiny'])
                  : Container(),
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: Theme.of(Get.context!).textTheme.headline2,
                  ),
                  Text(package['trackings'].first['description'])
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}
