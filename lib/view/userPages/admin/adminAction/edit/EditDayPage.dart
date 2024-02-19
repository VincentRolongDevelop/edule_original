import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class EditDayPage extends StatefulWidget {
  @override
  _EditDayPageState createState() => _EditDayPageState();
}

class _EditDayPageState extends State<EditDayPage> {
  late List<Map<String, dynamic>> days = [];
  String selectedDayId = '';

  TextEditingController dayNumberController = TextEditingController();

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
            loadSelectedDayData(selectedDayId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los días');
      }
    } catch (e) {
      throw Exception('Error al cargar los días: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Día'),
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
                    loadSelectedDayData(selectedDayId);
                  });
                },
                items: days.map<DropdownMenuItem<String>>((day) {
                  return DropdownMenuItem<String>(
                    value: day['id'].toString(),
                    child: Text('Día ${day['day_number']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: dayNumberController,
                decoration: InputDecoration(labelText: 'Número del Día'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateDayData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedDayData(String dayId) {
    Map<String, dynamic> day =
        days.firstWhere((day) => day['id'].toString() == dayId);
    setState(() {
      dayNumberController.text = day['day_number'].toString();
    });
  }

  Future<void> updateDayData() async {
    String dayNumberText = dayNumberController.text;

    if (dayNumberText.isNotEmpty && int.tryParse(dayNumberText) != null) {
      int dayNumber = int.parse(dayNumberText);

      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/day/update');
        Map data = {
          'id': selectedDayId,
          'day_number': dayNumber,
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

        fetchDays();
      } catch (e) {
        print("Error al editar el día: $e");
      }
    } else {
      print('El número del día no es válido.');
    }
  }
}
