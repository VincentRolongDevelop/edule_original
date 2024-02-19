import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';

class CreateCyclePage extends StatefulWidget {
  @override
  _CreateCyclePageState createState() => _CreateCyclePageState();
}

class _CreateCyclePageState extends State<CreateCyclePage> {
  final TextEditingController _cycleNumberController = TextEditingController();
  String? selectedDayId;

  List<Map<String, dynamic>> days = [];

  Future<List<Map<String, dynamic>>> getDays() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/day/all');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> daysJson = json.decode(response.body);
      List<Map<String, dynamic>> days =
          daysJson.map((day) => Map<String, dynamic>.from(day)).toList();

      return days;
    } else {
      throw Exception('Failed to load days');
    }
  }

  @override
  void initState() {
    super.initState();
    loadDays();
  }

  void loadDays() async {
    try {
      final daysList = await getDays();
      setState(() {
        days = daysList;
      });
    } catch (e) {
      print("Error al cargar los días: $e");
    }
  }

  Future<void> _createCycle() async {
    try {
      int cycleNumber = int.parse(_cycleNumberController.text);

      if (selectedDayId != null) {
        var url = Uri.parse('http://10.0.2.2:8080/api/cycle/save');
        Map data = {
          'cycle_number': cycleNumber,
          'day': {'id': int.parse(selectedDayId!)},
        };

        var body = json.encode(data);

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        print("Response: ${response.statusCode}");
        print("Response Body: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ciclo creado con éxito')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        print('Selecciona un día');
      }
    } catch (e) {
      print('Error al crear el ciclo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el ciclo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Ciclo'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cycleNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Número de Ciclo'),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: selectedDayId,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
              hint: Text("Selecciona un día"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDayId = newValue;
                });
              },
              items: days.map<DropdownMenuItem<String>>((day) {
                return DropdownMenuItem<String>(
                  value: day['id'].toString(),
                  child: Text("Día ${day['day_number'].toString()}"),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createCycle();
              },
              child: Text('Crear Ciclo'),
            ),
          ],
        ),
      ),
    );
  }
}
