import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewClassRoomPage extends StatefulWidget {
  @override
  _ViewClassRoomPageState createState() => _ViewClassRoomPageState();
}

class _ViewClassRoomPageState extends State<ViewClassRoomPage> {
  late List<Map<String, dynamic>> classrooms;

  @override
  void initState() {
    super.initState();
    classrooms = [];
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          classrooms = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar las aulas');
      }
    } catch (e) {
      print("Error al cargar los salones: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Salones'),
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
              'Lista de Salones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: classrooms.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID del Salón')),
                            DataColumn(label: Text('Nombre del Salón')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: classrooms
                              .map(
                                (classroom) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(classroom['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(classroom['classroom_name']
                                          .toString()),
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
                      child: Text('No hay salones para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
