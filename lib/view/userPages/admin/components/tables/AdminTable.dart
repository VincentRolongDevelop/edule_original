import 'package:flutter/material.dart';

class AdminTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Nombre')),
        DataColumn(label: Text('Correo')),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text('1')),
          DataCell(Text('Usuario 1')),
          DataCell(Text('usuario1@example.com')),
        ]),
        DataRow(cells: [
          DataCell(Text('2')),
          DataCell(Text('Usuario 2')),
          DataCell(Text('usuario2@example.com')),
        ]),
        DataRow(cells: [
          DataCell(Text('3')),
          DataCell(Text('Usuario 3')),
          DataCell(Text('usuario3@example.com')),
        ]),
        // Agrega más filas según sea necesario
      ],
    );
  }
}
