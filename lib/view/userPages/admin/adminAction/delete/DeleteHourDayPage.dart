import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteHourDayPage extends StatefulWidget {
  @override
  _DeleteHourDayPageState createState() => _DeleteHourDayPageState();
}

class _DeleteHourDayPageState extends State<DeleteHourDayPage> {
  late List<Map<String, dynamic>> hourDays = [];
  String selectedHourDayId = '';

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
          if (hourDays.isNotEmpty) {
            selectedHourDayId = hourDays.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones HourDay');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones HourDay: $e');
    }
  }

  void _deleteHourDay() async {
    if (selectedHourDayId.isNotEmpty) {
      try {
        var url =
            Uri.parse('http://10.0.2.2:8080/api/hourday/$selectedHourDayId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación HourDay eliminada con éxito'),
            ),
          );
          fetchHourDays();
        } else {
          print(
              'Error al eliminar la relación HourDay. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar la relación HourDay: $e");
      }
    } else {
      print('Selecciona una relación HourDay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Relación HourDay'),
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
                value: selectedHourDayId,
                hint: Text('Selecciona una relación HourDay'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHourDayId = newValue!;
                  });
                },
                items: hourDays.map<DropdownMenuItem<String>>((hourDay) {
                  return DropdownMenuItem<String>(
                    value: hourDay['id'].toString(),
                    child: Text(
                        'ID ${hourDay['id']} - Hora ${hourDay['hour']?['hour'] ?? 'N/A'} - Día ${hourDay['day']?['day_number'] ?? 'N/A'}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteHourDay();
                },
                child: Text('Borrar Relación HourDay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
