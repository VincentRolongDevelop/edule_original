import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewScheduleDayPage extends StatefulWidget {
  @override
  _ViewScheduleDayPageState createState() => _ViewScheduleDayPageState();
}

class _ViewScheduleDayPageState extends State<ViewScheduleDayPage> {
  late List<Map<String, dynamic>> teachers = [];
  late List<Map<String, dynamic>> students = [];
  String selectedRole = 'teacher';
  String selectedUser = '';
  late List<dynamic> schedule = [];

  @override
  void initState() {
    super.initState();
    fetchTeachers();
    fetchStudents();
    fetchSchedule();
  }

  Future<void> fetchTeachers() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/teachers');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedTeachers =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          teachers = fetchedTeachers;
          if (teachers.isNotEmpty) {
            selectedUser = teachers[0]['username'];
          }
        });
      } else {
        throw Exception('No se pueden cargar los profesores');
      }
    } catch (e) {
      throw Exception('Error al cargar los profesores: $e');
    }
  }

  Future<void> fetchStudents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/student/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedStudents =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          students = fetchedStudents;
          if (students.isNotEmpty) {
            selectedUser = students[0]['username'];
          }
        });
      } else {
        throw Exception('No se pueden cargar los estudiantes');
      }
    } catch (e) {
      throw Exception('Error al cargar los estudiantes: $e');
    }
  }

  Future<void> fetchSchedule() async {
    try {
      String url = '';

      if (selectedRole == 'teacher') {
        url = 'http://10.0.2.2:8080/api/schedule/teacher/$selectedUser';
      } else {
        url = 'http://10.0.2.2:8080/api/schedule/student/$selectedUser';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<dynamic> fetchedSchedule = List<dynamic>.from(data);
        setState(() {
          schedule.clear();
          schedule = fetchedSchedule;
        });
      } else {
        throw Exception('No se pueden cargar el horario del usuario');
      }
    } catch (e) {
      throw Exception('Error al cargar el horario del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Horario del Usuario'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un rol:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  selectedRole = newValue!;
                  if (selectedRole == 'teacher') {
                    selectedUser =
                        teachers.isNotEmpty ? teachers[0]['username'] : '';
                  } else {
                    selectedUser =
                        students.isNotEmpty ? students[0]['username'] : '';
                  }
                  fetchSchedule();
                });
              },
              items:
                  ['teacher', 'student'].map<DropdownMenuItem<String>>((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role == 'teacher' ? 'Profesor' : 'Estudiante'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Selecciona un usuario:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<Map<String, dynamic>>(
              value: selectedRole == 'teacher'
                  ? teachers.isNotEmpty
                      ? teachers.firstWhere(
                          (teacher) => teacher['username'] == selectedUser,
                          orElse: () =>
                              teachers[0], // Use the first teacher as a default
                        )
                      : null
                  : students.isNotEmpty
                      ? students.firstWhere(
                          (student) => student['username'] == selectedUser,
                          orElse: () =>
                              students[0], // Use the first student as a default
                        )
                      : null,
              hint: Text('Selecciona un usuario'),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  selectedUser = newValue!['username'];
                });
              },
              items: selectedRole == 'teacher'
                  ? teachers
                      .map<DropdownMenuItem<Map<String, dynamic>>>((teacher) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: teacher,
                        child: Text(teacher['username']),
                      );
                    }).toList()
                  : students
                      .map<DropdownMenuItem<Map<String, dynamic>>>((student) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: student,
                        child: Text(student['username']),
                      );
                    }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedUser.isNotEmpty) {
                  fetchSchedule();
                } else {
                  print('Selecciona un usuario');
                }
              },
              child: Text('Ver Horario'),
            ),
            SizedBox(height: 16),
            Text(
              'Horario del Usuario:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: schedule.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                                    selectedRole == 'teacher' ? 'Dia' : 'Dia')),
                            DataColumn(
                                label: Text(selectedRole == 'teacher'
                                    ? 'Hora'
                                    : 'Hora')),
                            DataColumn(
                                label: Text(selectedRole == 'teacher'
                                    ? 'Materia'
                                    : 'Materia')),
                            DataColumn(
                                label: Text(selectedRole == 'teacher'
                                    ? 'Aula'
                                    : 'Profesor')),
                          ],
                          rows: selectedRole == 'teacher'
                              ? schedule
                                  .map(
                                    (entry) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(entry.length > 0
                                              ? entry[0]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 1
                                              ? entry[1]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 2
                                              ? entry[2]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 3
                                              ? entry[3]
                                              : 'N/A'),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()
                              : schedule
                                  .map(
                                    (entry) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(entry.length > 1
                                              ? entry[1]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 2
                                              ? entry[2]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 3
                                              ? entry[3]
                                              : 'N/A'),
                                        ),
                                        DataCell(
                                          Text(entry.length > 4
                                              ? entry[4]
                                              : 'N/A'),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay horario para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
