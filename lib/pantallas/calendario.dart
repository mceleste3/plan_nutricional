import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_nutricional/clases/comidas.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendario extends StatefulWidget {
  const Calendario({Key? key}) : super(key: key);

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime daySelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: comidaListSnapshots(user.uid),
        builder: (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final comidas = snapshot.data!;
          return Padding(
            padding:
                const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 15),
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
                        focusedDay: daySelected,
                        currentDay: daySelected,
                        onDaySelected: (DateTime selected, DateTime focused) {
                          setState(() {
                            daySelected = selected;
                          });
                        },
                        eventLoader: (DateTime date) {
                          final fixedDate = DateTime(2022, 5, 17);
                          debugPrint("$date $fixedDate");
                          if (date.year == fixedDate.year &&
                              date.month == fixedDate.month &&
                              date.day == fixedDate.day) {
                            return ["hola"];
                          }
                          return [];
                        },
                      ),
                    ),
                  ),
                ),
                Text("$daySelected"),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      ZonaBoton(
                        text: 'Selección del \n       menú',
                        child: DropdownButton(
                          value: comidas[0].nombre,
                          items: [
                            for (int i = 0; i < comidas.length; i++)
                              DropdownMenuItem<String>(
                                value: comidas[i].nombre,
                                child: Text(comidas[i].nombre.substring(0, 6)),
                                onTap: () {
                                  debugPrint(
                                    "Has seleccionado la comida ${comidas[i].nombre}",
                                  );
                                },
                              )
                          ],
                          onChanged: (String? selectedValue) {
                            debugPrint(
                              "Ha cambiado el valor a $selectedValue",
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      ZonaBoton(
                        text:
                            '             Programar \n medicación/suplementos',
                        child: Boton(
                          icon: Icons.medication,
                          onPressed: () {
                            Navigator.of(context).pushNamed('/programar');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ZonaBoton extends StatelessWidget {
  const ZonaBoton({
    Key? key,
    required this.text,
    required this.child,
  }) : super(key: key);

  final String text;
  final Widget child;

  /*

() {
              if (i == 1) {
                Navigator.of(context).pushNamed('/programar');
              } else {

              }
            }
  */
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Text(text, style: const TextStyle(fontSize: 14)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

class Boton extends StatelessWidget {
  const Boton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size(50, 33),
      ),
    );
  }
}
