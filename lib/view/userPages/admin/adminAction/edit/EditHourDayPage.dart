import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditHourDayPage extends StatefulWidget {
  @override
  _EditHourDayPageState createState() => _EditHourDayPageState();
}

class _EditHourDayPageState extends State<EditHourDayPage> {
  late List<Map<String, dynamic>> hourDays = [];
  late List<Map<String, dynamic>> days = [];
  late List<Map<String, dynamic>> hours = [];
  String selectedHourDayId = '';
  String? selectedDayId;
  String? selectedHourId;

  TextEditingController hourController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchHourDays();
    fetchDays();
    fetchHours();
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
            loadSelectedHourDayData(selectedHourDayId);
          }
        });
      } else {
        throw Exception('No se pueden cargar las horas del día');
      }
    } catch (e) {
      print("Error al cargar las horas del día: $e");
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
        setState(() {
          days = fetchedDays;
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
        });
      } else {
        throw Exception('No se pueden cargar las horas');
      }
    } catch (e) {
      throw Exception('Error al cargar las horas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Hora del Día'),
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
      body: hourDays.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedHourDayId,
                      hint: Text('Selecciona una hora del día'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedHourDayId = newValue!;
                          loadSelectedHourDayData(selectedHourDayId);
                        });
                      },
                      items: hourDays.map<DropdownMenuItem<String>>((hourDay) {
                        return DropdownMenuItem<String>(
                          value: hourDay['id'].toString(),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                                'ID:${hourDay['id']} - ${hourDay['hour']?['hour'] ?? 'Hora Desconocida'} - Día ${hourDay['day']?['day_number'] ?? 'Número Desconocido'}'),
                          ),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: selectedDayId,
                      hint: Text('Selecciona un día'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDayId = newValue;
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
                          selectedHourId = newValue;
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
                      onPressed: selectedHourDayId.isNotEmpty &&
                              selectedDayId != null &&
                              selectedHourId != null
                          ? () {
                              updateHourDayData();
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

  void loadSelectedHourDayData(String hourDayId) {
    Map<String, dynamic>? hourDay = hourDays.firstWhere(
      (hourDay) => hourDay['id'].toString() == hourDayId,
      orElse: () => {},
    );

    if (hourDay != null && hourDay['hour'] != null && hourDay['day'] != null) {
      setState(() {
        selectedDayId = hourDay['day']['id']?.toString();
        selectedHourId = hourDay['hour']['id']?.toString();
      });
    }
  }

  Future<void> updateHourDayData() async {
    try {
      await editHourDay(
        hourDayId: int.parse(selectedHourDayId),
        dayId: int.parse(selectedDayId!),
        hourId: int.parse(selectedHourId!),
      );
      print("Datos actualizados con éxito");
      fetchHourDays();
    } catch (e) {
      print("Error al editar la hora del día: $e");
    }
  }

  Future<void> editHourDay({
    required int hourDayId,
    required int dayId,
    required int hourId,
  }) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/hourday/update');
    Map data = {
      'id': hourDayId,
      'hour': {'id': hourId},
      'day': {'id': dayId},
    };

    var body = json.encode(data);

    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Datos de hourday actualizados con éxito");
    }
  }
}
