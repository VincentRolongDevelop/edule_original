import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/userPages/admin/components/CustomSquareButtonWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ManageAcademicOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Matrix Buttons Example'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ManageUserOptionBody(),
      ),
    );
  }
}

class ManageUserOptionBody extends StatelessWidget {
  final List<IconData> icons = [
    MdiIcons.accountClock,
    FontAwesomeIcons.chalkboard,
    FontAwesomeIcons.peopleArrows,
    MdiIcons.bookEducation,
    
    
  ];

  final List<String> buttonTexts = [
    'Classroom',
    'Signature',
    'Role',
    'Topics',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white, // Fondo blanco
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomSquareButtonWidget(
                icon: FontAwesomeIcons.solidUser,
                buttonText: 'Users',
                onTap: () {
                  print('Botón 1 presionado');
                },
                buttonSize: 80.0,
                iconSize: 40.0,
                buttonColor: Color(0xFF0F89A5),
              ),
              CustomSquareButtonWidget(
                icon: MdiIcons.calendarClock,
                buttonText: 'Schedule',
                onTap: () {
                  print('Botón 2 presionado');
                },
                buttonSize: 80.0,
                iconSize: 40.0,
                buttonColor: Color(0xFF0F89A5),
              ),
              CustomSquareButtonWidget(
                icon: FontAwesomeIcons.book,
                buttonText: 'Academic',
                onTap: () {
                  print('Botón 3 presionado');
                },
                buttonSize: 80.0,
                iconSize: 40.0,
                buttonColor: Color(0xFF0F89A5),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255), // Fondo azul
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: buttonTexts.length,
                itemBuilder: (context, index) {
                  if (index < buttonTexts.length) {
                    IconData icon = icons[index];
                    String buttonText = buttonTexts[index];
                    VoidCallback onTap = () {
                      print('Botón $index presionado');
                    };

                    return CustomSquareButtonWidget(
                      icon: icon,
                      buttonText: buttonText,
                      onTap: onTap,
                      buttonSize: 60.0,
                      iconSize: 30.0,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
