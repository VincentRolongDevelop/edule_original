import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditClassRoomPage extends StatefulWidget {
  @override
  _EditClassRoomPageState createState() => _EditClassRoomPageState();
}

class _EditClassRoomPageState extends State<EditClassRoomPage> {
  late List<Map<String, dynamic>> classrooms;
  String selectedClassRoomId = '';

  TextEditingController classroomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    classrooms = [];
    fetchClassRooms();
  }

  Future<void> fetchClassRooms() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          classrooms = List<Map<String, dynamic>>.from(data);
          if (classrooms.isNotEmpty) {
            selectedClassRoomId = classrooms.first['id'].toString();
            loadSelectedClassRoomData(selectedClassRoomId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los salones');
      }
    } catch (e) {
      print("Error al cargar los salones: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Salón'),
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
                value: selectedClassRoomId,
                hint: Text('Selecciona un salón'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClassRoomId = newValue!;
                    loadSelectedClassRoomData(selectedClassRoomId);
                  });
                },
                items: classrooms.map<DropdownMenuItem<String>>((classroom) {
                  return DropdownMenuItem<String>(
                    value: classroom['id'].toString(),
                    child: Text('${classroom['classroom_name']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: classroomNameController,
                decoration: InputDecoration(labelText: 'Nombre del Salón'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateClassRoomData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedClassRoomData(String classRoomId) {
    Map<String, dynamic> classroom = classrooms
        .firstWhere((classroom) => classroom['id'].toString() == classRoomId);
    setState(() {
      classroomNameController.text = classroom['classroom_name'];
    });
  }

  Future<void> updateClassRoomData() async {
    String classRoomId = selectedClassRoomId;
    String classroomName = classroomNameController.text;

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/classroom/update');
      Map data = {
        'id': classRoomId,
        'classroom_name': classroomName,
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

      fetchClassRooms();
    } catch (e) {
      print("Error al editar el salón: $e");
    }
  }
}
