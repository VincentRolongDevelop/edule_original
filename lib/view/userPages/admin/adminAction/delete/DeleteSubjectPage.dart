import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteSubjectPage extends StatefulWidget {
  @override
  _DeleteSubjectPageState createState() => _DeleteSubjectPageState();
}

class _DeleteSubjectPageState extends State<DeleteSubjectPage> {
  late List<Map<String, dynamic>> subjects = [];
  String selectedSubjectId = '';

  @override
  void initState() {
    super.initState();
    fetchSubjects();
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
        throw Exception('No se pueden cargar los subjects');
      }
    } catch (e) {
      throw Exception('Error al cargar los subjects: $e');
    }
  }

  void _deleteSubject() async {
    if (selectedSubjectId.isNotEmpty) {
      try {
        var url =
            Uri.parse('http://10.0.2.2:8080/api/subject/$selectedSubjectId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Subject eliminado con éxito'),
            ),
          );
          fetchSubjects();
        } else {
          print('Error al eliminar el subject. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el subject: $e");
      }
    } else {
      print('Selecciona un subject');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Asignatura'),
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
                    child: Text('${subject['subject_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteSubject();
                },
                child: Text('Borrar Asignatura'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
