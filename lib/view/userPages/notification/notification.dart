import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../userPages/admin/AdminPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Dule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: const NotificationView(
        title: 'Notification',
      ),
    );
  }
}

DateTime scheduleTime = DateTime.now();

class NotificationView extends StatefulWidget {
  const NotificationView({super.key, required this.title});

  final String title;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DatePickerTxt(),
            ScheduleBtn(),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: [
                Container(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (DateTime time) {
                      setState(() {
                        scheduleTime = time;
                      });
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () async {
        debugPrint('Notification Scheduled for $scheduleTime');
        scheduleNotification(
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            context: context,
            scheduledNotificationDateTime: scheduleTime);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('scheduleTime', scheduleTime.toIso8601String());

        String? pr = prefs.getString('scheduleTime');
        print(pr);
      },
    );
  }
}
