import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';
import 'dart:convert';

class CreateUserSubjectPage extends StatefulWidget {
  @override
  _CreateUserSubjectPageState createState() => _CreateUserSubjectPageState();
}

class _CreateUserSubjectPageState extends State<CreateUserSubjectPage> {
  late List<Map<String, dynamic>> subjects;
  late List<Map<String, dynamic>> users;
  String? selectedSubjectId;
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    fetchUsers();
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

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedUsers =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          users = fetchedUsers;
          if (users.isNotEmpty) {
            selectedUserId = users.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los usuarios');
      }
    } catch (e) {
      throw Exception('Error al cargar los usuarios: $e');
    }
  }

  void _createUserSubject() async {
    if (selectedSubjectId != null && selectedUserId != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/usersubject/save');
        Map data = {
          'subject': {"id": selectedSubjectId},
          'user': {"id": selectedUserId},
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
              content: Text('Relación UserSubject creada con éxito'),
            ),
          );
        } else {
          print(
              'Error al crear la relación UserSubject. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al crear la relación UserSubject: $e");
      }
    } else {
      print('Selecciona una asignatura y un usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Relación UserSubject'),
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
                value: selectedUserId,
                hint: Text('Selecciona un usuario'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUserId = newValue!;
                  });
                },
                items: users.map<DropdownMenuItem<String>>((user) {
                  return DropdownMenuItem<String>(
                    value: user['id'].toString(),
                    child: Text('Usuario ${user['username']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _createUserSubject,
                child: Text('Crear Relación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
