import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewDayPage extends StatefulWidget {
  @override
  _ViewDayPageState createState() => _ViewDayPageState();
}

class _ViewDayPageState extends State<ViewDayPage> {
  late List<Map<String, dynamic>> days = [];

  @override
  void initState() {
    super.initState();
    fetchDays();
  }

  Future<void> fetchDays() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/day/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedDays =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          days = fetchedDays;
        });
      } else {
        throw Exception('No se pueden cargar los días');
      }
    } catch (e) {
      throw Exception('Error al cargar los días: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Días'),
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
              'Lista de Días',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: days.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID del Día')),
                            DataColumn(label: Text('Número del Día')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: days
                              .map(
                                (day) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(day['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(day['day_number'].toString()),
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
                      child: Text('No hay días para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
