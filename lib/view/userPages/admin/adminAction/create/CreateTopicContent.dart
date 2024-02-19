import 'package:flutter/material.dart';
import '../../../admin/adminPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTopicContentPage extends StatefulWidget {
  @override
  _CreateTopicContentPageState createState() => _CreateTopicContentPageState();
}

class _CreateTopicContentPageState extends State<CreateTopicContentPage> {
  late List<Map<String, dynamic>> topics;
  String? selectedTopicId;

  TextEditingController topicNameController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  TextEditingController pendingHomeworkController = TextEditingController();
  TextEditingController resourcesController = TextEditingController();

  Future<List<Map<String, dynamic>>> getTopics() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/topic/all');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> topicsJson = json.decode(response.body);
      List<Map<String, dynamic>> topics =
          topicsJson.map((topic) => Map<String, dynamic>.from(topic)).toList();

      return topics;
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTopics();
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
          if (topics.isNotEmpty) {
            selectedTopicId = topics.first['id'].toString();
          }
        });
      } else {
        throw Exception('Failed to fetch topics');
      }
    } catch (e) {
      throw Exception('Error fetching topics: $e');
    }
  }

  void _createTopicContent() async {
    if (selectedTopicId != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/topiccontent/save');
        Map data = {
          'topic': {"id": int.parse(selectedTopicId!)},
          'activity': activityController.text,
          'pendingHomework': pendingHomeworkController.text,
          'resources': resourcesController.text,
        };

        var body = json.encode(data);

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        print("Request Body: $body");
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contenido del tema creado con éxito'),
            ),
          );
        } else {
          print(
              'Error creating topic content. Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print("Error creating topic content: $e");
      }
    } else {
      print('Selecciona un tema');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Contenido del Tema'),
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
                value: selectedTopicId,
                hint: Text('Selecciona un tema'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTopicId = newValue!;
                  });
                },
                items: topics.map<DropdownMenuItem<String>>((topic) {
                  return DropdownMenuItem<String>(
                    value: topic['id'].toString(),
                    child: Text('Tema ${topic['topic_name']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: activityController,
                decoration: InputDecoration(labelText: 'Actividad'),
              ),
              TextFormField(
                controller: pendingHomeworkController,
                decoration: InputDecoration(labelText: 'Tarea Pendiente'),
              ),
              TextFormField(
                controller: resourcesController,
                decoration: InputDecoration(labelText: 'Recursos'),
              ),
              ElevatedButton(
                onPressed: _createTopicContent,
                child: Text('Crear Contenido del Tema'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
