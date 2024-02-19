import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class ViewParentsByClassroomPage extends StatefulWidget {
  @override
  _ViewParentsByClassroomPageState createState() =>
      _ViewParentsByClassroomPageState();
}

class _ViewParentsByClassroomPageState
    extends State<ViewParentsByClassroomPage> {
  List<String> classrooms = [];
  String selectedClassroom = "";
  List<Map<String, dynamic>> parents = [];

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> fetchedClassrooms = List<String>.from(
            data.map((classroom) => classroom['classroom_name']));

        if (fetchedClassrooms.isNotEmpty) {
          setState(() {
            classrooms = fetchedClassrooms;
            selectedClassroom = fetchedClassrooms[0];
          });
          fetchParentsByClassroom(selectedClassroom);
        } else {
          throw Exception('No se encontraron salones');
        }
      } else {
        throw Exception('No se pueden cargar los salones');
      }
    } catch (e) {
      throw Exception('Error al cargar los salones: $e');
    }
  }

  Future<void> fetchParentsByClassroom(String classroomName) async {
    try {
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/parent/parents/byClassroom/$classroomName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedParents = data.map((parent) {
          return {
            'firstName': parent[0],
            'lastName': parent[1],
          };
        }).toList();

        setState(() {
          parents = fetchedParents;
        });
      } else {
        setState(() {
          parents = []; // Vaciar la lista si no hay padres
        });
        throw Exception('No se pueden cargar los padres del salón');
      }
    } catch (e) {
      throw Exception('Error al cargar los padres del salón: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Padres por Salón'),
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
            if (classrooms.isNotEmpty)
              DropdownButton<String>(
                value: selectedClassroom,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClassroom = newValue!;
                  });
                  fetchParentsByClassroom(selectedClassroom);
                },
                items: classrooms.map((String classroom) {
                  return DropdownMenuItem<String>(
                    value: classroom,
                    child: Text(classroom),
                  );
                }).toList(),
              )
            else
              Text('No se encontraron salones'),
            SizedBox(height: 16),
            Text(
              'Padres del Salón: $selectedClassroom',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (parents.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Apellido')),
                    ],
                    rows: parents
                        .map(
                          (parent) => DataRow(
                            cells: [
                              DataCell(
                                Text(parent['firstName']),
                              ),
                              DataCell(
                                Text(parent['lastName']),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            else
              Text('No hay padres en este salón'),
          ],
        ),
      ),
    );
  }
}
