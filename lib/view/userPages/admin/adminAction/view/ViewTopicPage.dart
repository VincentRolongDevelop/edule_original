import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewTopicPage extends StatefulWidget {
  @override
  _ViewTopicPageState createState() => _ViewTopicPageState();
}

class _ViewTopicPageState extends State<ViewTopicPage> {
  late List<Map<String, dynamic>> topics = [];

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
        });
      } else {
        throw Exception('No se pueden cargar los temas (topics)');
      }
    } catch (e) {
      throw Exception('Error al cargar los temas (topics): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Temas'),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Lista de Temas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: topics.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID del Tema')),
                            DataColumn(label: Text('Nombre del Tema')),
                            DataColumn(label: Text('Actividad')),
                            DataColumn(label: Text('Tarea Pendiente')),
                            DataColumn(label: Text('Recursos')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: topics
                              .map(
                                (topic) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(topic['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(topic['topic_name'].toString()),
                                    ),
                                    DataCell(
                                      Text(topic['activity'].toString()),
                                    ),
                                    DataCell(
                                      Text(topic['pendingHomework'].toString()),
                                    ),
                                    DataCell(
                                      Text(topic['resources'].toString()),
                                    ),
                                    // Añade más DataCell según sea necesario
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay temas para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
