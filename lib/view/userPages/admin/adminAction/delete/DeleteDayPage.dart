import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteDayPage extends StatefulWidget {
  @override
  _DeleteDayPageState createState() => _DeleteDayPageState();
}

class _DeleteDayPageState extends State<DeleteDayPage> {
  late List<Map<String, dynamic>> days = [];
  String selectedDayId = '';

  @override
  void initState() {
    super.initState();
    fetchDays();
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
          if (days.isNotEmpty) {
            selectedDayId = days.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los días');
      }
    } catch (e) {
      throw Exception('Error al cargar los días: $e');
    }
  }

  void _deleteDay() async {
    if (selectedDayId.isNotEmpty) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/day/$selectedDayId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Día eliminado con éxito'),
            ),
          );
          fetchDays();
        } else {
          print('Error al eliminar el día. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el día: $e");
      }
    } else {
      print('Selecciona un día');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Día'),
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
                value: selectedDayId,
                hint: Text('Selecciona un día'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDayId = newValue!;
                  });
                },
                items: days.map<DropdownMenuItem<String>>((day) {
                  return DropdownMenuItem<String>(
                    value: day['id'].toString(),
                    child: Text('Día ${day['day_number']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteDay();
                },
                child: Text('Borrar Día'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
