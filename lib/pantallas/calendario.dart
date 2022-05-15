import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(224, 212, 250, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color.fromARGB(255, 166, 98, 178)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Color.fromARGB(139, 92, 18, 145),
                      ),
                    ]),
                child: TableCalendar(
                  //  formatButtonVisible: false,
                  calendarFormat: CalendarFormat.month,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2100, 3, 14),
                  focusedDay: DateTime.now(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: const [
                SizedBox(width: 25),
                Boton(
                  text: 'Selección del \n       menú',
                  icon: Icons.edit_calendar,
                  i: 0,
                ),
                SizedBox(width: 40),
                Boton(
                    text: '             Programar \n medicación/suplementos',
                    icon: Icons.medication,
                    i: 1)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Boton extends StatelessWidget {
  const Boton(
      {Key? key, required this.text, required this.icon, required this.i})
      : super(key: key);
  final String text;
  final IconData icon;
  final int i;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: const TextStyle(fontSize: 14)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (i == 1) {
                Navigator.of(context).pushNamed('/programar');
              } else {}
            },
            child: Icon(icon),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(50, 33),
            ),
          ),
        ),
      ],
    );
  }
}
