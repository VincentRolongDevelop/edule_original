import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/notification_service.dart';
import 'package:flutter_application_1/view/userPages/notification/notification.dart';
import 'view/loginUserPage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_application_1/view/userPages/admin/components/bottom_navigation_menu.dart';
import 'package:flutter_application_1/view/userPages/admin/gridExamples/StudentScheduleGrid.dart';
import 'package:flutter_application_1/view/userPages/admin/manageOption/manageUserOption.dart';

import 'package:flutter_application_1/view/userPages/admin/AdminPage.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await initNotification();
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(title: 'login'),
    );
  }
}



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initNotification();
//   tz.initializeTimeZones();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'E-Dule',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
//       ),
//       home: const NotificationView(
//         title: 'Notification',
//       ),
//     );
//   }
// }
