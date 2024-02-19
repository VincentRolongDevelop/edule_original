import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteTopicContentPage extends StatefulWidget {
  @override
  _DeleteTopicContentPageState createState() => _DeleteTopicContentPageState();
}

class _DeleteTopicContentPageState extends State<DeleteTopicContentPage> {
  late List<Map<String, dynamic>> topicContents = [];
  String selectedTopicContentId = '';

  @override
  void initState() {
    super.initState();
    fetchTopicContents();
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
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones TopicContent');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones TopicContent: $e');
    }
  }

  void _deleteTopicContent() async {
    if (selectedTopicContentId.isNotEmpty) {
      try {
        var url = Uri.parse(
            'http://10.0.2.2:8080/api/topiccontent/$selectedTopicContentId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación TopicContent eliminada con éxito'),
            ),
          );
          fetchTopicContents();
        } else {
          print(
              'Error al eliminar la relación TopicContent. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar la relación TopicContent: $e");
      }
    } else {
      print('Selecciona una relación TopicContent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Relación TopicContent'),
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
                value: selectedTopicContentId,
                hint: Text('Selecciona una relación TopicContent'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTopicContentId = newValue!;
                  });
                },
                items:
                    topicContents.map<DropdownMenuItem<String>>((topicContent) {
                  return DropdownMenuItem<String>(
                    value: topicContent['id'].toString(),
                    child: Text(
                      'ID ${topicContent['id']} - Tema ${topicContent['topic']?['topic_name'] ?? 'N/A'} - Actividad ${topicContent['activity'] ?? 'N/A'}',
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteTopicContent();
                },
                child: Text('Borrar Relación TopicContent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
