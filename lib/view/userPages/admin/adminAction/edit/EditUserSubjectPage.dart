import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditUserSubjectPage extends StatefulWidget {
  @override
  _EditUserSubjectPageState createState() => _EditUserSubjectPageState();
}

class _EditUserSubjectPageState extends State<EditUserSubjectPage> {
  late List<Map<String, dynamic>> userSubjects = [];
  late List<Map<String, dynamic>> subjects = [];
  late List<Map<String, dynamic>> users = [];

  String selectedUserSubjectId = '';
  String? selectedSubjectId;
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    fetchUserSubjects();
    fetchSubjects();
    fetchUsers();
  }

  Future<void> fetchUserSubjects() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/usersubject/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedUserSubjects =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          userSubjects = fetchedUserSubjects;
          if (userSubjects.isNotEmpty) {
            selectedUserSubjectId = userSubjects.first['id'].toString();
            loadSelectedUserSubjectData(selectedUserSubjectId);
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones usuario-materia');
      }
    } catch (e) {
      print("Error al cargar las relaciones usuario-materia: $e");
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
        throw Exception('No se pueden cargar las materias');
      }
    } catch (e) {
      throw Exception('Error al cargar las materias: $e');
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
        });
      } else {
        throw Exception('No se pueden cargar los usuarios');
      }
    } catch (e) {
      throw Exception('Error al cargar los usuarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Relación Usuario-Materia'),
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
      body: userSubjects.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedUserSubjectId,
                      hint: Text('Selecciona una relación usuario-materia'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUserSubjectId = newValue!;
                          loadSelectedUserSubjectData(selectedUserSubjectId);
                        });
                      },
                      items: userSubjects
                          .map<DropdownMenuItem<String>>((userSubject) {
                        return DropdownMenuItem<String>(
                          value: userSubject['id'].toString(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                                'ID:${userSubject['id']} - ${userSubject['subject']?['subject_name'] ?? 'Materia Desconocida'} - ${userSubject['user']?['firstName'] ?? 'Usuario Desconocido'}'),
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedSubjectId,
                      hint: Text('Selecciona una materia'),
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
                      value: selectedUserId,
                      hint: Text('Selecciona un usuario'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUserId = newValue;
                        });
                      },
                      items: users.map<DropdownMenuItem<String>>((user) {
                        return DropdownMenuItem<String>(
                          value: user['id'].toString(),
                          child:
                              Text('${user['firstName']} ${user['lastName']}'),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: selectedUserSubjectId.isNotEmpty &&
                              selectedSubjectId != null &&
                              selectedUserId != null
                          ? () {
                              updateUserSubjectData();
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

  void loadSelectedUserSubjectData(String userSubjectId) {
    Map<String, dynamic>? userSubject = userSubjects.firstWhere(
      (userSubject) => userSubject['id'].toString() == userSubjectId,
      orElse: () => {},
    );

    if (userSubject != null &&
        userSubject['subject'] != null &&
        userSubject['user'] != null) {
      setState(() {
        selectedSubjectId = userSubject['subject']['id']?.toString();
        selectedUserId = userSubject['user']['id']?.toString();
      });
    }
  }

  Future<void> updateUserSubjectData() async {
    try {
      await editUserSubject(
        userSubjectId: int.parse(selectedUserSubjectId),
        subjectId: int.parse(selectedSubjectId!),
        userId: int.parse(selectedUserId!),
      );
      print("Datos actualizados con éxito");
      fetchUserSubjects();
    } catch (e) {
      print("Error al editar la relación usuario-materia: $e");
    }
  }

  Future<void> editUserSubject({
    required int userSubjectId,
    required int subjectId,
    required int userId,
  }) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/usersubject/update');
    Map data = {
      'id': userSubjectId,
      'subject': {'id': subjectId},
      'user': {'id': userId},
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Datos de userSubject actualizados con éxito");
    }
  }
}
