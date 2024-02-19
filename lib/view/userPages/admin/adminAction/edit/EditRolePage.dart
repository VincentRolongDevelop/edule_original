import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditRolePage extends StatefulWidget {
  @override
  _EditRolePageState createState() => _EditRolePageState();
}

class _EditRolePageState extends State<EditRolePage> {
  late List<Map<String, dynamic>> roles = [];
  String selectedRoleId = '';

  TextEditingController roleNameController = TextEditingController();
  TextEditingController roleDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/role/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          roles = List<Map<String, dynamic>>.from(data);
          if (roles.isNotEmpty) {
            selectedRoleId = roles.first['id'].toString();
            loadSelectedRoleData(selectedRoleId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los roles');
      }
    } catch (e) {
      print("Error al cargar los roles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Rol'),
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
                value: selectedRoleId,
                hint: Text('Selecciona un rol'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoleId = newValue!;
                    loadSelectedRoleData(selectedRoleId);
                  });
                },
                items: roles.map<DropdownMenuItem<String>>((role) {
                  return DropdownMenuItem<String>(
                    value: role['id'].toString(),
                    child: Text('${role['role_name']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: roleNameController,
                decoration: InputDecoration(labelText: 'Nombre del Rol'),
              ),
              TextFormField(
                controller: roleDescriptionController,
                decoration: InputDecoration(labelText: 'Descripción del Rol'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateRoleData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedRoleData(String roleId) {
    Map<String, dynamic> role =
        roles.firstWhere((role) => role['id'].toString() == roleId);
    setState(() {
      roleNameController.text = role['role_name'];
      roleDescriptionController.text = role['role_description'];
    });
  }

  Future<void> updateRoleData() async {
    String roleName = roleNameController.text;
    String roleDescription = roleDescriptionController.text;

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/role/update');
      Map data = {
        'id': int.parse(selectedRoleId),
        'role_name': roleName,
        'role_description': roleDescription,
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

      fetchRoles();
    } catch (e) {
      print("Error al editar el rol: $e");
    }
  }
}
