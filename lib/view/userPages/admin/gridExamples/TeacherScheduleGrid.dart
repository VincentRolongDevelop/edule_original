import 'package:flutter/material.dart';

class TeacherScheduleGrid extends StatelessWidget {
  List<String> daysOfWeek = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'];
  List<String> hoursOfDay = [
    '9 AM',
    '10 AM',
    '11 AM',
    '12 PM',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM'
  ];

  // Agregamos una lista de materias para cada día y hora
  List<List<String>> subjects = [
    ['Math', 'Physics', 'English', 'History', 'Biology', 'Physics', 'History'],
    ['History', 'Biology', 'Math', 'Physics', 'English', 'Physics', 'History'],
    ['English', 'History', 'Physics', 'Biology', 'Math', 'Physics', 'History'],
    ['Physics', 'Math', 'History', 'English', 'Biology', 'Physics', 'History'],
    ['Biology', 'English', 'Math', 'Physics', 'History', 'Physics', 'History'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDaysOfWeek(context),
            _buildWeeklySchedule(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDaysOfWeek(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
              width: 0.14 * MediaQuery.of(context).size.width), // Ajuste aquí
          for (String day in daysOfWeek)
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color(0xFF39AFC9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < hoursOfDay.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 0.14 *
                        MediaQuery.of(context).size.width, // Ajuste del ancho
                    padding: EdgeInsets.only(top: 37, bottom: 34),
                    decoration: BoxDecoration(
                      color: Color(0xFF39AFC9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        hoursOfDay[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  for (int j = 0; j < daysOfWeek.length; j++)
                    Container(
                      width: 0.14 * MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 0.1 *
                                MediaQuery.of(context)
                                    .size
                                    .height, // Proporcional al tamaño de la pantalla
                            child: Text(
                              subjects[j].length > i ? subjects[j][i] : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 0.02 *
                                    MediaQuery.of(context)
                                        .size
                                        .width, // Proporcional al tamaño de la pantalla
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
