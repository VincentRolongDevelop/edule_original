import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewRolePage extends StatefulWidget {
  @override
  _ViewRolePageState createState() => _ViewRolePageState();
}

class _ViewRolePageState extends State<ViewRolePage> {
  late List<Map<String, dynamic>> roles = [];

  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/role/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedRoles =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          roles = fetchedRoles;
        });
      } else {
        throw Exception('No se pueden cargar los roles');
      }
    } catch (e) {
      throw Exception('Error al cargar los roles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Roles'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Lista de Roles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: roles.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID del Rol')),
                            DataColumn(label: Text('Nombre del Rol')),
                            DataColumn(label: Text('Descripción del Rol')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: roles
                              .map(
                                (role) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(role['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(role['role_name'].toString()),
                                    ),
                                    DataCell(
                                      Text(role['role_description'].toString()),
                                    ),
                                    // Añade más DataCell según sea necesario
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay roles para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
