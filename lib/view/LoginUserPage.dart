import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'userPages/admin/adminPage.dart';
import 'userPages/teacher/teacherPage.dart';
import 'userPages/student/StudentPage.dart';
import 'userPages/cordinator/CordinatorPage.dart';
import 'userPages/parent/ParentPage.dart';
import '../controllers/DatabaseHelper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_application_1/view/userPages/admin/components/bottom_navigation_menu.dart';

import 'userPages/student/ViewStudentSchedulePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    // Simula un tiempo de carga de la imagen (reemplaza esto con la carga real de la imagen)
    await Future.delayed(Duration(seconds: 2));

    // Cambia el estado para indicar que la carga ha finalizado
    setState(() {
      _loading = false;
    });
  }

  void _login() async {
    if (_formKey.currentState!.saveAndValidate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      try {
        Map<String, dynamic>? user =
            await DataBaseHelper().loginUser(username, password);

        print(user);

        if (user != null) {
          if (user['role_id'] == 1) {
            _navigateToPage(context, AdminPage());
          } else if (user['role_id'] == 2) {
            _navigateToPage(context, TeacherPage());
          } else if (user['role_id'] == 3) {
            _navigateToPage(context, CordinatorPage());
          } else if (user['role_id'] == 5) {
            _navigateToPage(context, ParentPage());
          } else if (user['role_id'] == 6) {
            _navigateToPage(
                context, ViewStudentSchedulePage(loggedInUser: user));
          }
        } else {
          _showErrorDialog("Usuario o contraseña incorrectos");
        }
      } catch (e) {
        _showErrorDialog("Usuario o contraseña incorrectos");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(
            color: Colors.blue, // Puedes cambiar el color según tus necesidades
            size: 50.0,
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? _buildLoadingScreen()
          : SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.infinity,
                          child: Image.asset(
                            'assets/pd.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Color(0xFF37AFC8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: FormBuilderTextField(
                            name: 'username',
                            controller: _usernameController,
                            focusNode: _usernameFocus,
                            decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[600]),
                              filled: true,
                              fillColor: Color(0xAAE0E0E0),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xAAE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xAAE0E0E0),
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),
                          child: FormBuilderTextField(
                            name: 'password',
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[600]),
                              filled: true,
                              fillColor: Color(0xAAE0E0E0),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xAAE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Color(0xAAE0E0E0),
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 80.0),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  primary: Color(0xFF37AFC8),
                                  onPrimary: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login,
                                        size: 24.0,
                                        color: Colors
                                            .white), // Agregué el icono de "Log In"
                                    SizedBox(
                                        width:
                                            8.0), // Añadí un espacio entre el icono y el texto
                                    Text(
                                      "Log in",
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
