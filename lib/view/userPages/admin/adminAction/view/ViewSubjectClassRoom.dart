import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewSubjectClassroomPage extends StatefulWidget {
  @override
  _ViewSubjectClassroomPageState createState() =>
      _ViewSubjectClassroomPageState();
}

class _ViewSubjectClassroomPageState extends State<ViewSubjectClassroomPage> {
  late List<Map<String, dynamic>> subjectClassrooms = [];

  @override
  void initState() {
    super.initState();
    fetchSubjectClassrooms();
  }

  Future<void> fetchSubjectClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjectClassrooms =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          subjectClassrooms = fetchedSubjectClassrooms;
        });
      } else {
        throw Exception('No se pueden cargar las relaciones SubjectClassroom');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones SubjectClassroom: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Relaciones SubjectClassroom'),
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
              'Lista de Relaciones SubjectClassroom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Subject')),
                    DataColumn(label: Text('Classroom')),
                  ],
                  rows: subjectClassrooms
                      .map(
                        (subjectClassroom) => DataRow(
                          cells: [
                            DataCell(
                              Text(subjectClassroom['id'].toString()),
                            ),
                            DataCell(
                              Text(subjectClassroom['subject']?['subject_name']
                                      .toString() ??
                                  'N/A'),
                            ),
                            DataCell(
                              Text(subjectClassroom['classroom']
                                          ?['classroom_name']
                                      .toString() ??
                                  'N/A'),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
