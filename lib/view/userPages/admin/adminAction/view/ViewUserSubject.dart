import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewUserSubjectPage extends StatefulWidget {
  @override
  _ViewUserSubjectPageState createState() => _ViewUserSubjectPageState();
}

class _ViewUserSubjectPageState extends State<ViewUserSubjectPage> {
  late List<Map<String, dynamic>> userSubjects = [];

  @override
  void initState() {
    super.initState();
    fetchUserSubjects();
  }

  Future<void> fetchUserSubjects() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/usersubject/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedUserSubjects =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          userSubjects = fetchedUserSubjects;
        });
      } else {
        throw Exception('No se pueden cargar las relaciones UserSubject');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones UserSubject: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Relaciones UserSubject'),
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
              'Lista de Relaciones UserSubject',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Permite el desplazamiento horizontal
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Subject Name')),
                    DataColumn(label: Text('Username')),
                  ],
                  rows: userSubjects
                      .map(
                        (userSubject) => DataRow(
                          cells: [
                            DataCell(
                              Text(userSubject['id'].toString()),
                            ),
                            DataCell(
                              Text(userSubject['subject']?['subject_name']
                                      .toString() ??
                                  'N/A'),
                            ),
                            DataCell(
                              Text(
                                  userSubject['user']?['username'].toString() ??
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
