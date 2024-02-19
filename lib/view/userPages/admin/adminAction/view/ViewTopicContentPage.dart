import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewTopicContentPage extends StatefulWidget {
  @override
  _ViewTopicContentPageState createState() => _ViewTopicContentPageState();
}

class _ViewTopicContentPageState extends State<ViewTopicContentPage> {
  late List<Map<String, dynamic>> topicContents = [];

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
        });
      } else {
        throw Exception('No se pueden cargar los contenidos del tema');
      }
    } catch (e) {
      throw Exception('Error al cargar los contenidos del tema: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Contenidos del Tema'),
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
              'Lista de Contenidos del Tema',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Tema')),
                      DataColumn(label: Text('Actividad')),
                      DataColumn(label: Text('Tarea Pendiente')),
                      DataColumn(label: Text('Recursos')),
                    ],
                    rows: topicContents
                        .map(
                          (topicContent) => DataRow(
                            cells: [
                              DataCell(
                                Text(topicContent['id'].toString()),
                              ),
                              DataCell(
                                Text(topicContent['topic']?['topic_name']
                                        .toString() ??
                                    'N/A'),
                              ),
                              DataCell(
                                Text(topicContent['activity'].toString()),
                              ),
                              DataCell(
                                Text(
                                    topicContent['pendingHomework'].toString()),
                              ),
                              DataCell(
                                Text(topicContent['resources'].toString()),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
