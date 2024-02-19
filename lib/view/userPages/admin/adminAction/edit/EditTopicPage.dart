import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditTopicPage extends StatefulWidget {
  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  late List<Map<String, dynamic>> topics = [];
  String selectedTopicId = '';

  TextEditingController topicNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<List<Map<String, dynamic>>> getTopicsBySubject(int subjectId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/topic/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> topics = List<Map<String, dynamic>>.from(data);
      return topics;
    } else {
      throw Exception('No se pueden cargar los temas de la materia');
    }
  }

  Future<http.Response> editTopic(
    int topicId,
    String topicNameController,
    String descriptionController,
    int subjectId,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/topic/update');
    Map data = {
      'id': topicId,
      'topic_name': topicNameController,
      'description': descriptionController,
      'subject': {'id': subjectId},
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

  Future<void> fetchTopics() async {
    try {
      List<Map<String, dynamic>> fetchedTopics = await getTopicsBySubject(
          1); // Cambia el 1 por el ID de la materia deseada
      setState(() {
        topics = fetchedTopics;
        if (topics.isNotEmpty) {
          selectedTopicId = topics.first['id'].toString();
          loadSelectedTopicData(selectedTopicId);
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
      body: topics.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedTopicId,
                      hint: Text('Selecciona un tema'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTopicId = newValue!;
                          loadSelectedTopicData(selectedTopicId);
                        });
                      },
                      items: topics.map<DropdownMenuItem<String>>((topic) {
                        return DropdownMenuItem<String>(
                          value: topic['id'].toString(),
                          child: Text('${topic['topic_name']}'),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: topicNameController,
                      decoration: InputDecoration(labelText: 'Nombre del Tema'),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          InputDecoration(labelText: 'Descripción del Tema'),
                    ),
                    ElevatedButton(
                      onPressed: selectedTopicId.isNotEmpty &&
                              topicNameController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty
                          ? () {
                              updateTopicData();
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

  void loadSelectedTopicData(String topicId) {
    Map<String, dynamic> topic =
        topics.firstWhere((topic) => topic['id'].toString() == topicId);
    setState(() {
      topicNameController.text = topic['topic_name'];
      descriptionController.text = topic['description'];
    });
  }

  Future<void> updateTopicData() async {
    String topicName = topicNameController.text;
    String topicDescription = descriptionController.text;

    try {
      await editTopic(
        int.parse(selectedTopicId),
        topicName,
        topicDescription,
        1, // Cambia el 1 por el ID de la materia deseada
      );
      fetchTopics();
    } catch (e) {
      print("Error al editar el tema: $e");
    }
  }
}
