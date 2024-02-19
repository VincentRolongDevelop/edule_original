import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteCyclePage extends StatefulWidget {
  @override
  _DeleteCyclePageState createState() => _DeleteCyclePageState();
}

class _DeleteCyclePageState extends State<DeleteCyclePage> {
  late List<Map<String, dynamic>> cycles = [];
  String selectedCycleId = '';

  @override
  void initState() {
    super.initState();
    fetchCycles();
  }

  Future<void> fetchCycles() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/cycle/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> fetchedCycles =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          cycles = fetchedCycles;
          if (cycles.isNotEmpty) {
            selectedCycleId = cycles.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los ciclos');
      }
    } catch (e) {
      throw Exception('Error al cargar los ciclos: $e');
    }
  }

  void _deleteCycle() async {
    if (selectedCycleId.isNotEmpty) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/cycle/$selectedCycleId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ciclo eliminado con éxito'),
            ),
          );
          fetchCycles();
        } else {
          print('Error al eliminar el ciclo. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el ciclo: $e");
      }
    } else {
      print('Selecciona un ciclo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Ciclo'),
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
                value: selectedCycleId,
                hint: Text('Selecciona un ciclo'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCycleId = newValue!;
                  });
                },
                items: cycles.map<DropdownMenuItem<String>>((cycle) {
                  return DropdownMenuItem<String>(
                    value: cycle['id'].toString(),
                    child: Text('Ciclo ${cycle['id']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteCycle();
                },
                child: Text('Borrar Ciclo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
