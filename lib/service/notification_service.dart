import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotification() async {
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('flutter');

  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {});
}

Future<Map<String, dynamic>> fetchData() async {
  var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
  final response = await http.get(url);
  return json.decode(response.body);
}

notificationDetails() {
  return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
      iOS: DarwinNotificationDetails());
}

Future scheduleNotification({
  int id = 0,
  String? title,
  String? body,
  String? payLoad,
  required DateTime scheduledNotificationDateTime,
  required BuildContext context,
}) async {
  // Verificar si la fecha programada es en el futuro
  if (scheduledNotificationDateTime.isBefore(DateTime.now())) {
    print('Error: La fecha programada debe ser en el futuro');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('La fecha programada debe ser en el futuro'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return;
  }

  // Programar la notificación solo si la fecha es en el futuro
  var scheduledDate =
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);
  await notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledDate,
    await notificationDetails(),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  // Mostrar una alerta indicando que la notificación ha sido programada
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notificación programada'),
        content: Text(
            'La notificación se ha programado para $scheduledNotificationDateTime'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
