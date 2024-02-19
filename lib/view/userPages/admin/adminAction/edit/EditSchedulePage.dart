import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditSchedulePage extends StatefulWidget {
  @override
  _EditSchedulePageState createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  late List<Map<String, dynamic>> schedules = [];
  late List<Map<String, dynamic>> hourDays = [];
  late List<Map<String, dynamic>> subjectClassrooms = [];

  String selectedScheduleId = '';
  String? selectedHourDayId;
  String? selectedSubjectClassroomId;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
    fetchHourDays();
    fetchSubjectClassrooms();
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
            loadSelectedScheduleData(selectedScheduleId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los horarios');
      }
    } catch (e) {
      print("Error al cargar los horarios: $e");
    }
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
        throw Exception('No se pueden cargar las horas del día');
      }
    } catch (e) {
      print("Error al cargar las horas del día: $e");
    }
  }

  Future<void> fetchSubjectClassrooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/subjectclassroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedSubjectClassrooms =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          subjectClassrooms = fetchedSubjectClassrooms;
        });
      } else {
        throw Exception('No se pueden cargar las relaciones materia-aula');
      }
    } catch (e) {
      print("Error al cargar las relaciones materia-aula: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Horario'),
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
      body: schedules.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          loadSelectedScheduleData(selectedScheduleId);
                        });
                      },
                      items:
                          schedules.map<DropdownMenuItem<String>>((schedule) {
                        return DropdownMenuItem<String>(
                          value: schedule['id'].toString(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              'ID: ${schedule['id']} ${schedule['hour_day_id']?['hour'] ?? 'Desconocida'} - Día: ${schedule['hour_day_id']?['day']?['day_number'] ?? 'Desconocido'} - Materia: ${schedule['subject_classroom_id']?['subject']?['subject_name'] ?? 'Materia Desconocida'} - Aula: ${schedule['subject_classroom_id']?['classroom']?['classroom_name'] ?? 'Aula Desconocida'}',
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedHourDayId,
                      hint: Text('Selecciona una hora del día'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHourDayId = newValue;
                        });
                      },
                      items: hourDays.map<DropdownMenuItem<String>>((hourDay) {
                        return DropdownMenuItem<String>(
                          value: hourDay['id'].toString(),
                          child: Text(
                            'Hora: ${hourDay['hour']?['hour'] ?? 'Desconocida'} / Día: ${hourDay['day']?['day_number'] ?? 'Desconocido'}',
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedSubjectClassroomId,
                      hint: Text('Selecciona una relación materia-aula'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubjectClassroomId = newValue;
                        });
                      },
                      items: subjectClassrooms
                          .map<DropdownMenuItem<String>>((subjectClassroom) {
                        return DropdownMenuItem<String>(
                          value: subjectClassroom['id'].toString(),
                          child: Text(
                            'Materia: ${subjectClassroom['subject']?['subject_name'] ?? 'Desconocida'} / Aula: ${subjectClassroom['classroom']?['classroom_name'] ?? 'Desconocida'}',
                          ),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: selectedScheduleId.isNotEmpty &&
                              selectedHourDayId != null &&
                              selectedSubjectClassroomId != null
                          ? () {
                              updateScheduleData();
                              FocusScope.of(context).unfocus();
                            }
                          : null,
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void loadSelectedScheduleData(String scheduleId) {
    Map<String, dynamic>? schedule = schedules.firstWhere(
      (schedule) => schedule['id'].toString() == scheduleId,
      orElse: () => {},
    );

    if (schedule != null &&
        schedule['hour_day_id'] != null &&
        schedule['subject_classroom_id'] != null) {
      setState(() {
        selectedHourDayId = schedule['hour_day_id']['id']?.toString();
        selectedSubjectClassroomId =
            schedule['subject_classroom_id']['id']?.toString();
      });
    }
  }

  Future<void> updateScheduleData() async {
    try {
      await editSchedule(
        scheduleId: int.parse(selectedScheduleId),
        hourDayId: int.parse(selectedHourDayId!),
        subjectClassroomId: int.parse(selectedSubjectClassroomId!),
      );
      print("Datos de horario actualizados con éxito");
      fetchSchedules();
    } catch (e) {
      print("Error al editar el horario: $e");
    }
  }

  Future<void> editSchedule({
    required int scheduleId,
    required int hourDayId,
    required int subjectClassroomId,
  }) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/schedule/update');
    Map data = {
      'id': scheduleId,
      'hour_day_id': {'id': hourDayId},
      'subject_classroom_id': {'id': subjectClassroomId},
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Datos de horario actualizados con éxito");
    }
  }
}
