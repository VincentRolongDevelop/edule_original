import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteStudentPage extends StatefulWidget {
  @override
  _DeleteStudentPageState createState() => _DeleteStudentPageState();
}

class _DeleteStudentPageState extends State<DeleteStudentPage> {
  late List<Map<String, dynamic>> students = [];
  String selectedStudentId = '';

  Future<List<Map<String, dynamic>>> getStudents() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/student/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedStudents =
          List<Map<String, dynamic>>.from(data);
      return fetchedStudents;
    } else {
      throw Exception('No se pueden cargar los estudiantes');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/student/$studentId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estudiante eliminado'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      throw Exception('Error al eliminar el estudiante');
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents().then((fetchedStudents) {
      setState(() {
        students = fetchedStudents;
        if (students.isNotEmpty) {
          selectedStudentId = students.first['id'].toString();
        }
      });
    }).catchError((error) {
      print("Error al cargar los estudiantes: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Estudiantes'),
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
                value: selectedStudentId,
                hint: Text('Selecciona un estudiante'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStudentId = newValue!;
                  });
                },
                items: students.map<DropdownMenuItem<String>>((student) {
                  return DropdownMenuItem<String>(
                    value: student['id'].toString(),
                    child:
                        Text('${student['firstName']} ${student['lastName']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteStudent(selectedStudentId);
                },
                child: Text('Borrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
