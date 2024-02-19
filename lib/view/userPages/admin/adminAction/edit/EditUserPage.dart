import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/view/userPages/admin/adminPage.dart';

class EditUserPage extends StatefulWidget {
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late List<Map<String, dynamic>> users = [];
  String selectedUserId = '';

  TextEditingController identificationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleIdController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(data);
      return users;
    } else {
      throw Exception('No se pueden cargar los usuarios');
    }
  }

  Future<http.Response> editUser(
    String userId,
    String identificationController,
    String firstNameController,
    String lastNameController,
    String emailController,
    int roleIdController,
    String usernameController,
    String passwordController,
    String idTypeController,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/update');
    Map data = {
      'id': userId,
      'id_type': idTypeController,
      'identification': identificationController,
      'firstName': firstNameController,
      'lastName': lastNameController,
      'email': emailController,
      'role_id': {"id": roleIdController},
      'username': usernameController,
      'password': passwordController,
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
    return response;
  }

  Future<void> deleteUser(String userId) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/$userId');
    var response = await http.delete(url);

    if (response.statusCode == 204) {
      print('Usuario eliminado');
    } else {
      throw Exception('Error al eliminar el usuario');
    }
  }

  Future<void> fetchUsers() async {
    try {
      List<Map<String, dynamic>> fetchedUsers = await getUsers();
      setState(() {
        users = fetchedUsers;
        if (users.isNotEmpty) {
          selectedUserId = users.first['id'].toString();
          loadSelectedUserData(selectedUserId);
        }
      });
    } catch (e) {
      print("Error al cargar los usuarios: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
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
                    loadSelectedUserData(selectedUserId);
                  });
                },
                items: users.map<DropdownMenuItem<String>>((user) {
                  return DropdownMenuItem<String>(
                    value: user['id'].toString(),
                    child: Text('${user['firstName']} ${user['lastName']}'),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: identificationController,
                decoration: InputDecoration(labelText: 'Identificación'),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo'),
              ),
              TextFormField(
                controller: roleIdController,
                decoration: InputDecoration(labelText: 'Rol ID'),
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: idTypeController,
                decoration: InputDecoration(labelText: 'Tipo de ID'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateUserData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedUserData(String userId) {
    Map<String, dynamic> user =
        users.firstWhere((user) => user['id'].toString() == userId);
    setState(() {
      identificationController.text = user['identification'];
      firstNameController.text = user['firstName'];
      lastNameController.text = user['lastName'];
      emailController.text = user['email'];
      roleIdController.text = user['role_id']['id'].toString();
      usernameController.text = user['username'];
      passwordController.text = user['password'];
      idTypeController.text = user['id_type'];
    });
  }

  Future<void> updateUserData() async {
    String identification = identificationController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    int roleId = int.parse(roleIdController.text);
    String username = usernameController.text;
    String password = passwordController.text;
    String idType = idTypeController.text;

    try {
      await editUser(
        selectedUserId,
        identification,
        firstName,
        lastName,
        email,
        roleId,
        username,
        password,
        idType,
      );
      fetchUsers();
    } catch (e) {
      print("Error al editar el usuario: $e");
    }
  }
}
