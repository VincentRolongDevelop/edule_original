import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/view/userPages/admin/searchView/StudentSearchViewPage.dart';
import 'package:flutter_application_1/view/userPages/admin/components/CustomButtonWidget.dart';
import 'package:flutter_application_1/view/userPages/admin/searchView/TeacherSearchViewPage.dart';
import 'package:flutter_application_1/view/userPages/admin/searchView/ClassroomSearchViewPage.dart';

class ScheduleHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonWidget(
              icon: FontAwesomeIcons.chalkboardTeacher,
              title: 'Teachers',
              description: 'Schedule',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherSearchViewPage()),
                );
              },
            ),
            CustomButtonWidget(
              icon: FontAwesomeIcons.graduationCap,
              title: 'Students',
              description: 'Schedule',
              onTap: () {
                // Utiliza Navigator para navegar a la ventana SearchView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentSearchViewPage()),
                );
              },
            ),
            CustomButtonWidget(
              icon: FontAwesomeIcons.chalkboard,
              title: 'Classrooms',
              description: 'Schedule',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClassroomSearchViewPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
