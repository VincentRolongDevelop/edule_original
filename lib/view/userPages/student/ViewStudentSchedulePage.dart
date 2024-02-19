import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../loginUserPage.dart';

class ViewStudentSchedulePage extends StatefulWidget {
  final Map<String, dynamic> loggedInUser;

  ViewStudentSchedulePage({required this.loggedInUser});

  @override
  _ViewStudentSchedulePageState createState() =>
      _ViewStudentSchedulePageState();
}

class _ViewStudentSchedulePageState extends State<ViewStudentSchedulePage> {
  late List<dynamic> schedule = [];

  @override
  void initState() {
    super.initState();
    fetchStudentSchedule();
  }

  Future<void> fetchStudentSchedule() async {
    try {
      String studentUsername = widget.loggedInUser['username'];
      var url = Uri.parse(
          'http://10.0.2.2:8080/api/schedule/student/$studentUsername');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<dynamic> fetchedSchedule = List<dynamic>.from(data);
        setState(() {
          schedule = fetchedSchedule;
        });
      } else {
        throw Exception('No se pueden cargar el horario del estudiante');
      }
    } catch (e) {
      throw Exception('Error al cargar el horario del estudiante: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección a realizar'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(title: 'Iniciar Sesión')),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Horario del Estudiante:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Usuario: ${widget.loggedInUser['username']}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: schedule.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Dia')),
                            DataColumn(label: Text('Hora')),
                            DataColumn(label: Text('Materia')),
                            DataColumn(label: Text('Profesor')),
                          ],
                          rows: schedule
                              .map((entry) => DataRow(
                                    cells: [
                                      DataCell(Text(
                                          entry.length > 0 ? entry[0] : 'N/A')),
                                      DataCell(Text(
                                          entry.length > 1 ? entry[1] : 'N/A')),
                                      DataCell(Text(
                                          entry.length > 2 ? entry[2] : 'N/A')),
                                      DataCell(Text(
                                          entry.length > 3 ? entry[3] : 'N/A')),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay horario para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
