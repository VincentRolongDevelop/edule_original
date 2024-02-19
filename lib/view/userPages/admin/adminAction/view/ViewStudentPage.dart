import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class ViewStudentPage extends StatefulWidget {
  @override
  _ViewStudentPageState createState() => _ViewStudentPageState();
}

class _ViewStudentPageState extends State<ViewStudentPage> {
  late List<Map<String, dynamic>> students;

  @override
  void initState() {
    super.initState();
    students = [];
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/student/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          students = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('No se pueden cargar los estudiantes');
      }
    } catch (e) {
      print("Error al cargar los estudiantes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Estudiantes'),
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
              'Lista de Estudiantes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: students.isNotEmpty
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
                          rows: students
                              .map(
                                (student) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                          student['identification'].toString()),
                                    ),
                                    DataCell(
                                      Text(student['firstName'].toString()),
                                    ),
                                    DataCell(
                                      Text(student['lastName'].toString()),
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
                      child: Text('No hay estudiantes para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
