import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditSubjectPage extends StatefulWidget {
  @override
  _EditSubjectPageState createState() => _EditSubjectPageState();
}

class _EditSubjectPageState extends State<EditSubjectPage> {
  late List<Map<String, dynamic>> subjects = [];
  String selectedSubjectId = '';

  TextEditingController subjectNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<List<Map<String, dynamic>>> getSubjects() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/subject/all');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> subjectsJson = json.decode(response.body);
      List<Map<String, dynamic>> subjects = subjectsJson
          .map((subject) => Map<String, dynamic>.from(subject))
          .toList();

      return subjects;
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  Future<http.Response> editSubject(
    int subjectId,
    String subjectNameController,
    String descriptionController,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/subject/update');
    Map data = {
      'id': subjectId,
      'subject_name': subjectNameController,
      'description': descriptionController,
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("Es este" + body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<void> fetchSubjects() async {
    try {
      List<Map<String, dynamic>> fetchedSubjects = await getSubjects();
      setState(() {
        subjects = fetchedSubjects;
        if (subjects.isNotEmpty) {
          selectedSubjectId = subjects.first['id'].toString();
          loadSelectedSubjectData(selectedSubjectId);
        }
      });
    } catch (e) {
      print("Error al cargar los temas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tema'),
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
                hint: Text('Selecciona un tema'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubjectId = newValue!;
                    loadSelectedSubjectData(selectedSubjectId);
                  });
                },
                items: subjects.map<DropdownMenuItem<String>>((subject) {
                  return DropdownMenuItem<String>(
                    value: subject['id'].toString(),
                    child: Text('${subject['subject_name']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: subjectNameController,
                decoration: InputDecoration(labelText: 'Nombre del Tema'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateSubjectData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedSubjectData(String subjectId) {
    Map<String, dynamic> subject =
        subjects.firstWhere((subject) => subject['id'].toString() == subjectId);
    setState(() {
      subjectNameController.text = subject['subject_name'];
      descriptionController.text = subject['description'];
    });
  }

  Future<void> updateSubjectData() async {
    String subjectName = subjectNameController.text;
    String description = descriptionController.text;

    try {
      await editSubject(
        int.parse(selectedSubjectId), // Convertir a entero
        subjectName,
        description,
      );
      fetchSubjects();
    } catch (e) {
      print("Error al editar el tema: $e");
    }
  }
}
