import 'package:flutter/material.dart';
// Importa la tabla desde el nuevo archivo
import 'package:flutter_application_1/view/userPages/admin/components/CustomButtonWidget.dart';
import 'package:flutter_application_1/view/userPages/admin/components/UserDropDownMenu.dart';
import 'package:flutter_application_1/view/userPages/admin/components/tables/ScheduleTable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScheduleOptionSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Search View Schedule'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownMenu(),
              SizedBox(height: 10),
              _buildSearchBarAndButton(),
              SizedBox(
                height: 20,
              ),
              Divider(height: 2, color: Colors.grey),
              SizedBox(height: 20),
              ScheduleTable(), // Agrega la tabla aquí
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return UserDropdownMenu(
      onChanged: (value) {
        // Lógica cuando cambia la selección del menú
      },
    );
  }

  Widget _buildSearchBarAndButton() {
    return Row(
      children: [
        Expanded(
          child: _buildSearchBar(),
        ),
        SizedBox(
          width: 10,
        ),
        _buildSearchButton(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 77, 181, 204),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: () {
          // Lógica de búsqueda aquí
        },
        icon: Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
