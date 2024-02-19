import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';
import 'dart:convert';

class CreateSchedulePage extends StatefulWidget {
  @override
  _CreateSchedulePageState createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  late List<Map<String, dynamic>> hourDayList;
  late List<Map<String, dynamic>> subjectClassRoomList;
  Map<String, dynamic>? selectedHourDay;
  Map<String, dynamic>? selectedSubjectClassRoom;

  @override
  void initState() {
    super.initState();
    fetchHourDays();
    fetchSubjectClassRooms();
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
          hourDayList = fetchedHourDays;
          if (hourDayList.isNotEmpty) {
            selectedHourDay = hourDayList.first;
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones HourDay');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones HourDay: $e');
    }
  }

  Future<void> fetchSubjectClassRooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjectClassRooms =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          subjectClassRoomList = fetchedSubjectClassRooms;
          if (subjectClassRoomList.isNotEmpty) {
            selectedSubjectClassRoom = subjectClassRoomList.first;
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones SubjectClassRoom');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones SubjectClassRoom: $e');
    }
  }

  void _createSchedule() async {
    if (selectedHourDay != null && selectedSubjectClassRoom != null) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/schedule/save');
        Map data = {
          'hour_day_id': {"id": selectedHourDay!['id']},
          'subject_classroom_id': {"id": selectedSubjectClassRoom!['id']},
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación Schedule creada con éxito'),
            ),
          );
        } else {
          print(
              'Error al crear la relación Schedule. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al crear la relación Schedule: $e");
      }
    } else {
      print('Selecciona una relación HourDay y SubjectClassRoom');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Relación Schedule'),
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
              DropdownButton<Map<String, dynamic>>(
                value: selectedHourDay,
                hint: Text('Selecciona una relación HourDay'),
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedHourDay = newValue;
                  });
                },
                items: hourDayList
                    .map<DropdownMenuItem<Map<String, dynamic>>>((hourDay) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: hourDay,
                    child: Text(
                        'Hora: ${hourDay['hour']['hour']} - Día: ${hourDay['day'] != null ? hourDay['day']['day_number'] ?? 'Desconocido' : 'Desconocido'}'),
                  );
                }).toList(),
              ),
              DropdownButton<Map<String, dynamic>>(
                value: selectedSubjectClassRoom,
                hint: Text('Selecciona una relación SubjectClassRoom'),
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedSubjectClassRoom = newValue;
                  });
                },
                items: subjectClassRoomList
                    .map<DropdownMenuItem<Map<String, dynamic>>>(
                        (subjectClassRoom) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: subjectClassRoom,
                    child: Text(
                        'Materia: ${subjectClassRoom['subject']['subject_name']} - Aula: ${subjectClassRoom['classroom']['classroom_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _createSchedule,
                child: Text('Crear Relación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
