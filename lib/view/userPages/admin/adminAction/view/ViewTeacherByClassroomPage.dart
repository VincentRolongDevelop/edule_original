import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewTeachersByClassroomPage extends StatefulWidget {
  @override
  _ViewTeachersByClassroomPageState createState() =>
      _ViewTeachersByClassroomPageState();
}

class _ViewTeachersByClassroomPageState
    extends State<ViewTeachersByClassroomPage> {
  List<String> classrooms = [];
  String selectedClassroom = "";
  List<Map<String, dynamic>> teachers = [];

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
          fetchTeachersByClassroom(selectedClassroom);
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

  Future<void> fetchTeachersByClassroom(String classroomName) async {
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/user/teachers/byClassroom/$classroomName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedTeachers =
            List<Map<String, dynamic>>.from(data.map((teacher) => {
                  'firstName': teacher[1],
                  'lastName': teacher[2],
                }));
        setState(() {
          teachers = fetchedTeachers;
        });
      } else {
        setState(() {
          teachers = []; // Vaciar la lista si no hay profesores
        });
        throw Exception('No se pueden cargar los profesores del salón');
      }
    } catch (e) {
      throw Exception('Error al cargar los profesores del salón: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Profesores por Salón'),
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
                  fetchTeachersByClassroom(selectedClassroom);
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
              'Profesores del Salón: $selectedClassroom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (teachers.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Apellido')),
                    ],
                    rows: teachers
                        .map(
                          (teacher) => DataRow(
                            cells: [
                              DataCell(
                                Text(teacher['firstName']),
                              ),
                              DataCell(
                                Text(teacher['lastName']),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            else
              Text('No hay profesores en este salón'),
          ],
        ),
      ),
    );
  }
}
