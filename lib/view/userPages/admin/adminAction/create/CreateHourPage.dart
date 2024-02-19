import 'package:flutter/material.dart';
import '../../../admin/adminPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateHourPage extends StatefulWidget {
  @override
  _CreateHourPageState createState() => _CreateHourPageState();
}

class _CreateHourPageState extends State<CreateHourPage> {
  TextEditingController hourController = TextEditingController();

  Future<void> createHour() async {
    try {
      // Llamada al método addHour en tu helper
      await addHour(hourController.text);
      showSuccessSnackBar('Hora creada exitosamente');
      clearTextField();
    } catch (e) {
      showErrorSnackBar('Error al crear la hora: $e');
    }
  }

  Future<http.Response> addHour(String hour) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/hour/save');
    Map data = {
      'hour': hour,
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
    return response;
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void clearTextField() {
    hourController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Hora'),
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
              controller: hourController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(labelText: 'Hora (formato HH:mm:ss)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                createHour();
              },
              child: Text('Crear Hora'),
            ),
          ],
        ),
      ),
    );
  }
}
