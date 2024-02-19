import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewHourPage extends StatefulWidget {
  @override
  _ViewHourPageState createState() => _ViewHourPageState();
}

class _ViewHourPageState extends State<ViewHourPage> {
  late List<Map<String, dynamic>> hours = [];

  @override
  void initState() {
    super.initState();
    fetchHours();
  }

  Future<void> fetchHours() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/hour/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedHours =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          hours = fetchedHours;
        });
      } else {
        throw Exception('No se pueden cargar las horas');
      }
    } catch (e) {
      throw Exception('Error al cargar las horas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Horas'),
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
              'Lista de Horas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: hours.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID de la Hora')),
                            DataColumn(label: Text('Hora')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: hours
                              .map(
                                (hour) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(hour['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(hour['hour'].toString()),
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
                      child: Text('No hay horas para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
