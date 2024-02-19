import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/userPages/admin/adminAction/view/ViewScheduleDayPage.dart';
import 'package:flutter_application_1/view/userPages/notification/notification.dart';

// Importaciones relacionadas con la creación
import 'adminAction/create/CreateUserPage.dart';
import 'adminAction/create/CreateParentPage.dart';
import 'adminAction/create/CreateStudentPage.dart';
import 'adminAction/create/CreateClassRoomPage.dart';
import 'adminAction/create/CreateCyclePage.dart';
import 'adminAction/create/CreateHourPage.dart';
import 'adminAction/create/CreateHourDayPage.dart';
import 'adminAction/create/CreateSubjectClassRoom.dart';
import 'adminAction/create/CreateTopicContent.dart';
import 'adminAction/create/CreateUserSubject.dart';
import 'adminAction/create/CreateSchedulePage.dart';
import 'adminAction/create/CreateSubjectPage.dart';
import 'adminAction/create/CreateRolePage.dart';
import 'adminAction/create/CreateTopicPage.dart';
import 'adminAction/create/CreateDayPage.dart';

// Importaciones relacionadas con la edición
import 'adminAction/edit/EditUserPage.dart';
import 'adminAction/edit/EditParentPage.dart';
import 'adminAction/edit/EditStudentPage.dart';
import 'adminAction/edit/EditClassRoomPage.dart';
import 'adminAction/edit/EditSubjectPage.dart';
import 'adminAction/edit/EditRolePage.dart';
import 'adminAction/edit/EditTopicPage.dart';
import 'adminAction/edit/EditDayPage.dart';
import 'adminAction/edit/EditCyclePage.dart';
import 'adminAction/edit/EditHourPage.dart';
import 'adminAction/edit/EditHourDayPage.dart';
import 'adminAction/edit/EditTopicContentPage.dart';
import 'adminAction/edit/EditSubjectClassroomPage.dart';
import 'adminAction/edit/EditUserSubjectPage.dart';
import 'adminAction/edit/EditSchedulePage.dart';

// Importaciones relacionadas con la eliminación
import 'adminAction/delete/DeleteUserPage.dart';
import 'adminAction/delete/DeleteParentPage.dart';
import 'adminAction/delete/DeleteStudentPage.dart';
import 'adminAction/delete/DeleteClassRoomPage.dart';
import 'adminAction/delete/DeleteSubjectPage.dart';
import 'adminAction/delete/DeleteRolePage.dart';
import 'adminAction/delete/DeleteTopicPage.dart';
import 'adminAction/delete/DeleteDayPage.dart';
import 'adminAction/delete/DeleteCyclePage.dart';
import 'adminAction/delete/DeleteHourPage.dart';
import 'adminAction/delete/DeleteHourDayPage.dart';
import 'adminAction/delete/DeleteSubjectClassRoomPage.dart';
import 'adminAction/delete/DeleteTopicSubjectPage.dart';
import 'adminAction/delete/DeleteUserSubjectPage.dart';
import 'adminAction/delete/DeleteSchedulePage.dart';

// Importaciones relacionadas con la vista
import 'adminAction/view/ViewAdminPage.dart';
import 'adminAction/view/ViewTeacherPage.dart';
import 'adminAction/view/ViewCordinatorPage.dart';
import 'adminAction/view/ViewStudentPage.dart';
import 'adminAction/view/ViewParentPage.dart';
import 'adminAction/view/ViewSubjectPage.dart';
import 'adminAction/view/ViewHourPage.dart';
import 'adminAction/view/ViewHourDayPage.dart';
import 'adminAction/view/ViewClassRoomPage.dart';
import 'adminAction/view/ViewTopicPage.dart';
import 'adminAction/view/ViewRolePage.dart';
import 'adminAction/view/ViewDayPage.dart';
import 'adminAction/view/ViewCyclePage.dart';
import 'adminAction/view/ViewUserSubject.dart';
import 'adminAction/view/ViewSubjectClassRoom.dart';
import 'adminAction/view/ViewTopicContentPage.dart';
import 'adminAction/view/ViewStudentByClassroomPaget.dart';
import 'adminAction/view/ViewTeacherByClassroomPage.dart';
import 'adminAction/view/viewParentByClassroomPage.dart';
import 'adminAction/view/ViewSubjectsByClassroomPage.dart';

// Importaciones adicionales
import '../../../controllers/DatabaseHelper.dart';
import '../../loginUserPage.dart';

class AdminPage extends StatefulWidget {
  @override
  _UserTypeSelectionPageState createState() => _UserTypeSelectionPageState();
}

class _UserTypeSelectionPageState extends State<AdminPage> {
  bool isParentTableEmpty = false;
  bool isSubjectTableEmpty = false;
  bool isDayTableEmpty = false;
  bool _isCreateExpanded = false;
  bool _isEditExpanded = false;
  bool _isDeleteExpanded = false;
  bool _isViewExpanded = false;
  bool _isAssignExpanded = false;
  bool _isNotificationExpanded = false;

  @override
  void initState() {
    super.initState();
    checkParentTableIsEmpty();
  }

  void checkParentTableIsEmpty() async {
    final dbHelper = DataBaseHelper();
    final isEmpty = await dbHelper.checkIfParentTableIsEmpty();
    final isEmpty2 = await dbHelper.checkIfSubjecTableIsEmpty();
    final isEmpty3 = await dbHelper.checkIfDayTableIsEmpty();

    setState(() {
      isParentTableEmpty = isEmpty;
      isSubjectTableEmpty = isEmpty2;
      isParentTableEmpty = isEmpty3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección a realizar'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(title: 'Iniciar Sesión')),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  setState(() {
                    if (panelIndex == 0) {
                      _isCreateExpanded = !_isCreateExpanded;
                      _isEditExpanded = false;
                      _isDeleteExpanded = false;
                      _isViewExpanded = false;
                      _isAssignExpanded = false;
                      _isEditExpanded = false;
                    } else if (panelIndex == 1) {
                      _isAssignExpanded = !_isAssignExpanded;
                      _isCreateExpanded = false;
                      _isEditExpanded = false;
                      _isDeleteExpanded = false;
                      _isViewExpanded = false;
                      _isNotificationExpanded = false;
                    } else if (panelIndex == 2) {
                      _isEditExpanded = !_isEditExpanded;
                      _isCreateExpanded = false;
                      _isAssignExpanded = false;
                      _isDeleteExpanded = false;
                      _isNotificationExpanded = false;
                      _isViewExpanded = false;
                    } else if (panelIndex == 3) {
                      _isDeleteExpanded = !_isDeleteExpanded;
                      _isCreateExpanded = false;
                      _isEditExpanded = false;
                      _isViewExpanded = false;
                      _isAssignExpanded = false;
                      _isNotificationExpanded = false;
                    } else if (panelIndex == 4) {
                      _isViewExpanded = !_isViewExpanded;
                      _isCreateExpanded = false;
                      _isEditExpanded = false;
                      _isDeleteExpanded = false;
                      _isAssignExpanded = false;
                      _isNotificationExpanded = false;
                    } else if (panelIndex == 5) {
                      _isNotificationExpanded = !_isNotificationExpanded;
                      _isCreateExpanded = false;
                      _isEditExpanded = false;
                      _isDeleteExpanded = false;
                      _isViewExpanded = false;
                      _isAssignExpanded = false;
                    }
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'CREAR',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isCreateExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationPage()),
                            );
                          },
                          child:
                              Text("Usuario", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateParentPage()),
                            );
                          },
                          child:
                              Text("Padre", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isParentTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateStudentPage()),
                                  );
                                },
                          child: Text("Estudiante",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateClassRoomPage()),
                            );
                          },
                          child: Text("Aula", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateSubjectPage()),
                            );
                          },
                          child: Text("Asignatura",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateRolePage()),
                            );
                          },
                          child: Text("Rol", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isSubjectTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateTopicPage()),
                                  );
                                },
                          child: Text("Tematicas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateDayPage()),
                            );
                          },
                          child: Text("Dias", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateCyclePage()),
                            );
                          },
                          child:
                              Text("Ciclos", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateHourPage()),
                            );
                          },
                          child:
                              Text("Horas", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'ASIGNAR',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isAssignExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateHourDayPage()),
                            );
                          },
                          child: Text("Asignar horas a dias",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateSubjectClassroomPage()),
                            );
                          },
                          child: Text("Asignar asignaturas a salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateTopicContentPage()),
                            );
                          },
                          child: Text("Contenido de tematicas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateUserSubjectPage()),
                            );
                          },
                          child: Text("Asignatura de usuario",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateSchedulePage()),
                            );
                          },
                          child: Text("Horarios",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'EDITAR',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isEditExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUserPage()),
                            );
                          },
                          child:
                              Text("Usuario", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditParentPage()),
                            );
                          },
                          child:
                              Text("Padre", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isParentTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditStudentPage()),
                                  );
                                },
                          child: Text("Estudiante",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditClassRoomPage()),
                            );
                          },
                          child: Text("Aula", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditSubjectPage()),
                            );
                          },
                          child: Text("Asignatura",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRolePage()),
                            );
                          },
                          child: Text("Rol", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isSubjectTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditTopicPage()),
                                  );
                                },
                          child: Text("Tematicas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditDayPage()),
                            );
                          },
                          child: Text("Dias", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isParentTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditCyclePage()),
                                  );
                                },
                          child:
                              Text("Ciclos", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditHourPage()),
                            );
                          },
                          child:
                              Text("Horas", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditHourDayPage()),
                            );
                          },
                          child: Text("Horas con Dias",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditSubjectClassroomPage()),
                            );
                          },
                          child: Text("Asignatura de salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTopicContentPage()),
                            );
                          },
                          child: Text("Contenido del tema",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUserSubjectPage()),
                            );
                          },
                          child: Text("Asignatura con Usuario",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditSchedulePage()),
                            );
                          },
                          child: Text("Horarios",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'BORRAR',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isDeleteExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteUserPage()),
                            );
                          },
                          child:
                              Text("Usuario", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteParentPage()),
                            );
                          },
                          child:
                              Text("Padre", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteStudentPage()),
                            );
                          },
                          child: Text("Estudiante",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteClassRoomPage()),
                            );
                          },
                          child: Text("Aula", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteSubjectPage()),
                            );
                          },
                          child: Text("Asignatura",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteRolePage()),
                            );
                          },
                          child: Text("Rol", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteTopicPage()),
                            );
                          },
                          child: Text("Tematicas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteDayPage()),
                            );
                          },
                          child: Text("Dias", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteCyclePage()),
                            );
                          },
                          child:
                              Text("Ciclos", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteHourPage()),
                            );
                          },
                          child:
                              Text("Horas", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteHourDayPage()),
                            );
                          },
                          child: Text("Horas del dia",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteSubjectClassRoomPage()),
                            );
                          },
                          child: Text("Asignaturas en salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteTopicContentPage()),
                            );
                          },
                          child: Text("Contenido del tema",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeleteUserSubjectPage()),
                            );
                          },
                          child: Text("Asignaturas de usuario",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteSchedulePage()),
                            );
                          },
                          child: Text("Horarios",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'VER',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isViewExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewAdminPage()),
                            );
                          },
                          child:
                              Text("Admins", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewTeacherPage()),
                            );
                          },
                          child: Text("Profesores",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCoordinatorPage()),
                            );
                          },
                          child: Text("Cordinadores academicos",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: isParentTableEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewStudentPage()),
                                  );
                                },
                          child: Text("Estudiantes",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewParentPage()),
                            );
                          },
                          child:
                              Text("Padres", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewClassRoomPage()),
                            );
                          },
                          child:
                              Text("Aulas", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewSubjectPage()),
                            );
                          },
                          child: Text("Asignaturas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewRolePage()),
                            );
                          },
                          child: Text("Rol", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewTopicPage()),
                            );
                          },
                          child: Text("Tematicas",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewDayPage()),
                            );
                          },
                          child: Text("Dias", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewCyclePage()),
                            );
                          },
                          child:
                              Text("Ciclos", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewHourPage()),
                            );
                          },
                          child:
                              Text("Horas", style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewHourDayPage()),
                            );
                          },
                          child: Text("Relación hora dia",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewUserSubjectPage()),
                            );
                          },
                          child: Text("Tema y profesor",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewSubjectClassroomPage()),
                            );
                          },
                          child: Text("Asignatura y Salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewTopicContentPage()),
                            );
                          },
                          child: Text("Topico con tema",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewScheduleDayPage(),
                              ),
                            );
                          },
                          child: Text("Horarios",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewStudentsByClassroomPage(),
                              ),
                            );
                          },
                          child: Text("Estudiantes de salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewTeachersByClassroomPage(),
                              ),
                            );
                          },
                          child: Text("Profesores de salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewParentsByClassroomPage(),
                              ),
                            );
                          },
                          child: Text("Padres de salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewSubjectsByClassroomPage(),
                              ),
                            );
                          },
                          child: Text("Asignaturas de salon",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Container(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Text(
                          'CREAR NOTIFICACIONES',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    isExpanded: _isNotificationExpanded,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationView(
                                        title: 'Notificación',
                                      )),
                            );
                          },
                          child: Text("Notificaciones",
                              style: TextStyle(fontSize: 18.0)),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
