import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';

class CreateDayPage extends StatefulWidget {
  const CreateDayPage({Key? key}) : super(key: key);

  @override
  _CreateDayPageState createState() => _CreateDayPageState();
}

class _CreateDayPageState extends State<CreateDayPage> {
  final TextEditingController _dayNumberController = TextEditingController();

  Future<void> _createDay() async {
    try {
      String dayNumberText = _dayNumberController.text;

      if (dayNumberText.isNotEmpty) {
        int dayNumber = int.parse(dayNumberText);

        var url = Uri.parse('http://10.0.2.2:8080/api/day/save');
        Map data = {
          'day_number': dayNumber,
        };

        var body = json.encode(data);

        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        // Puedes agregar lógica para manejar la respuesta según sea necesario
        print("Response: ${response.statusCode}");
        print("Response Body: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se creó un nuevo día'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      } else {
        // Manejar el caso en el que algún campo esté vacío o no sea un número
      }
    } catch (e) {
      print('Error al crear el día: $e');
      // Puedes mostrar un mensaje de error aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el día')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Día'),
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
                  Text("Crear Día", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _dayNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Número del Día",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createDay,
            child: Text("Crear Día", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
