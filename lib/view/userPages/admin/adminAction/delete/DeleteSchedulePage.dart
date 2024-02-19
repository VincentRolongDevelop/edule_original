import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteSchedulePage extends StatefulWidget {
  @override
  _DeleteSchedulePageState createState() => _DeleteSchedulePageState();
}

class _DeleteSchedulePageState extends State<DeleteSchedulePage> {
  late List<Map<String, dynamic>> schedules = [];
  String selectedScheduleId = '';

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/schedule/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSchedules =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          schedules = fetchedSchedules;
          if (schedules.isNotEmpty) {
            selectedScheduleId = schedules.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los horarios (schedules)');
      }
    } catch (e) {
      throw Exception('Error al cargar los horarios (schedules): $e');
    }
  }

  void _deleteSchedule() async {
    if (selectedScheduleId.isNotEmpty) {
      try {
        var url =
            Uri.parse('http://10.0.2.2:8080/api/schedule/$selectedScheduleId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Horario eliminado con éxito'),
            ),
          );
          fetchSchedules();
        } else {
          print('Error al eliminar el horario. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el horario: $e");
      }
    } else {
      print('Selecciona un horario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Horario'),
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
                value: selectedScheduleId,
                hint: Text('Selecciona un horario'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedScheduleId = newValue!;
                  });
                },
                items: schedules.map<DropdownMenuItem<String>>((schedule) {
                  return DropdownMenuItem<String>(
                    value: schedule['id'].toString(),
                    child: Text(
                      '${schedule['id']}:Hora ${schedule['hour_day_id']?['hour']?['hour'] ?? 'N/A'}/Día ${schedule['hour_day_id']?['day']?['day_number'] ?? 'N/A'}/Asignatura ${schedule['subject_classroom_id']?['subject']?['subject_name'] ?? 'N/A'}/Aula ${schedule['subject_classroom_id']?['classroom']?['classroom_name'] ?? 'N/A'}',
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteSchedule();
                },
                child: Text('Borrar Horario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
