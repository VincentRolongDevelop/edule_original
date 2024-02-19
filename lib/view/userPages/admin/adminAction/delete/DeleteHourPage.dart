import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteHourPage extends StatefulWidget {
  @override
  _DeleteHourPageState createState() => _DeleteHourPageState();
}

class _DeleteHourPageState extends State<DeleteHourPage> {
  late List<Map<String, dynamic>> hours = [];
  String selectedHourId = '';

  @override
  void initState() {
    super.initState();
    fetchHours();
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
          if (hours.isNotEmpty) {
            selectedHourId = hours.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar las horas');
      }
    } catch (e) {
      throw Exception('Error al cargar las horas: $e');
    }
  }

  void _deleteHour() async {
    if (selectedHourId.isNotEmpty) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/hour/$selectedHourId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hora eliminada con éxito'),
            ),
          );
          fetchHours();
        } else {
          print('Error al eliminar la hora. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar la hora: $e");
      }
    } else {
      print('Selecciona una hora');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Hora'),
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
                value: selectedHourId,
                hint: Text('Selecciona una hora'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedHourId = newValue!;
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
                onPressed: () {
                  _deleteHour();
                },
                child: Text('Borrar Hora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
