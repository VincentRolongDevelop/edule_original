import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../adminPage.dart';
import 'dart:convert';

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  late List<Map<String, dynamic>> users = [];
  String selectedUserId = '';

  Future<List<Map<String, dynamic>>> getUsers() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> fetchedUsers =
          List<Map<String, dynamic>>.from(data);
      return fetchedUsers;
    } else {
      throw Exception('No se pueden cargar los usuarios');
    }
  }

  Future<void> deleteUser(String userId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/$userId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuario eliminado'),
        ),
      );

      // Redirige a AdminPage después de borrar el usuario
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      throw Exception('Error al eliminar el usuario');
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers().then((fetchedUsers) {
      setState(() {
        users = fetchedUsers;
        if (users.isNotEmpty) {
          selectedUserId = users.first['id'].toString();
        }
      });
    }).catchError((error) {
      print("Error al cargar los usuarios: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Usuario'),
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
                value: selectedUserId,
                hint: Text('Selecciona un usuario'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedUserId = newValue!;
                  });
                },
                items: users.map<DropdownMenuItem<String>>((user) {
                  return DropdownMenuItem<String>(
                    value: user['id'].toString(),
                    child: Text('${user['firstName']} ${user['lastName']}'),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  deleteUser(selectedUserId);
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
