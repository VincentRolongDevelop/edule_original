import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/userPages/admin/ConfigurationPage.dart';

class DrawerMenu extends StatefulWidget {
  final Function(int) onItemTapped;
  final BuildContext parentContext;

  DrawerMenu(
      {Key? key, required this.onItemTapped, required this.parentContext})
      : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Nombre de usuario"),
              accountEmail: Text("correo@ejemplo.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF39AFC9),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
            ),
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.settings,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                // Navega a ConfigurationPage
                Navigator.push(
                  widget.parentContext,
                  MaterialPageRoute(builder: (context) => ConfigurationPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.notifications,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                Navigator.pop(widget.parentContext);
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 73, 70, 70)),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey, // Cambiado a gris
              indent: 10, // Ajusta según sea necesario
              endIndent: 10, // Ajusta según sea necesario
            ),
            ListTile(
              title: Text(
                'Users',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.group,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                Navigator.pop(widget.parentContext);
              },
            ),
            ListTile(
              title: Text(
                'Subjects',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.subject,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                Navigator.pop(widget.parentContext);
              },
            ),
            ListTile(
              title: Text(
                'Classrooms',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.class_,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                Navigator.pop(widget.parentContext);
              },
            ),
            ListTile(
              title: Text(
                'Schedules',
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 73, 70, 70)),
              ),
              leading: Icon(
                Icons.schedule,
                size: 24,
                color: Color(0xFF39AFC9), // Cambiado a #39afc9
              ),
              onTap: () {
                Navigator.pop(widget.parentContext);
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nigth Mode',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 73, 70, 70)),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey, // Cambiado a gris
              indent: 10, // Ajusta según sea necesario
              endIndent: 10, // Ajusta según sea necesario
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ToggleButtons(
                children: [
                  Icon(
                    Icons.brightness_3,
                    size: 24,
                    color: isDarkModeEnabled ? Colors.white : Colors.grey,
                  ),
                  Icon(
                    Icons.wb_sunny,
                    size: 24,
                    color: isDarkModeEnabled ? Colors.grey : Colors.white,
                  ),
                ],
                isSelected: [isDarkModeEnabled, !isDarkModeEnabled],
                onPressed: (index) {
                  setState(() {
                    isDarkModeEnabled = !isDarkModeEnabled;
                    // Agregar lógica para cambiar el tema según el modo oscuro
                  });
                },
                color: Colors.white,
                selectedColor: Colors.white,
                fillColor: Color(0xFF39AFC9),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
