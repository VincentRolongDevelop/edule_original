import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteRolePage extends StatefulWidget {
  @override
  _DeleteRolePageState createState() => _DeleteRolePageState();
}

class _DeleteRolePageState extends State<DeleteRolePage> {
  late List<Map<String, dynamic>> roles = [];
  String selectedRoleId = '';

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
        List<Map<String, dynamic>> fetchedRoles =
            List<Map<String, dynamic>>.from(data);
        setState(() {
          roles = fetchedRoles;
          if (roles.isNotEmpty) {
            selectedRoleId = roles.first['id'].toString();
          }
        });
      } else {
        throw Exception('No se pueden cargar los roles');
      }
    } catch (e) {
      throw Exception('Error al cargar los roles: $e');
    }
  }

  void _deleteRole() async {
    if (selectedRoleId.isNotEmpty) {
      try {
        var url = Uri.parse('http://10.0.2.2:8080/api/role/$selectedRoleId');
        var response = await http.delete(url);

        print("${response.statusCode}");
        print("${response.body}");

        if (response.statusCode == 204) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rol eliminado con éxito'),
            ),
          );
          fetchRoles();
        } else {
          print('Error al eliminar el rol. Código: ${response.statusCode}');
        }
      } catch (e) {
        print("Error al eliminar el rol: $e");
      }
    } else {
      print('Selecciona un rol');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Rol'),
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
                  });
                },
                items: roles.map<DropdownMenuItem<String>>((role) {
                  return DropdownMenuItem<String>(
                    value: role['id'].toString(),
                    child: Text('${role['role_name']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteRole();
                },
                child: Text('Borrar Rol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
