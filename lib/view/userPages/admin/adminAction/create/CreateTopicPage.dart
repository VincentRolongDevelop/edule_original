import 'package:flutter/material.dart';
import '../../../admin/adminPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateTopicPage extends StatefulWidget {
  const CreateTopicPage({Key? key}) : super(key: key);

  @override
  _CreateTopicPageState createState() => _CreateTopicPageState();
}

class _CreateTopicPageState extends State<CreateTopicPage> {
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedSubjectId;

  List<Map<String, dynamic>> subjects = [];

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

  Future<http.Response> addTopic(
      String topicName, String description, int subjectId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/topic/save');
    Map data = {
      'topic_name': topicName,
      'description': description,
      'subject': {'id': subjectId},
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
    return response;
  }

  void loadSubjects() async {
    try {
      final subjectsList = await getSubjects();
      setState(() {
        subjects = subjectsList;
      });
    } catch (e) {
      print("Error al cargar las asignaturas: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  void _createTopic() async {
    String topicName = _topicNameController.text;
    String description = _descriptionController.text;

    if (topicName.isNotEmpty &&
        description.isNotEmpty &&
        selectedSubjectId != null) {
      try {
        var response = await addTopic(
            topicName, description, int.parse(selectedSubjectId!));

        print("Response: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Se creó un nuevo tema'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          print('Error al crear el tópico. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al crear el tópico: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Tema'),
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
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Crear Tema", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _topicNameController,
                    decoration: InputDecoration(
                      labelText: "Nombre del tema",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<String>(
                    value: selectedSubjectId,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    hint: Text("Selecciona una asignatura"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubjectId = newValue;
                      });
                    },
                    items: subjects.map<DropdownMenuItem<String>>((subject) {
                      return DropdownMenuItem<String>(
                        value: subject['id'].toString(),
                        child: Text(subject['subject_name'].toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createTopic,
            child: Text("Crear Tópico", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
