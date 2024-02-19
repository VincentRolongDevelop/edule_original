import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';
import 'dart:convert';

class CreateHourDayPage extends StatefulWidget {
  @override
  _CreateHourDayPageState createState() => _CreateHourDayPageState();
}

class _CreateHourDayPageState extends State<CreateHourDayPage> {
  late List<Map<String, dynamic>> days;
  late List<Map<String, dynamic>> hours;
  String? selectedDayId;
  String? selectedHourId;

  TextEditingController dayNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDays();
    fetchHours();
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
          if (days.isNotEmpty) {
            selectedDayId = days.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los días');
      }
    } catch (e) {
      throw Exception('Error al cargar los días: $e');
    }
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
          if (hours.isNotEmpty) {
            selectedHourId = hours.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar las horas');
      }
    } catch (e) {
      throw Exception('Error al cargar las horas: $e');
    }
  }

  void _createHourDay() async {
    if (selectedDayId != null && selectedHourId != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/hourday/save');
        Map data = {
          'hour': {"id": selectedHourId},
          'day': {"id": selectedDayId}
        };

        var body = json.encode(data);

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        print("Es este" + body);
        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 201) {
          // Si la respuesta es exitosa (código 201), mostrar el SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación HourDay creada con éxito'),
            ),
          );
        } else {
          // Manejar otros casos según tus necesidades
          print(
              'Error al crear la relación HourDay. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al crear la relación HourDay: $e");
      }
    } else {
      print('Selecciona un día y una hora');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Relación HourDay'),
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
              DropdownButton<String>(
                value: selectedHourId,
                hint: Text('Selecciona una hora'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHourId = newValue!;
                  });
                },
                items: hours.map<DropdownMenuItem<String>>((hour) {
                  return DropdownMenuItem<String>(
                    value: hour['id'].toString(),
                    child: Text('Hora ${hour['hour']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _createHourDay,
                child: Text('Crear Relación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
