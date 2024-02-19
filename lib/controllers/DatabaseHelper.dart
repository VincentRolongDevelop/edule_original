import 'package:http/http.dart' as http;
import 'dart:convert';

class DataBaseHelper {
  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/login');
    final response = await http.get(url);
    print("AQUII");
    print(response);
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> users = List<Map<String, dynamic>>.from(data);

      Map<String, dynamic>? foundUser;
      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          foundUser = user;
          break;
        }
      }

      if (foundUser != null && foundUser.containsKey('role_id')) {
        return foundUser;
      } else {
        throw Exception('Usuario no encontrado o sin role_id');
      }
    } else {
      throw Exception('No se pueden cargar los usuarios');
    }
  }

  Future<bool> checkIfParentTableIsEmpty() async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/api/parent/all'); // Cambiado a "/all" para obtener todos los padres

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> parents = json.decode(response.body);

        // Devuelve true si la lista de padres está vacía, lo que significa que la tabla está vacía
        return false;
      } else {
        // Puedes manejar el error según tus necesidades
        print('Error en la solicitud: ${response.statusCode}');
        return true;
      }
    } catch (e) {
      // Manejar excepciones, si es necesario
      print('Error al realizar la solicitud: $e');
      return true;
    }
  }

  Future<bool> checkIfSubjecTableIsEmpty() async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/api/subject/all'); // Cambiado a "/all" para obtener todos los padres

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> parents = json.decode(response.body);

        // Devuelve true si la lista de padres está vacía, lo que significa que la tabla está vacía
        return false;
      } else {
        // Puedes manejar el error según tus necesidades
        print('Error en la solicitud: ${response.statusCode}');
        return true;
      }
    } catch (e) {
      // Manejar excepciones, si es necesario
      print('Error al realizar la solicitud: $e');
      return true;
    }
  }

  Future<bool> checkIfDayTableIsEmpty() async {
    var url = Uri.parse(
        'http://10.0.2.2:8080/api/day/all'); // Cambiado a "/all" para obtener todos los padres

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> parents = json.decode(response.body);

        // Devuelve true si la lista de padres está vacía, lo que significa que la tabla está vacía
        return false;
      } else {
        // Puedes manejar el error según tus necesidades
        print('Error en la solicitud: ${response.statusCode}');
        return true;
      }
    } catch (e) {
      // Manejar excepciones, si es necesario
      print('Error al realizar la solicitud: $e');
      return true;
    }
  }
}
