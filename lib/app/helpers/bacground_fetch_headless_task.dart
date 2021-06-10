import 'dart:collection';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:kd_rastreios_cp/app/data/data.dart';
import 'package:kd_rastreios_cp/app/storage/cache.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  final cache = Cache();
  final client = Client();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) => selectNotification(payload!));
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  final data = await cache.readData('cash');
  List<dynamic> packages = data[0]['packages'];
  List<dynamic> _trackings = [];
  packages.forEach((element) async {
    (element['code']);
    (element['name']);
    List<dynamic> oldTrackings = element['trackings'];
    if (oldTrackings.first['description'] !=
        'Objeto entregue ao destinatário') {
      final url =
          'https://api.rastrearpedidos.com.br/api/rastreio/v1?codigo=${element['code']}';
      final response = await client.get(Uri.parse(url));
      final responseBody = jsonDecode(response.body);
      for (LinkedHashMap tracking in responseBody) {
        _trackings.add(TrackingData.fromLinkedHashMap(tracking).toMap());
      }
      if (_trackings.length > oldTrackings.length) {
        element = _trackings;
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'Novo status do seu pacote - ${element['code']}',
            (_trackings.first['description']),
            platformChannelSpecifics,
            payload: 'item x');
      }
    }
  });
  await cache.writeData(jsonEncode(data), path: 'cash');
  BackgroundFetch.finish(taskId);
}

Future selectNotification(String payload) async {
  ('notification payload: $payload');
}
