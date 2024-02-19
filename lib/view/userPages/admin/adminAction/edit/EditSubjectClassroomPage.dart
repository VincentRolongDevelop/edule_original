import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditSubjectClassroomPage extends StatefulWidget {
  @override
  _EditSubjectClassroomPageState createState() =>
      _EditSubjectClassroomPageState();
}

class _EditSubjectClassroomPageState extends State<EditSubjectClassroomPage> {
  late List<Map<String, dynamic>> subjectClassrooms = [];
  late List<Map<String, dynamic>> subjects = [];
  late List<Map<String, dynamic>> classrooms = [];
  String selectedSubjectClassroomId = '';
  String? selectedSubjectId;
  String? selectedClassroomId;

  TextEditingController subjectClassroomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSubjectClassrooms();
    fetchSubjects();
    fetchClassrooms();
  }

  Future<void> fetchSubjectClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjectClassrooms =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          subjectClassrooms = fetchedSubjectClassrooms;
          if (subjectClassrooms.isNotEmpty) {
            selectedSubjectClassroomId =
                subjectClassrooms.first['id'].toString();
            loadSelectedSubjectClassroomData(selectedSubjectClassroomId);
          }
        });
      } else {
        throw Exception('No se pueden cargar las asignaturas en aulas');
      }
    } catch (e) {
      print("Error al cargar las asignaturas en aulas: $e");
    }
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
        throw Exception('No se pueden cargar las asignaturas');
      }
    } catch (e) {
      throw Exception('Error al cargar las asignaturas: $e');
    }
  }

  Future<void> fetchClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedClassrooms =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          classrooms = fetchedClassrooms;
        });
      } else {
        throw Exception('No se pueden cargar las aulas');
      }
    } catch (e) {
      throw Exception('Error al cargar las aulas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Asignatura en Aula'),
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
      body: subjectClassrooms.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedSubjectClassroomId,
                      hint: Text('Selecciona una asignatura en aula'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubjectClassroomId = newValue!;
                          loadSelectedSubjectClassroomData(
                              selectedSubjectClassroomId);
                        });
                      },
                      items: subjectClassrooms
                          .map<DropdownMenuItem<String>>((subjectClassroom) {
                        return DropdownMenuItem<String>(
                          value: subjectClassroom['id'].toString(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                                'ID:${subjectClassroom['id']} - ${subjectClassroom['subject']?['subject_name'] ?? 'Asignatura Desconocida'} - Aula ${subjectClassroom['classroom']?['classroom_name'] ?? 'Nombre Desconocido'}'),
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedSubjectId,
                      hint: Text('Selecciona una asignatura'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubjectId = newValue;
                        });
                      },
                      items: subjects.map<DropdownMenuItem<String>>((subject) {
                        return DropdownMenuItem<String>(
                          value: subject['id'].toString(),
                          child: Text('${subject['subject_name']}'),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedClassroomId,
                      hint: Text('Selecciona un aula'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClassroomId = newValue;
                        });
                      },
                      items:
                          classrooms.map<DropdownMenuItem<String>>((classroom) {
                        return DropdownMenuItem<String>(
                          value: classroom['id'].toString(),
                          child: Text('${classroom['classroom_name']}'),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: selectedSubjectClassroomId.isNotEmpty &&
                              selectedSubjectId != null &&
                              selectedClassroomId != null
                          ? () {
                              updateSubjectClassroomData();
                              FocusScope.of(context).unfocus();
                            }
                          : null,
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void loadSelectedSubjectClassroomData(String subjectClassroomId) {
    Map<String, dynamic>? subjectClassroom = subjectClassrooms.firstWhere(
      (subjectClassroom) =>
          subjectClassroom['id'].toString() == subjectClassroomId,
      orElse: () => {},
    );

    if (subjectClassroom != null &&
        subjectClassroom['subject'] != null &&
        subjectClassroom['classroom'] != null) {
      setState(() {
        selectedSubjectId = subjectClassroom['subject']['id']?.toString();
        selectedClassroomId = subjectClassroom['classroom']['id']?.toString();
      });
    }
  }

  Future<void> updateSubjectClassroomData() async {
    try {
      await editSubjectClassroom(
        subjectClassroomId: int.parse(selectedSubjectClassroomId),
        subjectId: int.parse(selectedSubjectId!),
        classroomId: int.parse(selectedClassroomId!),
      );
      print("Datos actualizados con éxito");
      fetchSubjectClassrooms();
    } catch (e) {
      print("Error al editar la asignatura en aula: $e");
    }
  }

  Future<void> editSubjectClassroom({
    required int subjectClassroomId,
    required int subjectId,
    required int classroomId,
  }) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/update');
    Map data = {
      'id': subjectClassroomId,
      'subject': {'id': subjectId},
      'classroom': {'id': classroomId},
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Datos de subjectclassroom actualizados con éxito");
    }
  }
}
