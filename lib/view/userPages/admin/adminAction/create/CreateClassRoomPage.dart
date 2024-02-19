import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';

class CreateClassRoomPage extends StatefulWidget {
  @override
  _CreateClassRoomPageState createState() => _CreateClassRoomPageState();
}

class _CreateClassRoomPageState extends State<CreateClassRoomPage> {
  TextEditingController _classroomNameController = TextEditingController();

  Future<http.Response> addClassRoom() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/classroom/save');
    Map data = {
      'classroom_name': _classroomNameController.text,
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("Es este" + body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Clase'),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _classroomNameController,
              decoration: InputDecoration(labelText: 'Nombre de la Clase'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                var response = await addClassRoom();
              },
              child: Text("Guardar Clase"),
            ),
          ],
        ),
      ),
    );
  }
}
