import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class DeleteClassRoomPage extends StatefulWidget {
  @override
  _DeleteClassRoomPageState createState() => _DeleteClassRoomPageState();
}

class _DeleteClassRoomPageState extends State<DeleteClassRoomPage> {
  late List<Map<String, dynamic>> classrooms = [];
  String selectedClassroomId = '';

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  Future<void> fetchClassrooms() async {
    try {
      List<Map<String, dynamic>> fetchedClassrooms = await getClassrooms();
      setState(() {
        classrooms = fetchedClassrooms;
        if (classrooms.isNotEmpty) {
          selectedClassroomId = classrooms.first['id'].toString();
        }
      });
    } catch (e) {
      print("Error al cargar las aulas: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getClassrooms() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> classrooms =
          List<Map<String, dynamic>>.from(data);
      return classrooms;
    } else {
      throw Exception('No se pueden cargar las aulas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Aulas'),
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
                value: selectedClassroomId,
                hint: Text('Selecciona un aula'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedClassroomId = newValue!;
                  });
                },
                items: classrooms.map<DropdownMenuItem<String>>((classroom) {
                  return DropdownMenuItem<String>(
                    value: classroom['id'].toString(),
                    child: Text('${classroom['classroom_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteClassRoom(selectedClassroomId);
                },
                child: Text('Borrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteClassRoom(String classRoomId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/classroom/$classRoomId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      fetchClassrooms();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aula eliminada'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el aula: ${response.statusCode}'),
        ),
      );
    }
  }
}
