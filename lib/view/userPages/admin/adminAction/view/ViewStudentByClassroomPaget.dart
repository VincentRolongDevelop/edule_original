import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class ViewStudentsByClassroomPage extends StatefulWidget {
  @override
  _ViewStudentsByClassroomPageState createState() =>
      _ViewStudentsByClassroomPageState();
}

class _ViewStudentsByClassroomPageState
    extends State<ViewStudentsByClassroomPage> {
  List<String> classrooms = [];
  String selectedClassroom = "";
  List<Map<String, dynamic>> students = [];

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
          fetchStudentsByClassroom(selectedClassroom);
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

  Future<void> fetchStudentsByClassroom(String classroomName) async {
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/student/students/byClassroom/$classroomName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedStudents =
            List<Map<String, dynamic>>.from(data.map((student) => {
                  'firstName': student[0],
                  'lastName': student[1],
                }));
        setState(() {
          students = fetchedStudents;
        });
      } else {
        setState(() {
          students = []; // Vaciar la lista si no hay estudiantes
        });
        throw Exception('No se pueden cargar los estudiantes del salón');
      }
    } catch (e) {
      throw Exception('Error al cargar los estudiantes del salón: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Estudiantes por Salón'),
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
                  fetchStudentsByClassroom(selectedClassroom);
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
              'Estudiantes del Salón: $selectedClassroom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (students.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Apellido')),
                    ],
                    rows: students
                        .map(
                          (student) => DataRow(
                            cells: [
                              DataCell(
                                Text(student['firstName']),
                              ),
                              DataCell(
                                Text(student['lastName']),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            else
              Text('No hay estudiantes en este salón'),
          ],
        ),
      ),
    );
  }
}
