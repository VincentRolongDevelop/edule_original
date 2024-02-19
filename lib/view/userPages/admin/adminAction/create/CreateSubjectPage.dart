import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';

class CreateSubjectPage extends StatefulWidget {
  const CreateSubjectPage({Key? key}) : super(key: key);

  @override
  _CreateSubjectPageState createState() => _CreateSubjectPageState();
}

class _CreateSubjectPageState extends State<CreateSubjectPage> {
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<http.Response> addSubjectToApi(
      String subjectName, String description) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/subject/save');
    Map data = {
      'subject_name': subjectName,
      'description': description,
    };

    var body = json.encode(data);

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    // Imprimir detalles de la respuesta
    print("Request URL: $url");
    print("Request Body: $body");
    print("Response: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }

  void _createSubject() async {
    String subjectName = _subjectNameController.text;
    String description = _descriptionController.text;

    if (subjectName.isNotEmpty && description.isNotEmpty) {
      http.Response response = await addSubjectToApi(subjectName, description);

      // Imprimir detalles adicionales en caso de error
      if (response.statusCode != 200) {
        print("Error Response: ${response.statusCode}");
        print("Error Response Body: ${response.body}");
      }

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se creó una nueva asignatura'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear la asignatura'),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Por favor completa todos los campos."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Asignatura'),
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
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Crear Asignatura", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _subjectNameController,
                    decoration: InputDecoration(
                      labelText: "Nombre de la Asignatura",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createSubject,
            child: Text("Crear Asignatura", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
