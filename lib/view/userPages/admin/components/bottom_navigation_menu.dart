import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/userPages/admin/principalMenu/ScheduleHomePage.dart';
import 'package:flutter_application_1/view/userPages/admin/principalMenu/ManageHome.dart';
import 'package:flutter_application_1/view/userPages/admin/principalMenu/SearchHomePage.dart';
import 'package:flutter_application_1/view/userPages/admin/components/drawer_menu.dart';

class BottomNavigationMenu extends StatefulWidget {
  @override
  _BottomNavigationMenuState createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  int _selectedIndex = 0;

  List<Widget> _views = [
    ScheduleHomePage(),
    ManageHomePage(),
    SearchHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu,
                  size: 30.0, color: Color.fromARGB(255, 73, 70, 70)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem(0, Icons.event),
          buildNavBarItem(1, Icons.edit_document),
          buildNavBarItem(2, Icons.manage_search),
        ],
      ),
      drawer: DrawerMenu(
        onItemTapped: (index) {
          // Maneja las acciones cuando se toca un elemento del menú lateral
          // Puedes cerrar el cajón lateral aquí si es necesario
          Navigator.pop(context);
        },
        parentContext: context,
      ),
    );
  }

  Widget buildNavBarItem(int index, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: _selectedIndex == index ? Color(0xFF39AFC9) : Colors.white,
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 36.0,
                color: _selectedIndex == index ? Colors.white : Colors.grey,
              ),
              SizedBox(height: 4.0),
              Text(
                getLabel(index),
                style: TextStyle(
                  fontSize: 12,
                  color: _selectedIndex == index ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return 'Schedule';
      case 1:
        return 'Manage';
      case 2:
        return 'Search';
      default:
        return '';
    }
  }
}
