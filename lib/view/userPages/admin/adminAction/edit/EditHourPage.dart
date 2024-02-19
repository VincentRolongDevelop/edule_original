import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditHourPage extends StatefulWidget {
  @override
  _EditHourPageState createState() => _EditHourPageState();
}

class _EditHourPageState extends State<EditHourPage> {
  late List<Map<String, dynamic>> hours;
  String selectedHourId = '';

  TextEditingController newHourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hours = [];
    fetchHours();
  }

  Future<void> fetchHours() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/hour/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          hours = List<Map<String, dynamic>>.from(data);
          if (hours.isNotEmpty) {
            selectedHourId = hours.first['id'].toString();
            loadSelectedHourData(selectedHourId);
          }
        });
      } else {
        throw Exception('No se pueden cargar las horas');
      }
    } catch (e) {
      print("Error al cargar las horas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Hora'),
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
                value: selectedHourId,
                hint: Text('Selecciona una hora'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHourId = newValue!;
                    loadSelectedHourData(selectedHourId);
                  });
                },
                items: hours.map<DropdownMenuItem<String>>((hour) {
                  return DropdownMenuItem<String>(
                    value: hour['id'].toString(),
                    child: Text('${hour['id']} - ${hour['hour']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: newHourController,
                decoration: InputDecoration(labelText: 'Nueva Hora'),
              ),
              ElevatedButton(
                onPressed: () {
                  editHour();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedHourData(String hourId) {
    Map<String, dynamic> hour =
        hours.firstWhere((hour) => hour['id'].toString() == hourId);
    setState(() {
      newHourController.text = hour['hour'];
    });
  }

  Future<void> editHour() async {
    String newHour = newHourController.text;

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/hour/update');
      Map data = {
        'id': int.parse(selectedHourId),
        'hour': newHour,
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

      fetchHours();
    } catch (e) {
      print("Error al editar la hora: $e");
    }
  }
}
