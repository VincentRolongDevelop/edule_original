import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../admin/adminPage.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedClassroomId;
  String? selectedParentId;
  final TextEditingController _idTypeController = TextEditingController();

  List<Map<String, dynamic>> classrooms = [];
  List<Map<String, dynamic>> parents = [];

  Future<void> loadClassrooms() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/classroom/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      classrooms = List<Map<String, dynamic>>.from(data);
      setState(() {});
    } else {
      throw Exception('No se pueden cargar las aulas');
    }
  }

  Future<void> loadParents() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/parent/all');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      parents = List<Map<String, dynamic>>.from(data);
      setState(() {});
    } else {
      throw Exception('No se pueden cargar los padres');
    }
  }

  @override
  void initState() {
    super.initState();
    loadClassrooms();
    loadParents();
  }

  Future<void> addStudent(
    String firstNameController,
    String lastNameController,
    String identificationController,
    String emailController,
    String usernameController,
    String passwordController,
    int classRoomIdController,
    int parentIdController,
    String idTypeController,
  ) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/student/save');
    Map data = {
      'firstName': firstNameController,
      'lastName': lastNameController,
      'identification': identificationController,
      'email': emailController,
      'username': usernameController,
      'password': passwordController,
      'classroom': {"id": classRoomIdController},
      'parent': {"id": parentIdController},
      'id_type': idTypeController
    };

    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print("Es este" + body);
    print("${response.statusCode}");
    print("${response.body}");
  }

  void _createStudent() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String identification = _identificationController.text;
    String email = _emailController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String idType = _idTypeController.text;

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        identification.isNotEmpty &&
        email.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty &&
        selectedClassroomId != null &&
        selectedParentId != null &&
        idType.isNotEmpty) {
      addStudent(
        firstName,
        lastName,
        identification,
        email,
        username,
        password,
        int.parse(selectedClassroomId!),
        int.parse(selectedParentId!),
        idType,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Se creó un nuevo estudiante'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      // Manejar el caso en el que no se proporcionan todos los datos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Estudiante'),
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
                  Text("Crear Estudiante", style: TextStyle(fontSize: 24.0)),
                  SizedBox(height: 20.0),
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
                    controller: _identificationController,
                    decoration: InputDecoration(
                      labelText: "Identificación",
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
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Usuario",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<String>(
                    value: selectedClassroomId,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    hint: Text("Selecciona un salón"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedClassroomId = newValue;
                      });
                    },
                    items:
                        classrooms.map<DropdownMenuItem<String>>((classroom) {
                      return DropdownMenuItem<String>(
                        value: classroom['id'].toString(),
                        child: Text(classroom['classroom_name'].toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButton<String>(
                    value: selectedParentId,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    isExpanded: true,
                    hint: Text("Selecciona un padre"),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedParentId = newValue;
                      });
                    },
                    items: parents.map<DropdownMenuItem<String>>((parent) {
                      return DropdownMenuItem<String>(
                        value: parent['id'].toString(),
                        child: Text(
                            '${parent['firstName']} ${parent['lastName']}'),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _idTypeController,
                    decoration: InputDecoration(
                      labelText: "ID de Tipo",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createStudent,
            child: Text("Crear Estudiante", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
