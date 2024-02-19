import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewCoordinatorPage extends StatefulWidget {
  @override
  _ViewCoordinatorPageState createState() => _ViewCoordinatorPageState();
}

class _ViewCoordinatorPageState extends State<ViewCoordinatorPage> {
  late List<Map<String, dynamic>> academicCoordinators;

  @override
  void initState() {
    super.initState();
    academicCoordinators = [];
    fetchAcademicCoordinators();
  }

  Future<void> fetchAcademicCoordinators() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/acacoords');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          academicCoordinators = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar los coordinadores académicos');
      }
    } catch (e) {
      print("Error al cargar los coordinadores académicos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Coordinadores Académicos'),
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
              'Lista de Coordinadores Académicos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: academicCoordinators.isNotEmpty
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
                          rows: academicCoordinators
                              .map(
                                (coordinator) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(coordinator['identification']
                                          .toString()),
                                    ),
                                    DataCell(
                                      Text(coordinator['firstName'].toString()),
                                    ),
                                    DataCell(
                                      Text(coordinator['lastName'].toString()),
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
                      child:
                          Text('No hay coordinadores académicos para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
