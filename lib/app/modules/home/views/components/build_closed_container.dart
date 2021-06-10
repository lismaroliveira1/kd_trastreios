import 'package:flutter/material.dart';

Widget buildClosedContainer(Map package) {
  return ListTile(
    title: Column(
      children: <Widget>[
        Text(package['name']),
        Text(package['code']),
        Text(package['trackings'].first['dataTime']),
        Text(package['trackings'].first['city']),
        Text(package['trackings'].first['destiny']),
        Text(package['trackings'].first['description'])
      ],
    ),
  );
}
