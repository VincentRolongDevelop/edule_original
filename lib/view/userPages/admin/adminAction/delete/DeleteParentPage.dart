import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteParentPage extends StatefulWidget {
  @override
  _DeleteParentPageState createState() => _DeleteParentPageState();
}

class _DeleteParentPageState extends State<DeleteParentPage> {
  late List<Map<String, dynamic>> parents = [];
  String selectedParentId = '';

  Future<List<Map<String, dynamic>>> fetchParents() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/parent/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedParents =
          List<Map<String, dynamic>>.from(data);
      return fetchedParents;
    } else {
      throw Exception('No se pueden cargar los padres');
    }
  }

  Future<void> deleteParent(String parentId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/parent/$parentId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Padre eliminado'),
        ),
      );

      // Redirigir a la página AdminPage después de eliminar el padre
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el padre'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchParents().then((fetchedParents) {
      setState(() {
        parents = fetchedParents;
        if (parents.isNotEmpty) {
          selectedParentId = parents.first['id'].toString();
        }
      });
    }).catchError((error) {
      print("Error al cargar los padres: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Padres'),
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
                value: selectedParentId,
                hint: Text('Selecciona un padre'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedParentId = newValue!;
                  });
                },
                items: parents.map<DropdownMenuItem<String>>((parent) {
                  return DropdownMenuItem<String>(
                    value: parent['id'].toString(),
                    child: Text('${parent['firstName']} ${parent['lastName']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteParent(selectedParentId);
                },
                child: Text('Borrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
