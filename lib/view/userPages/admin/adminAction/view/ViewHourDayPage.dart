import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewHourDayPage extends StatefulWidget {
  @override
  _ViewHourDayPageState createState() => _ViewHourDayPageState();
}

class _ViewHourDayPageState extends State<ViewHourDayPage> {
  late List<Map<String, dynamic>> hourDays = [];

  @override
  void initState() {
    super.initState();
    fetchHourDays();
  }

  Future<void> fetchHourDays() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/hourday/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedHourDays =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          hourDays = fetchedHourDays;
        });
      } else {
        throw Exception('No se pueden cargar las relaciones HourDay');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones HourDay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Relaciones HourDay'),
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
              'Lista de Relaciones HourDay',
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
                    DataColumn(label: Text('Hora')),
                    DataColumn(label: Text('Día')),
                  ],
                  rows: hourDays
                      .map(
                        (hourDay) => DataRow(
                          cells: [
                            DataCell(
                              Text(hourDay['id'].toString()),
                            ),
                            DataCell(
                              Text(
                                  hourDay['hour']?['hour'].toString() ?? 'N/A'),
                            ),
                            DataCell(
                              Text(hourDay['day']?['day_number'].toString() ??
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
