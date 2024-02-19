import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class ViewSubjectsByClassroomPage extends StatefulWidget {
  @override
  _ViewSubjectsByClassroomPageState createState() =>
      _ViewSubjectsByClassroomPageState();
}

class _ViewSubjectsByClassroomPageState
    extends State<ViewSubjectsByClassroomPage> {
  List<String> classrooms = [];
  String selectedClassroom = "";
  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> fetchedClassrooms = List<String>.from(
            data.map((classroom) => classroom['classroom_name']));

        if (fetchedClassrooms.isNotEmpty) {
          setState(() {
            classrooms = fetchedClassrooms;
            selectedClassroom = fetchedClassrooms[0];
          });
          fetchSubjectsByClassroom(selectedClassroom);
        } else {
          throw Exception('No se encontraron salones');
        }
      } else {
        throw Exception('No se pueden cargar los salones');
      }
    } catch (e) {
      throw Exception('Error al cargar los salones: $e');
    }
  }

  Future<void> fetchSubjectsByClassroom(String classroomName) async {
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/subject/subjects/byClassroom/$classroomName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjects = data.map((subject) {
          return {
            'subjectName': subject,
          };
        }).toList();

        setState(() {
          subjects = fetchedSubjects;
        });
      } else {
        setState(() {
          subjects = []; // Vaciar la lista si no hay asignaturas
        });
        throw Exception('No se pueden cargar las asignaturas del salón');
      }
    } catch (e) {
      throw Exception('Error al cargar las asignaturas del salón: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Asignaturas por Salón'),
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
            if (classrooms.isNotEmpty)
              DropdownButton<String>(
                value: selectedClassroom,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClassroom = newValue!;
                  });
                  fetchSubjectsByClassroom(selectedClassroom);
                },
                items: classrooms.map((String classroom) {
                  return DropdownMenuItem<String>(
                    value: classroom,
                    child: Text(classroom),
                  );
                }).toList(),
              )
            else
              Text('No se encontraron salones'),
            SizedBox(height: 16),
            Text(
              'Asignaturas del Salón: $selectedClassroom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (subjects.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Nombre de la Asignatura')),
                    ],
                    rows: subjects
                        .map(
                          (subject) => DataRow(
                            cells: [
                              DataCell(
                                Text(subject['subjectName']),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            else
              Text('No hay asignaturas en este salón'),
          ],
        ),
      ),
    );
  }
}
