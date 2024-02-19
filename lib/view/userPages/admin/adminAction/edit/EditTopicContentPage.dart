import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditTopicContentPage extends StatefulWidget {
  @override
  _EditTopicContentPageState createState() => _EditTopicContentPageState();
}

class _EditTopicContentPageState extends State<EditTopicContentPage> {
  late List<Map<String, dynamic>> topicContents = [];
  late List<Map<String, dynamic>> topics = [];

  String selectedTopicContentId = '';
  String? selectedTopicId;

  TextEditingController activityController = TextEditingController();
  TextEditingController pendingHomeworkController = TextEditingController();
  TextEditingController resourcesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTopicContents();
    fetchTopics();
  }

  Future<void> fetchTopicContents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/topiccontent/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedTopicContents =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          topicContents = fetchedTopicContents;
          if (topicContents.isNotEmpty) {
            selectedTopicContentId = topicContents.first['id'].toString();
            loadSelectedTopicContentData(selectedTopicContentId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los contenidos del tema');
      }
    } catch (e) {
      print("Error al cargar los contenidos del tema: $e");
    }
  }

  Future<void> fetchTopics() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/topic/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedTopics =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          topics = fetchedTopics;
        });
      } else {
        throw Exception('No se pueden cargar los temas');
      }
    } catch (e) {
      throw Exception('Error al cargar los temas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Contenido del Tema'),
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
      body: topicContents.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedTopicContentId,
                      hint: Text('Selecciona un contenido del tema'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTopicContentId = newValue!;
                          loadSelectedTopicContentData(selectedTopicContentId);
                        });
                      },
                      items: topicContents
                          .map<DropdownMenuItem<String>>((topicContent) {
                        return DropdownMenuItem<String>(
                          value: topicContent['id'].toString(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                                'ID:${topicContent['id']} - ${topicContent['topic']?['topic_name'] ?? 'Tema Desconocido'} - Actividad: ${topicContent['activity'] ?? 'Sin actividad'}'),
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedTopicId,
                      hint: Text('Selecciona un tema'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTopicId = newValue;
                        });
                      },
                      items: topics.map<DropdownMenuItem<String>>((topic) {
                        return DropdownMenuItem<String>(
                          value: topic['id'].toString(),
                          child: Text('${topic['topic_name']}'),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: activityController,
                      decoration: InputDecoration(labelText: 'Actividad'),
                    ),
                    TextField(
                      controller: pendingHomeworkController,
                      decoration: InputDecoration(labelText: 'Deber Pendiente'),
                    ),
                    TextField(
                      controller: resourcesController,
                      decoration: InputDecoration(labelText: 'Recursos'),
                    ),
                    ElevatedButton(
                      onPressed: selectedTopicContentId.isNotEmpty &&
                              selectedTopicId != null
                          ? () {
                              updateTopicContentData();
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

  void loadSelectedTopicContentData(String topicContentId) {
    Map<String, dynamic>? topicContent = topicContents.firstWhere(
      (topicContent) => topicContent['id'].toString() == topicContentId,
      orElse: () => {},
    );

    if (topicContent != null && topicContent['topic'] != null) {
      setState(() {
        selectedTopicId = topicContent['topic']['id']?.toString();
        activityController.text = topicContent['activity'] ?? '';
        pendingHomeworkController.text = topicContent['pendingHomework'] ?? '';
        resourcesController.text = topicContent['resources'] ?? '';
      });
    }
  }

  Future<void> updateTopicContentData() async {
    try {
      await editTopicContent(
        topicContentId: int.parse(selectedTopicContentId),
        topicId: int.parse(selectedTopicId!),
        activity: activityController.text,
        pendingHomework: pendingHomeworkController.text,
        resources: resourcesController.text,
      );
      print("Datos actualizados con éxito");
      fetchTopicContents();
    } catch (e) {
      print("Error al editar el contenido del tema: $e");
    }
  }

  Future<void> editTopicContent({
    required int topicContentId,
    required int topicId,
    required String activity,
    required String pendingHomework,
    required String resources,
  }) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/topiccontent/update');
    Map data = {
      'id': topicContentId,
      'topic': {'id': topicId},
      'activity': activity,
      'pendingHomework': pendingHomework,
      'resources': resources,
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Datos de topiccontent actualizados con éxito");
    }
  }
}
