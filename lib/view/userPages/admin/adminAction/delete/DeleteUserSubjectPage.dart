import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteUserSubjectPage extends StatefulWidget {
  @override
  _DeleteUserSubjectPageState createState() => _DeleteUserSubjectPageState();
}

class _DeleteUserSubjectPageState extends State<DeleteUserSubjectPage> {
  late List<Map<String, dynamic>> userSubjects = [];
  String selectedUserSubjectId = '';

  @override
  void initState() {
    super.initState();
    fetchUserSubjects();
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
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones UserSubject');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones UserSubject: $e');
    }
  }

  void _deleteUserSubject() async {
    if (selectedUserSubjectId.isNotEmpty) {
      try {
        var url = Uri.parse(
            'http://10.0.2.2:8080/api/usersubject/$selectedUserSubjectId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación UserSubject eliminada con éxito'),
            ),
          );
          fetchUserSubjects();
        } else {
          print(
              'Error al eliminar la relación UserSubject. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar la relación UserSubject: $e");
      }
    } else {
      print('Selecciona una relación UserSubject');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Relación UserSubject'),
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
                value: selectedUserSubjectId,
                hint: Text('Selecciona una relación UserSubject'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUserSubjectId = newValue!;
                  });
                },
                items:
                    userSubjects.map<DropdownMenuItem<String>>((userSubject) {
                  return DropdownMenuItem<String>(
                    value: userSubject['id'].toString(),
                    child: Text(
                      '${userSubject['id']}- Usuario ${userSubject['user']?['username'] ?? 'N/A'} - Tema ${userSubject['subject']?['subject_name'] ?? 'N/A'}',
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteUserSubject();
                },
                child: Text('Borrar Relación UserSubject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
