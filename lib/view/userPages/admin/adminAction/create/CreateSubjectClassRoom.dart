import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';
import 'dart:convert';

class CreateSubjectClassroomPage extends StatefulWidget {
  @override
  _CreateSubjectClassroomPageState createState() =>
      _CreateSubjectClassroomPageState();
}

class _CreateSubjectClassroomPageState
    extends State<CreateSubjectClassroomPage> {
  late List<Map<String, dynamic>> subjects;
  late List<Map<String, dynamic>> classrooms;
  String? selectedSubjectId;
  String? selectedClassroomId;

  TextEditingController someController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchClassrooms();
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
          if (subjects.isNotEmpty) {
            selectedSubjectId = subjects.first['id'].toString();
          }
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
          if (classrooms.isNotEmpty) {
            selectedClassroomId = classrooms.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar las aulas');
      }
    } catch (e) {
      throw Exception('Error al cargar las aulas: $e');
    }
  }

  void _createSubjectClassroom() async {
    if (selectedSubjectId != null && selectedClassroomId != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/save');
        Map data = {
          'subject': {"id": selectedSubjectId},
          'classroom': {"id": selectedClassroomId},
          'some_field':
              someController.text, // Reemplaza "some_field" con el campo real
        };

        var body = json.encode(data);

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        print("Es este" + body);
        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación SubjectClassroom creada con éxito'),
            ),
          );
        } else {
          print(
              'Error al crear la relación SubjectClassroom. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al crear la relación SubjectClassroom: $e");
      }
    } else {
      print('Selecciona una asignatura y un aula');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Relación SubjectClassroom'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedSubjectId,
                hint: Text('Selecciona una asignatura'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubjectId = newValue!;
                  });
                },
                items: subjects.map<DropdownMenuItem<String>>((subject) {
                  return DropdownMenuItem<String>(
                    value: subject['id'].toString(),
                    child: Text('Asignatura ${subject['subject_name']}'),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedClassroomId,
                hint: Text('Selecciona un aula'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClassroomId = newValue!;
                  });
                },
                items: classrooms.map<DropdownMenuItem<String>>((classroom) {
                  return DropdownMenuItem<String>(
                    value: classroom['id'].toString(),
                    child: Text('Aula ${classroom['classroom_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _createSubjectClassroom,
                child: Text('Crear Relación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
