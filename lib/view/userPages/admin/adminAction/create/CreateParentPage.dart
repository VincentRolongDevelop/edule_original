import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../admin/adminPage.dart';

class CreateParentPage extends StatefulWidget {
  static bool isParentTableEmpty = true;
  const CreateParentPage({Key? key}) : super(key: key);

  @override
  _CreateParentPageState createState() => _CreateParentPageState();
}

class _CreateParentPageState extends State<CreateParentPage> {
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _identificationController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _idTypeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _createParent() async {
    try {
      String newUsername = _newUsernameController.text;
      String newPassword = _newPasswordController.text;
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String identification = _identificationController.text;
      String phone = _phoneController.text;
      String address = _addressController.text;
      String idType = _idTypeController.text;
      String email = _emailController.text;

      if (newUsername.isNotEmpty &&
          newPassword.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          identification.isNotEmpty &&
          phone.isNotEmpty &&
          address.isNotEmpty &&
          idType.isNotEmpty &&
          email.isNotEmpty) {
        var url = Uri.parse('http://10.0.2.2:8080/api/parent/save');
        Map data = {
          'firstName': firstName,
          'lastName': lastName,
          'identification': identification,
          'phoneNumber': phone,
          'address': address,
          'username': newUsername,
          'password': newPassword,
          'id_type': idType,
          'email': email,
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
            content: Text('Se creó un nuevo padre'),
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
      print('Error al crear el padre: $e');
      // Puedes mostrar un mensaje de error aquí
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el padre')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Padre'),
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
                  Text("Registro de Padre", style: TextStyle(fontSize: 24.0)),
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
                    controller: _identificationController,
                    decoration: InputDecoration(
                      labelText: "Cédula de Ciudadanía",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Número de Teléfono",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Dirección",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _idTypeController,
                    decoration: InputDecoration(
                      labelText: "Tipo de Identificación",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Correo Electrónico",
                      labelStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _createParent,
            child: Text("Crear Padre", style: TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
    );
  }
}
