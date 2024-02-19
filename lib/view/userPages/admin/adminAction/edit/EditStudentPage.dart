import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditStudentPage extends StatefulWidget {
  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late List<Map<String, dynamic>> students = [];
  String selectedStudentId = '';

  TextEditingController identificationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController classRoomIdController = TextEditingController();
  TextEditingController parentIdController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/student/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          students = List<Map<String, dynamic>>.from(data);
          if (students.isNotEmpty) {
            selectedStudentId = students.first['id'].toString();
            loadSelectedStudentData(selectedStudentId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los estudiantes');
      }
    } catch (e) {
      print("Error al cargar los estudiantes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Estudiante'),
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
                value: selectedStudentId,
                hint: Text('Selecciona un estudiante'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStudentId = newValue!;
                    loadSelectedStudentData(selectedStudentId);
                  });
                },
                items: students.map<DropdownMenuItem<String>>((student) {
                  return DropdownMenuItem<String>(
                    value: student['id'].toString(),
                    child:
                        Text('${student['firstName']} ${student['lastName']}'),
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
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              TextFormField(
                controller: classRoomIdController,
                decoration: InputDecoration(labelText: 'ID Aula'),
              ),
              TextFormField(
                controller: parentIdController,
                decoration: InputDecoration(labelText: 'ID Padre'),
              ),
              TextFormField(
                controller: idTypeController,
                decoration: InputDecoration(labelText: 'Tipo de ID'),
              ),
              ElevatedButton(
                onPressed: () {
                  updateStudentData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedStudentData(String studentId) {
    Map<String, dynamic> student =
        students.firstWhere((student) => student['id'].toString() == studentId);
    setState(() {
      identificationController.text = student['identification'];
      firstNameController.text = student['firstName'];
      lastNameController.text = student['lastName'];
      emailController.text = student['email'];
      usernameController.text = student['username'];
      passwordController.text = student['password'];
      classRoomIdController.text = student['classroom']['id'].toString();
      parentIdController.text = student['parent']['id'].toString();
      idTypeController.text = student['id_type'];
    });
  }

  Future<void> updateStudentData() async {
    String identification = identificationController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    int classRoomId = int.parse(classRoomIdController.text);
    int parentId = int.parse(parentIdController.text);
    String idType = idTypeController.text;

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/student/update');
      Map data = {
        'id': selectedStudentId,
        'id_type': idType,
        'identification': identification,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'password': password,
        'classroom': {"id": classRoomId},
        'parent': {"id": parentId},
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

      fetchStudents();
    } catch (e) {
      print("Error al editar el estudiante: $e");
    }
  }
}
