import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewTeacherPage extends StatefulWidget {
  @override
  _ViewTeacherPageState createState() => _ViewTeacherPageState();
}

class _ViewTeacherPageState extends State<ViewTeacherPage> {
  late List<Map<String, dynamic>> teachers;

  @override
  void initState() {
    super.initState();
    teachers = [];
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/teachers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          teachers = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar los profesores');
      }
    } catch (e) {
      print("Error al cargar los profesores: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Profesores'),
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
              'Lista de Profesores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: teachers.isNotEmpty
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
                          rows: teachers
                              .map(
                                (teacher) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                          teacher['identification'].toString()),
                                    ),
                                    DataCell(
                                      Text(teacher['firstName'].toString()),
                                    ),
                                    DataCell(
                                      Text(teacher['lastName'].toString()),
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
                      child: Text('No hay profesores para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
