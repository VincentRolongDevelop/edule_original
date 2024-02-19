import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/view/userPages/admin/components/CustomButtonWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_application_1/view/userPages/admin/manageOption/manageUserOption.dart';
import 'package:flutter_application_1/view/userPages/admin/manageOption/manageScheduleOption.dart';
import 'package:flutter_application_1/view/userPages/admin/manageOption/manageAcademicOption.dart';

class ManageHomePage extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonWidget(
              icon: FontAwesomeIcons.users,
              title: 'Users',
              description: 'Users of system',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageUserOption()),
                );
               
              },
            ),
            CustomButtonWidget(
              icon: MdiIcons.calendarClock,
              title: 'Schedule',
              description: 'Dates and  hours for schedule',
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageScheduleOption()),
                );
                
              },
            ),
            CustomButtonWidget(
              icon: FontAwesomeIcons.book,
              title: 'Academic',
              description: 'Academic information',
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  ManageAcademicOption()),
                );
                

             
              },
            ),
          ],
        ),
      ),
    );
  }
}
