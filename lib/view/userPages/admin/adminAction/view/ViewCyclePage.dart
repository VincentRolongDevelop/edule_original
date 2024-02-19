import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class ViewCyclePage extends StatefulWidget {
  @override
  _ViewCyclePageState createState() => _ViewCyclePageState();
}

class _ViewCyclePageState extends State<ViewCyclePage> {
  late List<Map<String, dynamic>> cycles = [];

  @override
  void initState() {
    super.initState();
    fetchCycles();
  }

  Future<void> fetchCycles() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/cycle/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedCycles =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          cycles = fetchedCycles;
        });
      } else {
        throw Exception('No se pueden cargar los ciclos');
      }
    } catch (e) {
      throw Exception('Error al cargar los ciclos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Ciclos'),
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
              'Lista de Ciclos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: cycles.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID del Ciclo')),
                            DataColumn(label: Text('Número del Ciclo')),
                            DataColumn(label: Text('Número del Día')),
                            // Añade más DataColumn según sea necesario
                          ],
                          rows: cycles
                              .map(
                                (cycle) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(cycle['id'].toString()),
                                    ),
                                    DataCell(
                                      Text(cycle['cycle_number'].toString()),
                                    ),
                                    DataCell(
                                      Text(cycle['day']?['day_number']
                                              .toString() ??
                                          'N/A'),
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
                      child: Text('No hay ciclos para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
