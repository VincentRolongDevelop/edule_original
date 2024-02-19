import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewAdminPage extends StatefulWidget {
  @override
  _ViewAdminPageState createState() => _ViewAdminPageState();
}

class _ViewAdminPageState extends State<ViewAdminPage> {
  late List<Map<String, dynamic>> administrators;

  @override
  void initState() {
    super.initState();
    administrators = [];
    fetchAdministrators();
  }

  Future<void> fetchAdministrators() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/admins');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          administrators = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar los administradores');
      }
    } catch (e) {
      print("Error al cargar los administradores: $e");
      throw Exception('Error al cargar los administradores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Administradores'),
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
              'Lista de Administradores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: administrators.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Identificación')),
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Apellido')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: administrators
                              .map(
                                (admin) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(admin['identification'].toString()),
                                    ),
                                    DataCell(
                                      Text(admin['firstName'].toString()),
                                    ),
                                    DataCell(
                                      Text(admin['lastName'].toString()),
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
                      child: Text('No hay administradores para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
