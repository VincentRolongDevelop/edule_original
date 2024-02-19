import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditCyclePage extends StatefulWidget {
  @override
  _EditCyclePageState createState() => _EditCyclePageState();
}

class _EditCyclePageState extends State<EditCyclePage> {
  late List<Map<String, dynamic>> cycles;
  late List<Map<String, dynamic>> days;
  String selectedCycleId = '';
  String selectedDayId = '';

  TextEditingController cycleNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cycles = [];
    days = [];
    fetchCycles();
    fetchDays();
  }

  Future<void> fetchCycles() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/cycle/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          cycles = List<Map<String, dynamic>>.from(data);
          if (cycles.isNotEmpty) {
            selectedCycleId = cycles.first['id'].toString();
            loadSelectedCycleData(selectedCycleId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los ciclos');
      }
    } catch (e) {
      print("Error al cargar los ciclos: $e");
    }
  }

  Future<void> fetchDays() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/day/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedDays =
            List<Map<String, dynamic>>.from(data);
        fetchedDays.sort((a, b) => a['day_number'].compareTo(b['day_number']));
        setState(() {
          days = fetchedDays;
          if (days.isNotEmpty) {
            selectedDayId = days.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los días');
      }
    } catch (e) {
      print("Error al cargar los días: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Ciclo'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedCycleId,
                hint: Text('Selecciona un ciclo'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCycleId = newValue!;
                    loadSelectedCycleData(selectedCycleId);
                  });
                },
                items: cycles.map<DropdownMenuItem<String>>((cycle) {
                  return DropdownMenuItem<String>(
                    value: cycle['id'].toString(),
                    child: Text('ID Ciclo ${cycle['id']}'),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedDayId,
                hint: Text('Selecciona un día'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDayId = newValue!;
                  });
                },
                items: days.map<DropdownMenuItem<String>>((day) {
                  return DropdownMenuItem<String>(
                    value: day['id'].toString(),
                    child: Text('Día ${day['day_number']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: cycleNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Número de Ciclo'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateCycleData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedCycleData(String cycleId) {
    Map<String, dynamic> cycle =
        cycles.firstWhere((cycle) => cycle['id'].toString() == cycleId);
    setState(() {
      cycleNumberController.text = cycle['cycle_number'].toString();
    });
  }

  Future<void> updateCycleData() async {
    int cycleId = int.parse(selectedCycleId);
    int cycleNumber = int.parse(cycleNumberController.text);
    int dayId = int.parse(selectedDayId);

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/cycle/update');
      Map data = {
        'id': cycleId,
        'cycle_number': cycleNumber,
        'day': {"id": dayId},
      };

      var body = json.encode(data);

      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Es este" + body);
      print("${response.statusCode}");
      print("${response.body}");

      fetchCycles(); // Actualizar la lista de ciclos
    } catch (e) {
      print("Error al editar el ciclo: $e");
    }
  }
}
