import 'package:flutter/material.dart';
import '../../../admin/adminPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? selectedRoleId;

  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _typeIdController = TextEditingController();

  List<Map<String, dynamic>> roles = [];

  Future<List<Map<String, dynamic>>> getRoles() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/role/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> roles = List<Map<String, dynamic>>.from(data);
      return roles;
    } else {
      throw Exception('No se pueden cargar los roles');
    }
  }

  Future<http.Response> addUser(
    String identificationController,
    String firstNameController,
    String lastNameController,
    String emailController,
    int roleIdController,
    String usernameController,
    String passwordController,
    String idTypeController,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/save');
    Map data = {
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

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("Es este" + body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  void loadRoles() async {
    try {
      final rolesList = await getRoles();
      setState(() {
        roles = rolesList;
      });
    } catch (e) {
      print("Error al cargar los roles: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadRoles();
  }

  void _register() async {
    String newUsername = _newUsernameController.text;
    String newPassword = _newPasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String identification = _identificationController.text;
    String typeId = _typeIdController.text;

    if (newUsername.isNotEmpty &&
        newPassword.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        email.isNotEmpty &&
        selectedRoleId != null &&
        identification.isNotEmpty &&
        typeId.isNotEmpty) {
      var response = await addUser(
        identification,
        firstName,
        lastName,
        email,
        int.parse(selectedRoleId!),
        newUsername,
        newPassword,
        typeId,
      );

      print("Response: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Se creó un nuevo usuario'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
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
                  Text("Registro", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _newUsernameController,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: "Apellido",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<String>(
                    value: selectedRoleId,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    hint: Text("Selecciona un rol"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRoleId = newValue;
                      });
                    },
                    items: roles.map<DropdownMenuItem<String>>((role) {
                      return DropdownMenuItem<String>(
                        value: role['id'].toString(),
                        child: Text(role['role_name'].toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _identificationController,
                    decoration: InputDecoration(
                      labelText: "Identificación",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _typeIdController,
                    decoration: InputDecoration(
                      labelText: "ID de tipo",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _register,
            child: Text("Registrar", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
