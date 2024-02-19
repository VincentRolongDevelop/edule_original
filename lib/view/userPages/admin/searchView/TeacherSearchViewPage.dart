import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/userPages/admin/components/dropdown_menu.dart';
import 'package:flutter_application_1/view/userPages/admin/gridExamples/TeacherScheduleGrid.dart';

class TeacherSearchViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search View Teacher'),
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
            // _buildDropdownMenu(),
            SizedBox(height: 10),
            _buildSearchBarAndButton(),
            SizedBox(
                height:
                    20), // Ajusta el espacio entre el buscador y la división
            Divider(height: 2, color: Colors.grey), // Agrega la división
            SizedBox(height: 20),
            // Ajusta el espacio entre la división y el horario
            Expanded(
              child: TeacherScheduleGrid(),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget _buildDropdownMenu() {
    return CustomDropdownMenu(
      onChanged: (value) {
        // Lógica cuando cambia la selección del menú
      },
    );
  }
  */

  Widget _buildSearchBarAndButton() {
    return Row(
      children: [
        Expanded(
          child: _buildSearchBar(),
        ),
        SizedBox(
          width: 10,
        ), // Espaciador entre el cuadro de búsqueda y el botón
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
