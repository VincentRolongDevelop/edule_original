import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../adminPage.dart';

class EditParentPage extends StatefulWidget {
  @override
  _EditParentPageState createState() => _EditParentPageState();
}

class _EditParentPageState extends State<EditParentPage> {
  late List<Map<String, dynamic>> parents;
  String selectedParentId = '';

  TextEditingController identificationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    parents = [];
    fetchParents();
  }

  Future<void> fetchParents() async {
    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/parent/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          parents = List<Map<String, dynamic>>.from(data);
          if (parents.isNotEmpty) {
            selectedParentId = parents.first['id'].toString();
            loadSelectedParentData(selectedParentId);
          }
        });
      } else {
        throw Exception('No se pueden cargar los padres');
      }
    } catch (e) {
      print("Error al cargar los padres: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Padre'),
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
                    loadSelectedParentData(selectedParentId);
                  });
                },
                items: parents.map<DropdownMenuItem<String>>((parent) {
                  return DropdownMenuItem<String>(
                    value: parent['id'].toString(),
                    child: Text('${parent['firstName']} ${parent['lastName']}'),
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
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Dirección'),
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
                  updateParentData();
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadSelectedParentData(String parentId) {
    Map<String, dynamic> parent =
        parents.firstWhere((parent) => parent['id'].toString() == parentId);
    setState(() {
      identificationController.text = parent['identification'];
      firstNameController.text = parent['firstName'];
      lastNameController.text = parent['lastName'];
      emailController.text = parent['email'];
      phoneController.text = parent['phoneNumber'];
      addressController.text = parent['address'];
      usernameController.text = parent['username'];
      passwordController.text = parent['password'];
      idTypeController.text = parent['id_type'];
    });
  }

  Future<void> updateParentData() async {
    String identification = identificationController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    String idType = idTypeController.text;

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/parent/update');
      Map data = {
        'id': selectedParentId,
        'firstName': firstName,
        'lastName': lastName,
        'identification': identification,
        'phoneNumber': phone,
        'address': address,
        'username': username,
        'password': password,
        'id_type': idType,
        'email': email,
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

      fetchParents();
    } catch (e) {
      print("Error al editar el padre: $e");
    }
  }
}
