import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteTopicPage extends StatefulWidget {
  @override
  _DeleteTopicPageState createState() => _DeleteTopicPageState();
}

class _DeleteTopicPageState extends State<DeleteTopicPage> {
  late List<Map<String, dynamic>> topics = [];
  String selectedTopicId = '';

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
        throw Exception('No se pueden cargar los temas');
      }
    } catch (e) {
      throw Exception('Error al cargar los temas: $e');
    }
  }

  void _deleteTopic() async {
    if (selectedTopicId.isNotEmpty) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/topic/$selectedTopicId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tema eliminado con éxito'),
            ),
          );
          fetchTopics();
        } else {
          print('Error al eliminar el tema. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el tema: $e");
      }
    } else {
      print('Selecciona un tema');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Tema'),
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
                    child: Text('${topic['topic_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteTopic();
                },
                child: Text('Borrar Tema'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
