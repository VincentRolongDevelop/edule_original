import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewSubjectPage extends StatefulWidget {
  @override
  _ViewSubjectPageState createState() => _ViewSubjectPageState();
}

class _ViewSubjectPageState extends State<ViewSubjectPage> {
  late List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/subject/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjects =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          subjects = fetchedSubjects;
        });
      } else {
        throw Exception('No se pueden cargar las asignaturas (subjects)');
      }
    } catch (e) {
      throw Exception('Error al cargar las asignaturas (subjects): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Asignaturas'),
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
              'Lista de Asignaturas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: subjects.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID de la Asignatura')),
                            DataColumn(label: Text('Nombre de la Asignatura')),
                            DataColumn(
                                label: Text('Descripción de la Asignatura')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: subjects
                              .map(
                                (subject) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(subject['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(subject['subject_name'].toString()),
                                    ),
                                    DataCell(
                                      Text(subject['description'].toString()),
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
                      child: Text('No hay asignaturas para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
