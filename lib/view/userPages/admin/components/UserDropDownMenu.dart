import 'package:flutter/material.dart';

class UserDropdownMenu extends StatefulWidget {
  final Function(String?) onChanged;

  UserDropdownMenu({required this.onChanged});

  @override
  _UserDropdownMenuState createState() => _UserDropdownMenuState();
}

class _UserDropdownMenuState extends State<UserDropdownMenu> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            items: [
              _buildDropdownMenuItem('Administrator'),
              _buildDropdownMenuItem('Cordinator'),
              _buildDropdownMenuItem('Teacher'),
              _buildDropdownMenuItem('Student'),
              _buildDropdownMenuItem('Parent'),
            ],
            onChanged: (value) {
              setState(() {
                selectedOption = value;
              });
              widget.onChanged(value);
            },
            value: selectedOption, // Muestra la opción seleccionada
            hint: Text(
              'Search by',
              style: TextStyle(color: const Color.fromARGB(255, 100, 99, 99)), // Cambia el color a gris
            ),
            underline: Container(),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownMenuItem(String text) {
    return DropdownMenuItem<String>(
      value: text.toLowerCase(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: TextStyle(color: const Color.fromARGB(255, 100, 99, 99)), // Cambia el color a gris
        ),
      ),
    );
  }
}
