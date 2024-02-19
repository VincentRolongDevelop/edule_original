import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteSubjectClassRoomPage extends StatefulWidget {
  @override
  _DeleteSubjectClassRoomPageState createState() =>
      _DeleteSubjectClassRoomPageState();
}

class _DeleteSubjectClassRoomPageState
    extends State<DeleteSubjectClassRoomPage> {
  late List<Map<String, dynamic>> subjectClassrooms = [];
  String selectedSubjectClassRoomId = '';

  @override
  void initState() {
    super.initState();
    fetchSubjectClassRooms();
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
          subjectClassrooms = fetchedSubjectClassRooms;
          if (subjectClassrooms.isNotEmpty) {
            selectedSubjectClassRoomId =
                subjectClassrooms.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar las relaciones SubjectClassRoom');
      }
    } catch (e) {
      throw Exception('Error al cargar las relaciones SubjectClassRoom: $e');
    }
  }

  void _deleteSubjectClassRoom() async {
    if (selectedSubjectClassRoomId.isNotEmpty) {
      try {
        var url = Uri.parse(
            'http://10.0.2.2:8080/api/subjectclassroom/$selectedSubjectClassRoomId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Relación SubjectClassRoom eliminada con éxito'),
            ),
          );
          fetchSubjectClassRooms();
        } else {
          print(
              'Error al eliminar la relación SubjectClassRoom. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar la relación SubjectClassRoom: $e");
      }
    } else {
      print('Selecciona una relación SubjectClassRoom');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Relación SubjectClassRoom'),
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
                value: selectedSubjectClassRoomId,
                hint: Text('Selecciona una relación SubjectClassRoom'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubjectClassRoomId = newValue!;
                  });
                },
                items: subjectClassrooms
                    .map<DropdownMenuItem<String>>((subjectClassRoom) {
                  return DropdownMenuItem<String>(
                    value: subjectClassRoom['id'].toString(),
                    child: Text(
                      '${subjectClassRoom['id']}-Tema ${subjectClassRoom['subject']?['subject_name'] ?? 'N/A'} - Aula ${subjectClassRoom['classroom']?['classroom_name'] ?? 'N/A'}',
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteSubjectClassRoom();
                },
                child: Text('Borrar Relación SubjectClassRoom'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
