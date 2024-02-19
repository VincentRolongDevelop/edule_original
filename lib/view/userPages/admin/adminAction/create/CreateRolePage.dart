import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({Key? key}) : super(key: key);

  @override
  _CreateRolePageState createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _roleDescriptionController =
      TextEditingController();

  Future<void> _createRole() async {
    try {
      String roleName = _roleNameController.text;
      String roleDescription = _roleDescriptionController.text;

      if (roleName.isNotEmpty && roleDescription.isNotEmpty) {
        var url = Uri.parse('http://10.0.2.2:8080/api/role/save');
        Map data = {
          'role_name': roleName,
          'role_description': roleDescription,
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
            content: Text('Se creó un nuevo rol'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
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
    } catch (e) {
      print('Error al crear el rol: $e');
      // Puedes mostrar un mensaje de error aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el rol')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Rol'),
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
                  Text("Crear Rol", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _roleNameController,
                    decoration: InputDecoration(
                      labelText: "Nombre del Rol",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _roleDescriptionController,
                    decoration: InputDecoration(
                      labelText: "Descripción del Rol",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createRole,
            child: Text("Crear Rol", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
