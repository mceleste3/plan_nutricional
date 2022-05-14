import 'dart:ui';

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
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(224, 212, 250, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color.fromARGB(255, 166, 98, 178)),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color.fromARGB(139, 92, 18, 145),
                    ),
                  ]),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2100, 3, 14),
                focusedDay: DateTime.now(),
              ),
            ),
          ),
          const SizedBox(
            height: 65,
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Boton(
                  text: 'Selección del \n       menú',
                  icon: Icons.edit_calendar,
                ),
                Boton(
                    text: '             Programar \n medicación/suplementos',
                    icon: Icons.medication)
              ],
            ),
          ),
        ],
      ),
    );

    ;
  }
}

class Boton extends StatelessWidget {
  Boton({Key? key, required this.text, required this.icon}) : super(key: key);
  String text;
  IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: TextStyle(fontSize: 14)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {},
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
