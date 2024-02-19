import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/DatabaseHelper.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSchedulePage extends StatefulWidget {
  @override
  _ViewSchedulePageState createState() => _ViewSchedulePageState();
}

class _ViewSchedulePageState extends State<ViewSchedulePage> {
  late List<Map<String, dynamic>> users = [];
  String selectedUser = '';
  late List<dynamic> schedule = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    loadSchedule();
    currentcycle();
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedUsers =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          users = fetchedUsers;

          selectedUser = users.isNotEmpty ? users[0]['username'] : '';
        });
      } else {
        throw Exception('No se pueden cargar los usuarios');
      }
    } catch (e) {
      throw Exception('Error al cargar los usuarios: $e');
    }
  }

  Future<void> fetchSchedule() async {
    try {
      var url =
          Uri.parse('http://10.0.2.2:8080/api/schedule/teacher/$selectedUser');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<dynamic> fetchedSchedule = List<dynamic>.from(data);
        print(data);
        setState(() {
          schedule.clear();
          schedule = fetchedSchedule;
        });
        // Guardar la lista 'schedule' en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String scheduleJson = jsonEncode(schedule);
        prefs.setString('schedule', scheduleJson);
      } else {
        throw Exception('No se pueden cargar el horario del usuario');
      }
    } catch (e) {
      throw Exception('Error al cargar el horario del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Horario del Usuario'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona un usuario:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<Map<String, dynamic>>(
              value: users.isNotEmpty
                  ? users.firstWhere((user) => user['username'] == selectedUser)
                  : null,
              hint: Text('Selecciona un usuario'),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  selectedUser = newValue!['username'];
                });
              },
              items: users.map<DropdownMenuItem<Map<String, dynamic>>>((user) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: user,
                  child: Text(user['username']),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedUser.isNotEmpty) {
                  fetchSchedule();
                } else {
                  print('Selecciona un usuario');
                }
              },
              child: Text('Ver Horario'),
            ),
            SizedBox(height: 16),
            Text(
              'Horario del Usuario:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: schedule.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('Día')),
                            DataColumn(label: Text('Hora')),
                            DataColumn(label: Text('Materia')),
                            DataColumn(label: Text('Aula')),
                          ],
                          rows: schedule
                              .map(
                                (entry) => DataRow(
                                  cells: [
                                    DataCell(
                                      Text(entry.length > 0 ? entry[0] : 'N/A'),
                                    ),
                                    DataCell(
                                      Text(entry.length > 1 ? entry[1] : 'N/A'),
                                    ),
                                    DataCell(
                                      Text(entry.length > 2 ? entry[2] : 'N/A'),
                                    ),
                                    DataCell(
                                      Text(entry.length > 3 ? entry[3] : 'N/A'),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : Center(
                      child: Text('No hay horario para mostrar.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadSchedule() async {
    //Recuperar la lista 'schedule' desde SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scheduleJson = prefs.getString('schedule');
    if (scheduleJson != null) {
      setState(() {
        //Map<String, dynamic> sc = Map<String, dynamic>.from(jsonDecode(scheduleJson));
      });
    }
  }

  void currentcycle() async {
    final dbHelper = DataBaseHelper();
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/currentcycle/all');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        print(data[data.length - 1]['currentDay']
            ['day_number']); // Imprime los datos en la consola
      } else {
        throw Exception(
            'Error al obtener el ciclo actual: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener el ciclo actual: $e');
    }
  }

// try {
//       var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         List<Map<String, dynamic>> fetchedUsers =
//             List<Map<String, dynamic>>.from(data);
//         //print(data);
//         setState(() {
//           users = fetchedUsers;

//           selectedUser = users.isNotEmpty ? users[0]['username'] : '';
//         });
//       } else {
//         throw Exception('No se pueden cargar los usuarios');
//       }
//     } catch (e) {
//       throw Exception('Error al cargar los usuarios: $e');
//     }
}
