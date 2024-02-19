import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewParentPage extends StatefulWidget {
  @override
  _ViewParentPageState createState() => _ViewParentPageState();
}

class _ViewParentPageState extends State<ViewParentPage> {
  late List<Map<String, dynamic>> parents;

  @override
  void initState() {
    super.initState();
    parents = [];
    fetchParents();
  }

  Future<void> fetchParents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/parent/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          parents = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar los padres');
      }
    } catch (e) {
      print("Error al cargar los padres: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Padres'),
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
              'Lista de Padres',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: parents.isNotEmpty
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
                          rows: parents
                              .map(
                                (parent) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(parent['identification'].toString()),
                                    ),
                                    DataCell(
                                      Text(parent['firstName'].toString()),
                                    ),
                                    DataCell(
                                      Text(parent['lastName'].toString()),
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
                      child: Text('No hay padres para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
